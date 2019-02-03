var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var EventSchema = new Schema({
  name: String
});

module.exports = mongoose.model('Event', EventSchema);