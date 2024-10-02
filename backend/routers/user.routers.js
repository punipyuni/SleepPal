const router = require('express').Router();
const UserControllers = require('../controller/user.controller');

router.post('/signup', UserControllers.register);

module.exports = router;