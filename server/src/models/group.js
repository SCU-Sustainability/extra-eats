'use strict';

var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var GroupSchema = new Schema({
  name: {
    type: String,
    required: true
  },
  posts: {
    type: [ObjectId],
    required: true
  }
  // Todo: maybe add users in the future if needed
});

module.exports = mongoose.model('Group', GroupSchema);