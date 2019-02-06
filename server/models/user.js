var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var ObjectId = mongoose.Schema.Types.ObjectId;

var UserSchema = new Schema({
  username: String,
  password: String,
  posts: [ObjectId]
});

module.exports = mongoose.model('User', UserSchema);