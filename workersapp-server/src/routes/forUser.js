const express = require("express");
const Workers = require("../models/workers");
const { userAuth } = require("../middleware/auth");
const { WorkersRequest, UsersRequest } = require("../models/request");
const routes = express.Router();
const Review = require("../models/review");
const Favouirte = require("../models/favourite");
// const { UserLocation, WorkerLocation } = require("../models/location");
// home
routes.get("/users/home", userAuth, async (req, res) => {
  try {
    const workers = await Workers.find({});
    const filteredWorkers = [];

    for (const worker of workers) {
      const work = await WorkersRequest.findOne({ owner: worker.id });
      if (!work || work.workStatus == true) {
        const reviews = await Review.findOne({ owner: worker.id })
          .populate("reviews.user", "name email specialization rating comment experience phoneNo salary avatar")
          .select("reviews");
        const formattedReviews =
          reviews && reviews.reviews
            ? reviews.reviews.map((review) => ({
              rating: review.rating,
              comment: review.comment,
              name: review.user.name,
              email: review.user.email,
            }))
            : [];
        const ratingSum = formattedReviews.reduce((acc, review) => {
          return acc + review.rating;
        }, 0);
        const ratingCount = formattedReviews.length;
        const avgRating = ratingCount > 0 ? ratingSum / ratingCount : 0;

        const formattedWorker = {
          id: worker._id,
          name: worker.name,
          email: worker.email,
          specialization: worker.specialization,
          phoneNo: worker.phoneNo,
          salary: worker.salary,
          experience: worker.experience,
          reviews: formattedReviews,
          avgRating: avgRating,
          avatar: worker.avatar,
        };
        filteredWorkers.push(formattedWorker);
      }
    }

    res.send(filteredWorkers);
  } catch (error) {
    res.status(500).send("Server error");
  }
});


// search
routes.get("/search", userAuth, async (req, res) => {
  const query = req.query.q;
  try {
    const workers = await Workers.find({
      $or: [
        { name: { $regex: query, $options: "i" } },
        { specialization: { $regex: query, $options: "i" } },
      ],
    });

    const filteredWorkers = [];

    for (const worker of workers) {
      const work = await WorkersRequest.findOne({ owner: worker.id });
      if (!work || work.workStatus == true) {
        const reviews = await Review.findOne({ owner: worker.id })
          .populate("reviews.user", "name email specialization rating comment experience phoneNo salary avatar")
          .select("reviews");
        const formattedReviews =
          reviews && reviews.reviews
            ? reviews.reviews.map((review) => ({
              rating: review.rating,
              comment: review.comment,
              name: review.user.name,
              email: review.user.email,
            }))
            : [];
        const ratingSum = formattedReviews.reduce((acc, review) => {
          return acc + review.rating;
        }, 0);
        const ratingCount = formattedReviews.length;
        const avgRating = ratingCount > 0 ? ratingSum / ratingCount : 0;

        const formattedWorker = {
          id: worker._id,
          name: worker.name,
          email: worker.email,
          specialization: worker.specialization,
          phoneNo: worker.phoneNo,
          salary: worker.salary,
          experience: worker.experience,
          reviews: formattedReviews,
          avgRating: avgRating,
          avatar: worker.avatar,
        };
        filteredWorkers.push(formattedWorker);
      }
    }

    res.send(filteredWorkers);
  } catch (error) {
    res.status(500).send("Server error");
  }
});


// adding fav workers
routes.post("/user-fav/:id", userAuth, async (req, res) => {
  try {
    const worker = await Workers.findOne({ _id: req.params.id });
    if (!worker) return res.status(404).send({ message: "Worker not found" });

    const fav = await Favouirte.findOne({ owner: req.user.id });
    if (fav && fav.favouriteList.some((favItem) => favItem.fav.toString() == req.params.id)) {
      return res.status(400).send({ message: "Worker already added to favorites" });
    }
    await Favouirte.findOneAndUpdate(
      { owner: req.user._id },
      { $addToSet: { favouriteList: { fav: req.params.id } } },
      { new: true, upsert: true }
    );
    res.status(201).send();
  } catch (err) {
    console.error(err);
    res.status(500).send("Server Error");
  }
});

// users gfav lisr
routes.get("/user-fav", userAuth, async (req, res) => {
  const fav = await Favouirte.findOne({ owner: req.user._id });
  if (!fav) return res.status(404).send({ message: "User Not Found" });

  const workerIds = fav.favouriteList.map((f) => f.fav);

  const workers = await Promise.all(
    workerIds.map(async (id) => {
      try {
        const worker = await Workers.findById(id);
        if (!worker) throw new Error(`Worker with ID ${id} not found`);
        return {
          id: worker._id,
          name: worker.name,
          email: worker.email,
          specialization: worker.specialization,
          avatar: worker.avatar,
          salary: worker.salary,
          experience: worker.experience,
        };
      } catch (e) {
        throw new Error(`Error fetching worker with ID ${id}: ${e.message}`);
      }
    })
  );

  res.status(200).send(workers);
});




