'use strict';

const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const express = require('express');
require('dotenv').config();
const shortid = require('shortid');

const User = require('./models/user');
const Post = require('./models/post');
const Mailer = require('./mailer');

const router = express.Router();
const upload = require('./multer/upload');

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
      return res.json({ code: -99, message: 'No token provided.' });
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
  User.findOne({ email: req.body.email }, '+password', function(err, user) {
    // Todo: Handle errors
    if (err) return res.send(err);
    if (!user) return res.json({ message: 'User not found!', code: 0 });

    if (!bcrypt.compareSync(req.body.password, user.password)) return res.send({ message: 'Wrong email or password.', code: -1 });
    let token = _signJWT(user._id);
    return res.json({ message: 'Logged in!', token: token, user_id: user._id, provider: user.provider, code: 1 });
  });
});

// Users
router.route('/users').post(function(req, res) {
  // Registration
  // Check: Validation
  if (!req.body.email || !req.body.password || !req.body.email)
    return res.send({ message: 'Missing data.', code: -1 });
  
  if (!req.body.name.match('^([A-Za-z0-9 ]{1,20})$')) {
    return res.send({ message: 'Name invalid.', code: -2 });
  }

  if (!req.body.password.match('^([A-Za-z0-9\W]{6,20})$')) {
    return res.send({ message: 'Password invalid.', code: -3 });
  }
  // Check email regex

  let provider = false;
  if (req.body.provider) {
    provider = true;
  }

  let name = req.body.name;
  let password = bcrypt.hashSync(req.body.password, 8);
  let email = req.body.email;
  let emailToken = shortid.generate();
  let user = new User({ name: name, password: password, email: email, posts: [],
    emailToken: emailToken, provider: provider });

  user.save(function(err) {
    if (err) {
      console.log(err);
      if (err.code === 11000) {
        return res.send({ message: 'Email already exists.', code: -4 });
      }
      return res.send(err);
    }

    let token = _signJWT(user._id);
    let response = { message: 'User created!', token: token, user_id: user._id, provider: provider, code: 1 };
    res.json(response);
    // Send an email here
    /** mailer.sendMail(email).then(function(info) {
      console.log('Sent email verify to ' + email);
    });*/
  });
}).get(function(req, res) {
  // Get users (required?)
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
    if (!user) return res.json({ message: 'User not found!', code: -1});
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
    if (!user) return res.json({ message: 'User not found!', code: -1 });
    // Check: Which attributes are being updated
    if (req.body.password) {
      user.password = bcrypt.hashSync(req.body.password, 8);
    }
    user.save(function(err) {
      if (err) return res.send(err);
      res.json({ message: 'User updated!', code: 1 });
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
    if (!user) return res.json({ message: 'User not found!', code: -1 });
    res.json({ message: 'User deleted!', code: 1 });
  });

});

// Verify email
router.route('/users/verify/:user_id').post(function(req, res) {
  // Todo: Validate data
  let token = req.headers['x-access-token'];
  jwt.verify(token, process.env.SECRET, function(err, decoded) {
    if (err || req.params.user_id !== decoded.id) return _unauthorized(res);
    User.findById(req.params.user_id, function(err, user) {
      
      if (!user) return res.json({ message: 'User not found!', code: -1 });
      if (!req.body.emailToken) return res.json({ message: 'No email token provided.', code: -2 });
      if (user.emailToken !== req.body.emailToken) return res.json({ message: 'Wrong email token', code: -3 });
      if (err) return res.send(err);

      user.emailToken = '*';
      user.save(function(err) {
        if (err) return res.send(err);
        res.json({ message: 'Email verified!', code: 1 });
      });

    });
  });

});

// Posts
router.route('/posts').post(function(req, res) {
  let token = req.headers['x-access-token'];
  jwt.verify(token, process.env.SECRET, function(err, decoded) {
    if (err) return _unauthorized(res);
    User.findById(decoded.id, function(err, user) {
      if (!user) return res.json({ message: 'User not found!', code: -1 });
      if (err) return res.send(err);
      if (!user.provider) return res.json({ message: 'You are not a provider!', code: -2});
      req.user = user;
      });
  });
  
}, upload.single('post-image'), function(req, res) {
  // Check: Auth
  // Post-upload

  if (!req.body.name || !req.body.description || !req.body.tags) {
    return res.json({ message: 'Missing a field.', code: -3});
  }

  if (err || !req.file) {
    return res.json({ message: 'Could not upload image!', code: -4});
  }

  let post = new Post({
    name: req.body.name,
    description: req.body.description,
    image: req.file.location,
    tags: req.body.tags
  });

  post.save(function(err) {
    if (err) {
      console.log(err);
      return res.json({ message:'Unknown save error', code: -202 });
    }
    // Implement update user in database
    let user = req.user;
    let posts = user.posts;
    posts.push(post._id);

    user.save(function(err) {
      if (err) {
        console.log(err);
        return res.json({ message:'Unknown save error user', code: -203});
      }
      return res.json({ message: 'Posted!', code: 1 });
    });
  });
}).get(function(req, res) {
  // Implement
  let token = req.headers['x-access-token'];
  jwt.verify(token, process.env.SECRET, function (err, decoded) {
    if (err) return _unauthorized(res);
    let tags = [];
    if (req.body.tags) tags = req.body.tags;
    let filter = tags === [] ? {} : {tags: tags};
    Post.find(filter, (err, posts) => {
      if (err) {
        console.log(err);
        return res.json({ message: 'Could not get posts', code: -199});
      }
      return res.json({code: 1, posts: posts});
    });
  });
});

module.exports = router;