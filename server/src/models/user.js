'use strict';

var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var ObjectId = mongoose.Schema.Types.ObjectId;

var UserSchema = new Schema({
  username: {
    type: String,
    required: true,
    unique: true
  },
  password: {
    type: String,
    required: true,
    unique: false,
    select: false
  },
  email: {
    type: String,
    required: true,
    unique: true
  },
  emailToken: {
    type: String,
    required: true
  },
  posts: {
    type: [ObjectId],
    required: true,
    unique: false
  }
});

module.exports = mongoose.model('User', UserSchema);