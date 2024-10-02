const UserService = require('../services/user.services');

exports.register = async(req, res, next) => {
    try {
        const { email, password } = req.body;
        const successResgister = await UserService.registerUser(email, password);
        
        res.json({status: true, message: 'User registered successfully'});
    } catch (error) {
        throw error
    }
}