const express = require('express');
const Workers = require('../models/workers');
const { workerAuth } = require('../middleware/auth');
const multer = require("multer");
const sharp = require("sharp");


const routes = express.Router();
// signup
routes.post("/workers-signup", async (req, res) => {
  const worker = new Workers(req.body);
  worker.salary = 800 + req.body.experience * 5;
  worker.joinedDate = new Date()
  const token = await worker.generateAuthToken();
  res.status(201).send({ worker, token });

});


// login
routes.post("/workers-login", async (req, res) => {
  try {
    const worker = await Workers.findByCredentials(
      req.body.email,
      req.body.password
    );
    const token = await worker.generateAuthToken();
    res.status(201).send({ worker, token });
  } catch (error) {
    res.status(404).send(error);
  }
});
// get user profile
routes.get('/workers/profile', workerAuth, async (req, res) => {
  try {
    const worker = {
      id: req.worker._id,
      name: req.worker.name,
      email: req.worker.email,
      phoneN: req.worker.phoneNo,
      specialization: req.worker.specialization,
      experience: req.worker.experience,
      workerJobId: req.worker.workerJobId,
      salary: req.worker.salary,
    }
    res.status(200).send(worker);
  } catch (e) {
    res.send(404);
  }
});

// logout 
routes.post('/workers/logout', workerAuth, async (req, res) => {
  try {
    req.worker.tokens = req.worker.tokens.filter((token) => {
      return token.token !== req.token;
    });
    await req.worker.save();
    res.send();
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
routes.post("/workers/avatar", workerAuth, upload.single("avatar"), async (req, res) => {
  const buffer = await sharp(req.file.buffer)
    .resize({ width: 250, height: 250 })
    .png()
    .toBuffer();
  req.worker.avatar = buffer;
  await req.worker.save();
  res.send();
},
  (error, req, res, next) => {
    console.log("hha");
    res.status(400).send({ error: error.message });
  }
);

routes.get("/workers/avatar", workerAuth, async (req, res) => {
  try {
    const worker = await Workers.findById(req.worker._id);

    if (!worker || !worker.avatar) {
      throw new Error();
    }

    res.set("Content-Type", "image/png");
    res.send(worker.avatar);
  } catch (e) {
    res.status(404).send();
  }
});

module.exports = routes;