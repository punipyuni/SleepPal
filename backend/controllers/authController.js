const AuthService = require('../services/authService');

exports.register = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        const duplicate = await AuthService.getUserByEmail(email);
        if (duplicate) {
            //res.status(400).json({ status: false, message: `${email} is already registered` });
            throw new Error(`${email} is already registered`);
        }
        const response = await AuthService.registerUser(email, password);

        res.json({ status: true, message: 'User registered successfully' });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
}

exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            throw new Error('Email or Password is missing');
        }   
        let user = await AuthService.checkUser(email);
        if (!user) {
            throw new Error('User not found');
        }

        const isPasswordCorrect = await user.comparePassword(password);

        if (isPasswordCorrect === false) {
            throw new Error(`Username or Password does not match`);
        }

        let tokenData = {
            _id: user._id,
            email: user.email,
        }

        const token = await AuthService.generateAccessToken(tokenData, "secret", '24h');

        res.status(200).json({
            status: true,
            success: 'Data send',
            token: token,
        });

    } catch (error) {
        console.log(error, 'error---->');
        next(error);
    }
}