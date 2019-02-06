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

// Route middleware to check for token
router.use(function(req, res, next) {

    let rootPath = req.path.split('/')[1];
    console.log('Authenticating request to path: /' + rootPath);
    if (rootPath && (rootPath === 'users' || rootPath === 'posts')) {

      // Exclusions
      if (rootPath === 'users' && releaseEvents.method === 'POST') next();

      let token = req.headers['x-access-token'];
      if (!token) {
        return res.status(401).send({ error: 'No token provided.' });
      }
    }
    next();
});

// ==========
// API Routes
// ==========

// Ping route
router.get('/', function(req, res) {
  res.json({ message: 'Welcome to our API!' });
});

// Login route
router.route('/login').post(function(req, res) {

});

// Users
router.route('/users').post(function(req, res) {
  // Registration
  let username = req.body.username;
  let password = bcrypt.hashSync(req.body.password, 8);

  let user = new User({ username: username, password: password, posts: [] });
  user.save(function(err) {
    if (err) res.send(err);

    let token = jwt.sign({id: user._id}, process.env.SECRET, {expiresIn: 86400})
    res.json({ message: 'User created!', token: token });
  });
}).get(function(req, res) {
  // TODO: Needs auth
  User.find(function(err, users) {
    if (err) res.send(err);
    res.json(users);
  });
});

// User by ID
router.route('/users/:user_id').get(function(req, res) {
  // TODO: Needs auth 
  User.findById(req.params.user_id, function(err, user) {
    if (err) res.send(err);
    res.json(user);
  });
}).put(function(req, res) {
  // TODO: Needs auth
  User.findById(req.params.user_id, function(err, user) {
    if (err) res.send(err);
    // TODO: Check which attributes are being updated
    user.username = req.body.username;
    user.save(function(err) {
      if (err) res.send(err);
      res.json({ message: 'User updated!' });
    });
  });
}).delete(function(req, res) {
  // TODO: Needs auth
  User.deleteOne({ 
    _id: req.params.user_id
  }, function(err, user) {
    if (err) res.json(err);
    res.json({ message: 'User deleted!' });
  });
});

// Posts
router.route('/posts').post(function(req, res) {
  // TODO: Needs auth
  let post = new Post({
    name: req.body.name
  });

  User.findById(req.params.user_id, function(err, user) {
    post.save(function(err) {
      if (err) res.json(err);
      res.json({ messsage: 'Posted!' });
    });
  });
});

// =========
// Execution
// =========

// Register routes
app.use('/api', router);

// Start database connection
mongoose.connect(process.env.DB_CONN, { useNewUrlParser: true });
const db = mongoose.connection;
db.on('error', console.error.bind(console, 'Connection error:'));
db.once('open', function() {

  console.log('Connection to database successful');

  // Start server
  app.listen(port);
  console.log('Server has been started on port ' + port);

});