var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var ObjectId = mongoose.Schema.Types.ObjectId;

var UserSchema = new Schema({
  username: String,
  password: String,
  events: [ObjectId],
  credentialToken: String
});

module.exports = mongoose.model('User', UserSchema);