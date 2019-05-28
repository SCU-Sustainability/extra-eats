'use strict';

const express = require('express');
const bodyParser = require('body-parser');
require('dotenv').config();
const mongoose = require('mongoose');
const app = express();

const routes = require('./src/routes');

const port = process.env.PORT || 8080;

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use('/api', routes);

// Start database connection
mongoose.connect(process.env.DB_CONN, {
  useNewUrlParser: true,
  useCreateIndex: true
});
const db = mongoose.connection;
db.on('error', console.error.bind(console, 'Connection error:'));
db.once('open', function() {
  console.log('Connection to database successful');

  // Start server
  app.listen(port, '0.0.0.0', function() {
    console.log('Server has been started on port ' + port);
  });
});

const background = require('./src/background.js'); 
background.updatePostStatus(); 
