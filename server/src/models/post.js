'use strict';

var mongoose = require('mongoose');
var ObjectId = mongoose.ObjectId;
var Schema = mongoose.Schema;

var PostSchema = new Schema({
  name: {
    type: String,
    required: true
  },
  creator: {
    type: ObjectId,
    required: true
  },
  description: {
    type: String,
    required: true
  },
  image: {
    type: String,
    required: true
  },
  location: {
    type: String,
    required: true
  },
  tags: {
    type: [String],
    required: true
  },
  expiration: {
    type: Date,
    required: true
  }
});

module.exports = mongoose.model('Post', PostSchema);
