'use strict';
require('dotenv').config();
const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port : process.env.SMTP_PORT,
  secure: true,
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS
  },
  tls: {
    rejectUnauthorized: false
  }
});

class Mailer {

  Mailer() {
    transporter.verify(function(err, success) {
      if (err) console.log('SMTP connection settings are wrong.');
    });
  }

  _buildMailOptions(receivers) {
    return {
      from: '"Taste the Waste SCU" <chorescoresmailer@gmail.com>',
      to: receivers.join(', '),
      subject: 'Confirm your Taste the Waste account!',
      text: 'Test email',
      html: '<b>Test email</b>'
    };
  }

  async sendMail(receiver) {
    return transporter.sendMail(this._buildMailOptions([receiver]));
  }

}

module.exports = Mailer;