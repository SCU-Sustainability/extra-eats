'use strict';

const express = require('express');
const bodyParser = require('body-parser');
require('dotenv').config();
const mongoose = require('mongoose');
const app = express();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const User = require('./models/user');
const Event = require('./models/event');

// Middleware
app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());

const port = process.env.PORT || 8080;

const router = express.Router();

// Ping route
router.get('/', function(req, res) {
  res.json({ message: 'Welcome to our API!' });
});

// Intercept routes
router.use(function(req, res, next) {
  // TODO: Check /users and /events for credential token
  next();
});

// Login route
router.route('/login').post(function(req, res) {

});

// Users
router.route('/users').post(function(req, res) {
  // TODO: Create a token
  let user = new User({ username: req.body.username });
  user.save(function(err) {
    if (err) res.send(err);
    res.json({ message: 'User created!'});
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

// Events
router.route('/events').post(function(req, res) {

  let event = new Event({
    name: req.body.name
  });

  User.findById(req.params.user_id, function(err, user) {
    event.save(function(err) {
      if (err) res.json(err);
      res.json({ messsage: 'Event posted!' });
    });
  });
});

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