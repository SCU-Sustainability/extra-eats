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
  public_id: {
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
  }, 
  scheduledDay: {
    type: Number
  },
  scheduledMonth: {
    type: Number
  },
  scheduledHour: {
    type: Number
  },
  scheduledMinute: {
    type: Number
  },
  status: {
    type: String //Expired, scheduled, or active. Set this field in background.js
  }
});

module.exports = mongoose.model('Post', PostSchema);
