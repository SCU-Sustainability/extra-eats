"use strict";

var mongoose = require("mongoose");
var Schema = mongoose.Schema;
var ObjectId = mongoose.Schema.Types.ObjectId;

var UserSchema = new Schema({
	name: {
		type: String,
		required: false,
		unique: false
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
		required: true,
		unique: false
	},
	posts: {
		type: [ObjectId],
		required: true,
		unique: false
	},
	provider: {
		type: Boolean,
		required: true
	}
});

module.exports = mongoose.model("User", UserSchema);
