const mongoose = require("mongoose");

const userRequestSchema = new mongoose.Schema(
  {
    owner: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      ref: "User",
    },
    workerRequest: [
      {
        requests: { type: mongoose.Schema.Types.ObjectId,ref: "Workers"},
        status: {
          type: Number,
          default: 0,
        },
      },
    ],
  },
  {
    timestamps: true,
  }
);

const workerRequestSchema = new mongoose.Schema(
  {
    owner: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      ref: "Workers",
    },
    userRequest: [
      {
        requests: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
        status: {
          type: Number,
          default: 0,
        },
      },
    ],
    workStatus:{
      type:Boolean,
      required:true,
      default:true,
    }
  },
  {
    timestamps: true,
  }
);

const UsersRequest = mongoose.model("UserRequest", userRequestSchema);
const WorkersRequest = mongoose.model("WorkerRequest", workerRequestSchema);

module.exports = {
  UsersRequest,
  WorkersRequest,
};
