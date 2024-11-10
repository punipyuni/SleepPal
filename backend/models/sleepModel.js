// models/sleepModel.js
const mongoose = require('mongoose');
const database = require('../config/database');

const SleepSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  date: { type: Date, required: true },
  duration: Number,
  rem: Number,
  light: Number,
  deep: Number,
  awake: Number,
  sleepingTime: Date,
  wakeUpTime: Date,
  sleepStages: [
    {
      stage: String,
      start: String,
      end: String
    }
  ],
  sleepScore: Number,
});

const SleepModel = database.model('Sleep', SleepSchema);
module.exports = SleepModel;
