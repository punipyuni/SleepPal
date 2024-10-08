const router = require('express').Router();
const UserControllers = require('../controller/user.controller');

router.post('/signup', UserControllers.register);
router.post('/login', UserControllers.login);

module.exports = router;