let cron = require('node-cron'); 
var mongoose = require('mongoose');
var post = require('./models/post.js'); 

exports.updatePostStatus = function() {
	cron.schedule('* * * * *', function() {
		/*
			when submitting a post, send a Date object to the server if it 
		*/
		var rightNow = new Date(); 
		var hour = rightNow.getHours(); 
		var minutes = rightNow.getMinutes(); 
		var dayOfWeek = rightNow.getDay(); 
		var numberDay = rightNow.getDate(); 
		var month = rightNow.getMonth() + 1; 
		// console.log(hour);
		// console.log(minutes); 
		// console.log(numberDay);
		// console.log(month);

		post.updateMany({scheduledDay: numberDay, scheduledMonth: month, scheduledMinute: minutes, scheduledHour: hour}, {$set: {status: 'active'}}).exec(function(err, posts) {
			if (err) {
				console.log(err); 
			} 
		})

	}) 
}