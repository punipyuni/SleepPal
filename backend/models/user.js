const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const database = require('../config/database');

const { Schema } = mongoose;

const userSchema = new Schema({
    username: {
        type: String,
        required: [true, "Username is required"],
    },
    email: {
        type: String,
        lowercase: true,
        required: [true, "Email is required"],
        match: [
            /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/,
            "Email format is not correct",
        ],
        unique: true,
    },
    password: {
        type: String,
        required: [true, "Password is required"],
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
        type: Array,
    },
},{timestamps:true});

userSchema.methods.comparePassword = async function(userPassword) {
    try {
        const isMatch = await bcrypt.compare(userPassword, this.password);
        return isMatch;
    } catch (error) {
        throw error;
    }
}

userSchema.pre('save', async function(next) {
    try{
        var user = this;
        const salt = await bcrypt.genSalt(10);
        const hashpass = await bcrypt.hash(user.password, salt);

        user.password = hashpass;
    } catch (error) {
        next(error);
    }
});

const UserModel = database.model('user', userSchema);

module.exports = UserModel;