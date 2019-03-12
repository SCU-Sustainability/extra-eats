"use strict";

const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const express = require("express");
require("dotenv").config();
const shortid = require("shortid");
const firebase = require("firebase/messaging");

const User = require("./models/user");
const Post = require("./models/post");
const Mailer = require("./mailer");

const router = express.Router();
const upload = require("./upload");

// Middleware
const authCheck = require("./routes/middle/auth-check");
// Routes
const ping = require("./routes/ping");

const authRoutes = ["users", "posts"];
const exclusions = { users: "POST" };

// ============
// Middleroutes
// ============
// Make sure x-access-token is present for certain endpoints
router.use((req, res, next) =>
  authCheck(authRoutes, exclusions, req, res, next)
);

// Rate limiter for non-device API end-users
router.use(function(req, res, next) {
  // Todo: Implement
  next();
});

// Todo: Middleroute to check JWT verification
function authorize(req, res) {}

// ============
// Internal API
// ============
function _unauthorized(res) {
  return res.status(500).send({ message: "Failed to authenticate token." });
}

function _signJWT(id) {
  return jwt.sign({ id: id }, process.env.SECRET, { expiresIn: 86400 });
}

// ==========
// API Routes
// ==========
// Ping route
router.get("/", ping);

// Login route
router.route("/login").post(function(req, res) {
  // Todo: Validate
  // Todo: Handle max attempts
  if (!req.body.email || !req.body.password) {
  }
  User.findOne({ email: req.body.email }, "+password", function(err, user) {
    // Todo: Handle errors
    if (err) return res.json(err);
    if (!user) return res.json({ message: "User not found!", code: 0 });

    if (!bcrypt.compareSync(req.body.password, user.password))
      return res.send({ message: "Wrong email or password.", code: -1 });
    let token = _signJWT(user._id);
    return res.json({
      message: "Logged in!",
      token: token,
      user_id: user._id,
      provider: user.provider,
      code: 1
    });
  });
});

// Users
router
  .route("/users")
  .post(function(req, res) {
    // Registration
    // Check: Validation
    if (!req.body.email || !req.body.password)
      return res.send({ message: "Missing data.", code: -1 });

    if (req.body.name) {
      if (!req.body.name.match("^([A-Za-z0-9 ]{1,20})$")) {
        return res.send({ message: "Name invalid.", code: -2 });
      }
    }

    if (!req.body.password.match("^([A-Za-z0-9W]{6,20})$")) {
      return res.send({ message: "Password invalid.", code: -3 });
    }
    // Check email regex

    let provider = false;
    if (req.body.provider) {
      provider = true;
    }

    let name = "";
    if (req.body.name) {
      name = req.body.name;
    }

    let password = bcrypt.hashSync(req.body.password, 8);
    let email = req.body.email;
    let emailToken = shortid.generate();
    let user = new User({
      name: name,
      password: password,
      email: email,
      posts: [],
      emailToken: emailToken,
      provider: provider
    });

    user.save(function(err) {
      if (err) {
        console.log(err);
        if (err.code === 11000) {
          return res.send({
            message: "Email already exists.",
            code: -4
          });
        }
        return res.send(err);
      }

      let token = _signJWT(user._id);
      let response = {
        message: "User created!",
        token: token,
        user_id: user._id,
        provider: provider,
        code: 1
      };
      res.json(response);
      // Send an email here
      /** mailer.sendMail(email).then(function(info) {
      console.log('Sent email verify to ' + email);
    });*/
    });
  })
  .get(function(req, res) {
    // Get users (required?)
    let token = req.headers["x-access-token"];
    jwt.verify(token, process.env.SECRET, function(err, decoded) {
      if (err) return _unauthorized(res);
    });
    User.find(function(err, users) {
      if (err) return res.send(err);
      res.json(users);
    }, "-password");
  });

// User by ID
router
  .route("/users/:user_id")
  .get(function(req, res) {
    // Check: Auth
    let token = req.headers["x-access-token"];
    jwt.verify(token, process.env.SECRET, function(err, decoded) {
      if (err) return _unauthorized(res);
    });

    User.findById(req.params.user_id, "-password", function(err, user) {
      if (err) return res.send(err);
      if (!user) return res.json({ message: "User not found!", code: -1 });
      res.json(user);
    });
  })
  .put(function(req, res) {
    // Check: Auth, user can only update own user
    let token = req.headers["x-access-token"];
    jwt.verify(token, process.env.SECRET, function(err, decoded) {
      if (err || req.params.user_id !== decoded.id) return _unauthorized(res);
    });

    User.findById(req.params.user_id, function(err, user) {
      if (err) return res.send(err);
      if (!user) return res.json({ message: "User not found!", code: -1 });
      // Check: Which attributes are being updated
      if (req.body.password) {
        user.password = bcrypt.hashSync(req.body.password, 8);
      }
      user.save(function(err) {
        if (err) return res.send(err);
        res.json({ message: "User updated!", code: 1 });
      });
    });
  })
  .delete(function(req, res) {
    // Check: Auth, user can only delete own user
    let token = req.headers["x-access-token"];
    jwt.verify(token, process.env.SECRET, function(err, decoded) {
      if (err || req.params.user_id !== decoded.id) return _unauthorized(res);
    });
    User.deleteOne(
      {
        _id: req.params.user_id
      },
      function(err, user) {
        if (err) return res.json(err);
        if (!user) return res.json({ message: "User not found!", code: -1 });
        res.json({ message: "User deleted!", code: 1 });
      }
    );
  });

