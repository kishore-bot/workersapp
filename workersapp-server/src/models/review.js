const mongoose = require('mongoose');

const reviewSchema = new mongoose.Schema({
  reviews:[{
    rating: {
      type: Number,
      required: true,
      min: 1,
      max: 5
    },
    comment: {
      type: String,
      trim: true
    },
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
  }] ,
  noOfRated: {
    type: Number,
    trim: true
  },
  owner: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Worker'
  }
});

const Review = mongoose.model('Review', reviewSchema);
module.exports = Review;