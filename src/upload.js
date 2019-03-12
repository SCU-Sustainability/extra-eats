const multer = require('multer');
const multerS3 = require('multer-s3');
const aws = require('aws-sdk');

aws.config.update({
  secretAccessKey: process.env.S3_ACCESS_KEY,
  accessKeyId: process.env.S3_ACCESS_KEY_ID,
  region: 'us-west-2'
});
const s3 = new aws.S3();

const upload = multer({
  storage: multerS3({
    s3: s3,
    bucket: 'elasticbeanstalk-us-west-2-790161425636',
    acl: 'public-read',
    key: function(req, image, cb) {
      console.log(image);
      cb(null, image.originalname);
    }
  })
});

module.exports = upload;
