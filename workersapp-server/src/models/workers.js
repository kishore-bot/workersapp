const mongoose = require("mongoose");
const validator = require("validator");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

const workersSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
  },
  email: {
    type: String,
    unique: true,
    required: true,
    trim: true,
    lowercase: true,
    validate(value) {
      if (!validator.isEmail(value)) {
        throw new Error("Email is invalid");
      }
    },
  },
  password: {
    type: String,
    required: true,
    minlength: 7,
    trim: true,
    validate(value) {
      if (value.toLowerCase().includes("password")) {
        throw new Error('Password cannot contain "password"');
      }
    },
  },
  specialization: {
    type: String,
    required: true,
    trim: true,
  },
  experience: {
    type: Number,
    required: true,
  },
  workerJobId: {
    type: String,
    required: true,
  },
  phoneNo: {
    type: Number,
    required: true,
  },
  salary: {
    type: Number,
  },
  joinedDate: {
    type: Date,
    required: true
  },
  avatar: {
    type: Buffer
  },
  tokens: [
    {
      token: {
        type: String,
        required: true,
      },
    },
  ],
});

// referencing request
workersSchema.virtual("request", {
  ref: "WorkerRequest",
  localField: "_id",
  foreignField: "owner",
});

// referencing review
workersSchema.virtual("review", {
  ref: "Review",
  localField: "_id",
  foreignField: "owner",
});
// removing unwanted things from sending user
workersSchema.methods.toJSON = function () {
  const worker = this;
  const workerObject = worker.toObject();
  delete workerObject.password;
  delete workerObject.tokens;
  return workerObject;
};

workersSchema.methods.generateAuthToken = async function () {
  const worker = this;
  const token = jwt.sign(
    { _id: worker._id.toString() },
    "www.workers@gmail.com"
  );
  worker.tokens = worker.tokens.concat({ token });
  await worker.save();
  return token;
};

// used for logging in
workersSchema.statics.findByCredentials = async (email, password) => {
  const worker = await Workers.findOne({ email });

  if (!worker) {
    throw new Error("Invalid Email or Password ");
  }
  const isMatch = await bcrypt.compare(password, worker.password);
  if (!isMatch) {
    throw new Error("Invalid Email or Password ");
  }
  return worker;
};

// hashing password before saving done here👇
workersSchema.pre("save", async function (next) {
  const worker = this;

  if (worker.isModified("password")) {
    worker.password = await bcrypt.hash(worker.password, 8);
  }

  next();
});

const Workers = mongoose.model("Workers", workersSchema);
module.exports = Workers;
