const mongoose = require("mongoose");

const favouriteListSchema = new mongoose.Schema({
  owner: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
    ref: "User",
  },
  favouriteList: [
    {
      fav: { type: mongoose.Schema.Types.ObjectId, ref: "Workers"},
    },
  ],
});

const Favourite =  mongoose.model("Favourite", favouriteListSchema);
module.exports=Favourite;