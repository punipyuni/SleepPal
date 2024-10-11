const AuthModel = require('../models/authModel');

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

    static async generateToken(tokenData, secretKey, jwtExpiry) {
        return jwt.sign(tokenData, secretKey, { expiresIn: jwtExpiry });
    }
}

module.exports = AuthService();