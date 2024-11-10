// models/authModel.js
const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const database = require('../config/database');
const { Schema } = mongoose;

const AuthSchema = new Schema({
    email: { 
        type: String, 
        required: true, 
        unique: true,
        validate: {
            validator: function (v) {
                return /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(v);
            },
            message: props => `${props.value} is not a valid email address!`
        },
    },
    password: { 
        type: String, 
        required: true,
    },
});

AuthSchema.pre('save', async function (next) {
    var user = this;
    if (!user.isModified("password")) {
        return
    }
    try {
        const salt = await bcrypt.genSalt(10);
        const hash = await bcrypt.hash(user.password, salt);
        user.password = hash;
    } catch (err) {
        throw err;
    }
});

AuthSchema.methods.comparePassword = async function (userPassword) {
    try {
        return await bcrypt.compare(userPassword, this.password);
    } catch (error) {
        throw error;
    }
}

const AuthModel = database.model('User', AuthSchema);

module.exports = AuthModel;