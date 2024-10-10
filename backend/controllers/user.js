const UserService = require('../services/user');

exports.register = async (req, res, next) => {
    try {
        const { username, email, password } = req.body;

        const successResgister = await UserService.registerUser(username, email, password);

        res.json({ status: true, message: 'User registered successfully' });
    } catch (error) {
        throw error
    }
}

exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;

        const user = await UserService.checkUser(email);

        if (!user) {
            throw new Error('User not found');
        }

        const isMatch = await user.comparePassword(password);
        if (isMatch === false) {
            throw new Error('Invalid password');
        }

        let tokenData = {
            _id: user._id,
            email: user.email,
        }

        const token = await UserService.generateToken(tokenData, "secretKey", '60 * 5');

        res.status(200).json({
            status: true,
            token: token,
            success: 'Data send'
        });

    } catch (error) {
        console.log(error, 'error---->');
        next(error);
    }
}