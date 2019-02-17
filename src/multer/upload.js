const multer = require('multer');
const multerS3 = require('multer-s3');
const aws = require('aws-sdk');


aws.config.update(
  {
    secretAccessKey: process.env.S3_ACCESS_KEY,
    accessKeyId: process.env.S3_ACCESS_KEY_ID,
    region: 'us-west-2'
  }
);
const s3 = new aws.S3();

const upload = multer({
  storage: multerS3({
    s3: s3,
    bucket: 'elasticbeanstalk-us-west-2-790161425636',
    acl: 'public-read',
    metadata: function (req, file, callback) {
      callback(null, Object.assign({}, req.body));
    },
    key: function (req, file, callback) {
      callback(null, Date.now().toString() + '.jpg');
    }
  }), fileFilter: function(req, file, callback) {
    if (!req.body.description || !req.body.name) {
      callback(null, false);
      return;
    }
    callback(null, true);
  }
});

module.exports = upload;