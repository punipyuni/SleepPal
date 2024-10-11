const { Router } = require('express').Router;

router.post('/signup', AuthController.register);
router.post('/login', AuthController.login);

module.exports = router;