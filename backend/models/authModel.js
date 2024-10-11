const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const database = require('../config/database');

const { Schema } = mongoose;

const AuthSchema = new Schema({
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
},{timestamps:true});

AuthSchema.methods.comparePassword = async function(userPassword) {
    try {
        const isMatch = await bcrypt.compare(userPassword, this.password);
        return isMatch;
    } catch (error) {
        throw error;
    }
}

AuthSchema.pre('save', async function(next) {
    try{
        var user = this;
        const salt = await bcrypt.genSalt(10);
        const hashpass = await bcrypt.hash(user.password, salt);

        user.password = hashpass;
    } catch (error) {
        next(error);
    }
});

const AuthModel = database.model('Auth', AuthSchema);

module.exports = AuthModel;