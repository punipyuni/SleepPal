const jwt = require('jsonwebtoken');

module.exports = async (req, res, next) => {
    try {
        const token = req.headers.authorization?.split(' ')[1];
        
        if (!token) {
            throw new Error('Authentication required');
        }

        const decoded = jwt.verify(token, 'secret');  // Use the same secret as in auth service
        req.user = decoded;  // Add user data to request
        next();
    } catch (error) {
        res.status(401).json({
            status: false,
            message: 'Authentication failed'
        });
    }
};