'use strict';

var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var PostSchema = new Schema({
  name: String
});

module.exports = mongoose.model('Post', PostSchema);