const mongoose = require('mongoose');
const db = require('../config/db');
const UserModel = require('./user.model');

const { Schema } = mongoose;

const profileSchema = new Schema({
    userId: {
        type: Schema.Types.ObjectId,
        ref: UserModel.modelName,
        required: true,
    },
    image_background: {
        type: String,
    },
    height: {
        type: Number,
    },
    weight: {
        type: Number,
    },
    blood_type: {
        type: String,
    },
    medication: {
        type: [String],
    },
    // TODO: Add more fields here
},{timestamps:true});

const ProfileModel = db.model('profile', profileSchema);

module.exports = ProfileModel;