// Verify email
router.route("/users/verify/:user_id").post(function(req, res) {
  // Todo: Validate data
  let token = req.headers["x-access-token"];
  jwt.verify(token, process.env.SECRET, function(err, decoded) {
    if (err || req.params.user_id !== decoded.id) return _unauthorized(res);
    User.findById(req.params.user_id, function(err, user) {
      if (!user) return res.json({ message: "User not found!", code: -1 });
      if (!req.body.emailToken)
        return res.json({
          message: "No email token provided.",
          code: -2
        });
      if (user.emailToken !== req.body.emailToken)
        return res.json({ message: "Wrong email token", code: -3 });
      if (err) return res.send(err);

      user.emailToken = "*";
      user.save(function(err) {
        if (err) return res.send(err);
        res.json({ message: "Email verified!", code: 1 });
      });
    });
  });
});

// Posts
router
  .route("/posts")
  .post(
    /*upload.single('post-image'), */ function(req, res) {
      // Check: Auth
      // Post-upload

      let token = req.headers["x-access-token"];
      jwt.verify(token, process.env.SECRET, function(err, decoded) {
        if (err) return _unauthorized(res);
        User.findById(decoded.id, function(err, user) {
          // Todo: do we have to delete the post from S3 if the post fails?

          if (err /*|| !req.file*/) {
            return res.json({
              message: "Could not upload image!",
              code: -4
            });
          }

          if (!user)
            return res.json({
              message: "User not found!",
              code: -1
            });
          if (!user.provider)
            return res.json({
              message: "You are not a provider!",
              code: -2
            });

          if (
            !req.body.name ||
            !req.body.description ||
            !req.body.tags ||
            !req.body.location
          ) {
            // Never reached?
            return res.json({
              message: "Missing a field.",
              code: -3
            });
          }

          // Todo: validate data (location)
          // Todo: validate expiration

          let post = new Post({
            name: req.body.name,
            description: req.body.description,
            image: "testing",
            tags: req.body.tags,
            location: req.body.location,
            expiration: req.body.expiration,
            creator: user._id
          });

          post.save(function(err) {
            if (err) {
              console.log(err);
              return res.json({
                message: "Unknown save error",
                code: -202
              });
            }
            // Implement update user in database
            let posts = user.posts;
            posts.push(post._id);

            user.save(function(err) {
              if (err) {
                console.log(err);
                return res.json({
                  message: "Unknown save error user",
                  code: -203
                });
              }
              return res.json({ message: "Posted!", code: 1 });
            });
          });
        });
      });
    }
  )
  .get(function(req, res) {
    // Implement
    let token = req.headers["x-access-token"];
    jwt.verify(token, process.env.SECRET, function(err, decoded) {
      if (err) return _unauthorized(res);
      let tags = [];
      if (req.body.tags) tags = req.body.tags;
      let filter = tags.length === 0 ? {} : { tags: tags };
      let now = new Date();
      filter["expiration"] = {
        $gte: now
      };

      Post.deleteMany({ expiration: { $lt: now } }, function(err) {
        if (err) {
          console.log(err);
          return;
        }
      });
      Post.find(filter, (err, posts) => {
        if (err) {
          console.log(err);
          return res.json({
            message: "Could not get posts",
            code: -199
          });
        }
        return res.json({ code: 1, posts: posts });
      });
    });
  })
  .delete(function(req, res) {
    let token = req.headers["x-access-token"];
    jwt.verify(token, process.env.SECRET, function(err, decoded) {
      if (err) return _unauthorized(res);
      Post.deleteOne({ _id: req.headers["id"] }, function(err) {
        if (err) {
          return res.json({ code: 0 });
        }
        Post.find({}, (err, posts) => {
          if (err) {
            return res.json({ code: -1 });
          }
          return res.json({ code: 1, posts: posts });
        });
      });
    });
  });

module.exports = router;
