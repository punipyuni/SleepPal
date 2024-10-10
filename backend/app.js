const express = require('express');
const bodyParser = require('body-parser');
const userRouter = require('./routers/user.routers');
const profileRouter = require('./routers/profile.routers');

const app = express();

app.use(bodyParser.json());

app.use('/', userRouter);
app.use('/', profileRouter);

module.exports = app;