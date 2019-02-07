'use strict';

const express = require('express');
const bodyParser = require('body-parser');
require('dotenv').config();
const mongoose = require('mongoose');
const app = express();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const User = require('./models/user');
const Post = require('./models/post');

// Middleware
app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());

const port = process.env.PORT || 8080;
const router = express.Router();

// ============
// Middleroutes
// ============
// Make sure x-access-token is present for certain endpoints
router.use(function(req, res, next) {
  let rootPath = req.path.split('/')[1];
  console.log('Receiving request to path: /' + rootPath);
  if (rootPath && (rootPath === 'users' || rootPath === 'posts')) {

    // Exclusions
    if (rootPath === 'users' && req.method === 'POST') {
      next();
      return;
    }

    let token = req.headers['x-access-token'];
    if (!token) {
      return res.status(401).send({ error: 'No token provided.' });
    }
  }
  next();
});

// Rate limiter for non-device API end-users
router.use(function(req, res, next) {
  // Todo: Implement
  next();
});

// ============
// Internal API
// ============
function _unauthorized(res) {
  return res.status(500).send({ message: 'Failed to authenticate token.' });
}

function _signJWT(id) {
  return jwt.sign({id: id}, process.env.SECRET, {expiresIn: 86400});
}

// ==========
// API Routes
// ==========
// Ping route
router.get('/', function(req, res) {
  return res.json({ message: 'Welcome to our API!' });
});

// Login route
router.route('/login').post(function(req, res) {
  // Todo: Validate
  // Todo: Handle max attempts
  User.findOne({ username: req.body.username }, 'password', function(err, user) {
    // Todo: Handle errors
    if (err) return res.send(err);
    if (!bcrypt.compareSync(req.body.password, user.password)) return res.send({ message: 'Wrong username or password.', code: -1 });
    let token = _signJWT(user._id);
    return res.json({ message: 'Logged in!', token: token, user_id: user._id });
  });
});

// Users
router.route('/users').post(function(req, res) {
  // Registration
  // Check: Validation
  if (!req.body.username || !req.body.password)
    return res.send({ message: 'Missing data.', code: -1 });
  
  if (!req.body.username.match('^([A-Za-z0-9]{1,20})$')) {
    return res.send({ message: 'Username invalid.', code: -2 });
  }

  if (!req.body.password.match('^([A-Za-z0-9\W]{6,20})$')) {
    return res.send({ message: 'Password invalid.', code: -3 });
  }
  
  let username = req.body.username;
  let password = bcrypt.hashSync(req.body.password, 8);
  let user = new User({ username: username, password: password, posts: [] });

  user.save(function(err) {
    if (err) {
      if (err.code === 11000) {
        return res.send({ message: 'Username already exists.', code: -4 });
      }
      return res.send(err);
    }

    let token = _signJWT(user._id);
    res.json({ message: 'User created!', token: token, user_id: user._id });
  });
}).get(function(req, res) {
  // Get users
  let token = req.headers['x-access-token'];
  jwt.verify(token, process.env.SECRET, function(err, decoded) {
    if (err) return _unauthorized(res);
  });
  User.find(function(err, users) {
    if (err) return res.send(err);
    res.json(users);
  }, '-password');
});

// User by ID
router.route('/users/:user_id').get(function(req, res) {
  // Check: Auth
  let token = req.headers['x-access-token'];
  jwt.verify(token, process.env.SECRET, function(err, decoded) {
    if (err) return _unauthorized(res);
  });

  User.findById(req.params.user_id, '-password', function(err, user) {
    if (err) return res.send(err);
    res.json(user);
  });
  
}).put(function(req, res) {
  // Check: Auth, user can only update own user
  let token = req.headers['x-access-token'];
  jwt.verify(token, process.env.SECRET, function(err, decoded) {
    if (err || req.params.user_id !== decoded.id) return _unauthorized(res);
  });

  User.findById(req.params.user_id, function(err, user) {
    if (err) return res.send(err);
    // Check: Which attributes are being updated
    if (req.body.password) {
      user.password = bcrypt.hashSync(req.body.password, 8);
    }
    user.save(function(err) {
      if (err) return res.send(err);
      res.json({ message: 'User updated!' });
    });
  });
}).delete(function(req, res) {
  // Check: Auth, user can only delete own user
  let token = req.headers['x-access-token'];
  jwt.verify(token, process.env.SECRET, function(err, decoded) {
    if (err || req.params.user_id !== decoded.id) return _unauthorized(res);
  });
  User.deleteOne({ 
    _id: req.params.user_id
  }, function(err, user) {
    if (err) return res.json(err);
    res.json({ message: 'User deleted!' });
  });
});

// Posts
router.route('/posts').post(function(req, res) {
  // Check: Auth
  let post = new Post({
    name: req.body.name
  });

  let token = req.headers['x-access-token'];
  jwt.verify(token, process.env.SECRET, function(err, decoded) {
    if (err) return _unauthorized(res);
    User.findById(decoded.id, function(err, user) {
      post.save(function(err) {
        if (err) return res.json(err);
        res.json({ messsage: 'Posted!' });
      });
    });
  });
});

// =========
// Execution
// =========

// Register routes
app.use('/api', router);

// Start database connection
mongoose.connect(process.env.DB_CONN, { useNewUrlParser: true, useCreateIndex: true });
const db = mongoose.connection;
db.on('error', console.error.bind(console, 'Connection error:'));
db.once('open', function() {

  console.log('Connection to database successful');

  // Start server
  app.listen(port, function() {
    console.log('Server has been started on port ' + port);
  });

});