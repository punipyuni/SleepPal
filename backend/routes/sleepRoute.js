// routes/sleepRoute.js
const router = require('express').Router();
const sleepController = require('../controllers/sleepController');
const authMiddleware = require('../middleware/authMiddleware');

router.get('/', authMiddleware, sleepController.getSleepData); // Fetch sleep data for the logged-in user
router.post('/', authMiddleware, sleepController.saveSleepData); // Save sleep data for the logged-in user

module.exports = router;
