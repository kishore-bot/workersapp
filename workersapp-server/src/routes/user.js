const express = require("express");
const User = require("../models/user");
const { userAuth } = require("../middleware/auth");
const multer = require("multer");
const sharp = require("sharp");
const routes = express.Router();

// signup
routes.post("/users-signup", async (req, res) => {
  const user = new User(req.body);
  try {
    await user.save();
    const token = await user.generateAuthToken();
    res.status(201).send({ user, token });
  } catch (error) {
    res.status(500).send(error);
  }
});

// login
routes.post("/users-login", async (req, res) => {
  try {
    const user = await User.findByCredentials(
      req.body.email,
      req.body.password
    );
    const token = await user.generateAuthToken();
    res.status(201).send({ user, token });
  } catch (error) {
    res.status(400).send(error);
  }
});

// get user profile
routes.get("/users/profile", userAuth, async (req, res) => {
  const user={
    id:req.user._id,
    name:req.user.name,
    email:req.user.email,
    phoneN:req.user.phoneNo,
    street:req.user.street,
    address:req.user.address
  }
  res.status(200).send(user);
});

// logout
routes.post("/users/logout", userAuth, async (req, res) => {
  try {
    req.user.tokens = req.user.tokens.filter((token) => {
      return token.token !== req.token;
    });
    await req.user.save();
    res.status(201).send();
  } catch (e) {
    res.status(400);
  }
});

const upload = multer({

  limits: {
    fileSize: 1000000,
  },
  fileFilter(req, file, cb) {
    if (!file.originalname.match(/\.(jpg|jpeg|png)$/)) {
      return cb(new Error("Please upload an image"));
    }

    cb(undefined, true);
  },

});
// images
routes.post("/users/avatar", userAuth, upload.single("avatar"), async (req, res) => {
  const buffer = await sharp(req.file.buffer)
    .resize({ width: 250, height: 250 })
    .png()
    .toBuffer();
  req.user.avatar = buffer;
  await req.user.save();
  res.send();
},
  (error, req, res, next) => {
      console.log("hha");
    res.status(400).send({ error: error.message });
  }
);

routes.get("/users/avatar", userAuth, async (req, res) => {
  try {
    const user = await User.findById(req.user._id);

    if (!user || !user.avatar) {
      throw new Error();
    }

    res.set("Content-Type", "image/png");
    res.send(user.avatar);
  } catch (e) {
    res.status(404).send();
  }
});

module.exports = routes;
