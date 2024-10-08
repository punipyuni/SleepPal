const UserModel = require('../model/user.model');
const jwt = require('jsonwebtoken');

class UserService {
  static async registerUser(username, email, password) {
    try {
      const createUser = new UserModel({ username, email, password });
      return await createUser.save();
    } catch (err) {
      throw err;
    }
  }

  static async checkUser(email) {
    try {
      return await UserModel.findOne({ email });
    } catch (err) {
      throw err;
    }
  }

  static async generateToken(tokenData, secretKey, jwtExpiry) {
    return jwt.sign(tokenData, secretKey, { expiresIn: jwtExpiry });
  }
}

module.exports = UserService;