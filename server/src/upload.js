const multer = require('multer');
const cloudinary = require('cloudinary');
const cloudinaryStorage = require('multer-storage-cloudinary');

cloudinary.config({
  cloud_name: process.env.MY_CLOUD_NAME,
  api_key: process.env.MY_CLOUD_API_KEY,
  api_secret: process.env.MY_CLOUD_API_SECRET
});

var storage = cloudinaryStorage({
  cloudinary: cloudinary,
  folder: 'ttw',
  allowedFormats: ['jpg', 'png'],
  filename: function (req, file, cb) {
    cb(undefined, file.originalname);
  }
});

const parser = multer({storage: storage});

module.exports = parser;