// removing fav person
routes.delete("/user-fav/:id", userAuth, async (req, res) => {
  try {
    const fav = await Favouirte.findOneAndUpdate(
      { owner: req.user._id },
      { $pull: { favouriteList: { fav: req.params.id } } },
      { new: true }
    );
    if (!fav) return res.status(404).send({ message: "User Not Found" });
    res.status(201).send({ message: "Worker removed from favourites" });
  } catch (e) {
    res.status(500).send(e);
  }
});
//   requesting
routes.post("/user-request/:id", userAuth, async (req, res) => {
  try {
    const id = req.params.id;
    const worker = await Workers.findById(req.params.id);
    if (!worker) {
      return res.status(404).send({ message: "Worker not found" });
    }
    const workers = await WorkersRequest.find({ owner: req.params.id });
    if (workers.workStatus == false) {
      return res.status(404).send({ message: "already in a job" });
    }
    const user = await UsersRequest.findOne({ owner: req.user._id });
    if (user) {
      const requestExists = user.workerRequest.some((req) => req.requests.toString() === id && (req.status === 2 || req.status === 0));
      if (requestExists) {
        return res.status(404).send({ message: "Workers request in Progress" });
      }

    }
    await WorkersRequest.findOneAndUpdate(
      { owner: req.params.id },
      { $addToSet: { userRequest: { requests: req.user._id } }, workStatus: true },
      { upsert: true, new: true }
    );
    await UsersRequest.findOneAndUpdate(
      { owner: req.user._id },
      { $addToSet: { workerRequest: { requests: req.params.id } } },
      { upsert: true, new: true }
    );
    res.status(201).send();
  } catch (e) {
    res.status(400).send({ error: e });
  }
});


// user history
routes.get("/users/history", userAuth, async (req, res) => {
  try {
    const requests = await UsersRequest.find({ owner: req.user._id })
      .populate({
        path: "workerRequest.requests",
        select: "name email specialization avatar",
      })
      .exec();

    if (!requests) {
      return res.status(404).send({ message: "Requests not found" });
    }

    const acceptedUsers = requests.flatMap((request) => {
      return request.workerRequest.map((workerRequest) => {
        return {
          _id: workerRequest.requests._id,
          name: workerRequest.requests.name,
          email: workerRequest.requests.email,
          specialization: workerRequest.requests.specialization,
          avatar: workerRequest.requests.avatar,
          salary: workerRequest.requests.salary,
          experience:workerRequest.requests.salary,
          status: workerRequest.status,
        };
      });
    });

    if (acceptedUsers.length === 0) {
      return res.status(404).send({ message: "No history found" });
    }

    res.send(acceptedUsers);
  } catch (e) {
    res.status(400).send({ error: e });
  }
});



//   getting status history
routes.get("/users/fetch-status", userAuth, async (req, res) => {
  try {
    const status = req.body.status;
    const request = await UsersRequest.findOne({ owner: req.user._id });
    const workersWithAcceptedStatus = request
      ? request.workerRequest.filter((req) => req.status.toString() === status)
      : [];
    const acceptedWorkers = await Workers.find({
      _id: { $in: workersWithAcceptedStatus.map((req) => req.requests) },
    });
    return acceptedWorkers.length
      ? res.send(acceptedWorkers)
      : res.status(404).send({ error: "Request not found" });
  } catch (e) {
    res.status(400).send({ error: e });
  }
});

// review a worker
routes.post("/users/review/:id", userAuth, async (req, res) => {

  try {
    const usr = await UsersRequest.findOne({ owner: req.user._id });
    if (!usr) {
      return res.status(404).send({ message: "Error" });
    }
    const worker =
      usr.workerRequest &&
      usr.workerRequest.filter(
        (wrk) => wrk.requests.toString() === req.params.id
      );
    if (!(!worker || worker[0].status !== 1 || worker[0].status !== 3)) {
      return res
        .status(404)
        .send({ message: "Worker request not found or not approved yet" });
    }
    await Review.findOneAndUpdate(
      { owner: req.params.id },
      {
        $push: {
          reviews: {
            user: req.user._id,
            rating: req.body.rating,
            comment: req.body.comment,
          },
        },
        $inc: { noOfRated: 1 },
      },
      { upsert: true, new: true }
    );
    res.status(201).send();
  } catch (e) {
    res.status(500).send({ message: "Server error" });
  }
});


routes.get("/users/isfav/:id", userAuth, async (req, res) => {
  try {
    const favlst = await Favouirte.findOne({
      owner: req.user._id,
      "favouriteList.fav": req.params.id
    });

    const isfav = favlst !== null;

    if (isfav) {
      res.sendStatus(404);
    } else {
      res.sendStatus(200);
    }
  } catch (err) {
    console.error(err);
    res.sendStatus(500);
  }
});


routes.get("/users/ishistory/:id", userAuth, async (req, res) => {
  try {
    const userReq = await UsersRequest.findOne({ owner: req.user._id });
    if (userReq) {
      const isReq = userReq.workerRequest.some(
        (workerReq) =>
          workerReq.requests.toString() === req.params.id && workerReq.status === 0
      );
      if (isReq) {
        res.status(404).send();
      } else {
        res.status(200).send();
      }
    } else {
      res.status(200).send();
    }
  } catch (err) {
    console.error(err);
    res.status(500).send("Server Error");
  }
});


module.exports = routes;
