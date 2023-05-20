const express = require("express");
const { workerAuth } = require("../middleware/auth");
const { WorkersRequest, UsersRequest } = require("../models/request");
const Review = require("../models/review");


const routes = express.Router();

// history
routes.get("/workers/history", workerAuth, async (req, res) => {
  try {
    const requests = await WorkersRequest.find({ owner: req.worker._id })
      .populate({
        path: "userRequest.requests",
        select: "name email phoneNo street address avatar",
      })
      .exec();

    if (!requests) {
      return res.status(404).send({ error: "Requests not found" });
    }

    const acceptedUsers = requests.flatMap((request) => {
      return request.userRequest.map((userRequest) => {
        return {
          user: userRequest.requests,
          status: userRequest.status,
        };
      });
    });

    if (acceptedUsers.length === 0) {
      return res.status(404).send({ error: "Empty Array" });
    }

    res.status(200).send(acceptedUsers);
  } catch (e) {
    res.status(400).send({ error: e });
  }
});
//   accept or reject
routes.post("/workers/change-status", workerAuth, async (req, res) => {
  try {
    const [request] = await WorkersRequest.find({ owner: req.worker._id });
    if (request && request.userRequest.length) {
      const { status } = request.userRequest.find(
        ({ requests }) => requests.toString() === req.body.id
      );
      if (status === req.body.status) {
        return res.send();
      }

      request.userRequest.forEach(({ requests }, index) => {
        if (requests.toString() === req.body.id) {
          request.userRequest[index].status = req.body.status;
        }
      });
      if (req.body.status === 1) {
        request.workStatus = false;
      } else {
        request.workStatus = true;
      }
      const [userReqChange] = await UsersRequest.find({ owner: req.body.id });

      userReqChange.workerRequest.forEach(({ requests }, index) => {
        if (requests.toString() === req.worker._id.toString()) {
          userReqChange.workerRequest[index].status = req.body.status;
        }
      });
      await request.save();
      await userReqChange.save();
      return res.status(200).send();
    }
  } catch (e) {
    return res.status(404).send(e);
  }

});

//   sending status history
routes.get("/workers/fetch-status", workerAuth, async (req, res) => {
  try {
    const requests = await WorkersRequest.find({ owner: req.worker._id })
      .populate({
        path: "userRequest.requests",
        select: "name email phoneNo street address avatar",
      })
      .exec();

    const accepted = requests.flatMap((request) =>
      request.userRequest
        .filter((req) => req.status.toString() === "1")
        .map((req) => ({
          user: req.requests,
          status: req.status,
        }))
    );

    res.status(200).send(accepted);
  } catch (e) {
    console.log("Error:", e);
    res.status(400).send({ error: e });
  }
});


routes.post("/workers/finish", workerAuth, async (req, res) => {
  try {
    const requestId = req.body.id;
    const workReq = await WorkersRequest.findOne({ owner: req.worker._id });
    const userReq = await UsersRequest.findOne({ owner: requestId });


    const requestIndex = workReq.userRequest.findIndex(
      (request) => request.requests.toString() === requestId.toString()
    );
    const userIndex = userReq.workerRequest.findIndex(
      (request) => request.requests.toString() === req.worker._id.toString()
    );


    if (requestIndex === -1) {
      return res.status(404).send({ error: "Request not found" });
    }
    if (userIndex === -1) {
      return res.status(404).send({ error: "Request not found" });
    }

    // Remove the request and status from the userRequest array
    workReq.userRequest.splice(requestIndex, 1);
    userReq.workerRequest.splice(userIndex, 1);
    workReq.workStatus = true;

    // Save the updated workReq object
    await workReq.save();
    await userReq.save();
    res.status(201).send({ message: "Request done successfully" });
  } catch (e) {
    res.status(400).send({ error: e.message });
  }
});



routes.get("/worker/status-updates/:id", workerAuth, async (req, res) => {
  try {
    const requestId = req.params.id;
    const workerRequest = await WorkersRequest.findOne({ owner: req.worker._id });

    if (!workerRequest) {
      return res.status(404).send({ error: "Worker request not found" });
    }

    const foundRequest = workerRequest.userRequest.find(
      (request) => request.requests.toString() === requestId
    );

    if (!foundRequest) {
      return res.status(404).send({ error: "Request not found" });
    }

    // Modify the response based on your requirement
    res.status(200).json({ status: foundRequest.status }); // Sending the status value as JSON

  } catch (e) {
    res.status(400).send({ error: e.message });
  }
});



// send review
routes.get("/workers/review", workerAuth, async (req, res) => {
  const ownReview = await Review.findOne({ owner: req.worker._id })
    .populate({
      path: "reviews.user",
      select: "name email ",
    })
    .select("reviews")
    .exec();

  if (!ownReview) {
    return status(404).send('No Reviews');
  }

  const formattedReview = ownReview.reviews.map((review) => ({
    rating: review.rating,
    comment: review.comment,
    createdAt: review.createdAt,
    name: review.user.name,
    email: review.user.email,
  }));
  res.status(200).send(formattedReview);
});




module.exports = routes;
