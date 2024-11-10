const AuthModel = require('../models/authModel');
const jwt = require('jsonwebtoken');

class AuthService {
    static async registerUser(email, password) {
        try {
            const createUser = new AuthModel({ email, password });
            return await createUser.save();
        } catch (err) {
            throw err;
        }
    }

    static async getUserByEmail(email) {
        try {
            return await AuthModel.findOne({ email });
        } catch (err) {
            console.log(err);
        }
    }

    static async checkUser(email) {
        try {
            return await AuthModel.findOne({ email });
        } catch (err) {
            throw err;
        }
    }

    static async generateAccessToken(tokenData,JWTSecret_Key,JWT_EXPIRE){
        return jwt.sign(tokenData, JWTSecret_Key, { expiresIn: JWT_EXPIRE });
    }

}

function SnackBar(message, type) {
    const x = document.getElementById("snackbar");
    x.innerHTML = message;
    x.className = "show";
    if (type === 'error') {
        x.style.backgroundColor = "red";
    } else {
        x.style.backgroundColor = "green";
    }
    setTimeout(function () { x.className = x.className.replace("show", ""); }, 3000);
}

module.exports = AuthService;