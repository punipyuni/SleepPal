// models/profileModel.js
const mongoose = require('mongoose');
const database = require('../config/database');

const ProfileSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  weight: { type: String, default: '-' },
  height: { type: String, default: '-' },
  birthday: { type: Date, default: null },
  gender: { type: String, enum: ['Male', 'Female', 'Other', '-'], default: '-' },
  pregnancy: { type: String, enum: ['Yes', 'No', '-'], default: '-'},
});

const ProfileModel = database.model('Profile', ProfileSchema);
module.exports = ProfileModel;
