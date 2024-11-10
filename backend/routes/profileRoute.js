// routes/profileRoute.js
const router = require('express').Router();
const profileController = require('../controllers/profileController');
const authMiddleware = require('../middleware/authMiddleware');

router.get('/', authMiddleware, profileController.getProfile); // Fetch profile for the logged-in user
router.put('/', authMiddleware, profileController.updateProfile); // Update profile for the logged-in user

module.exports = router;
