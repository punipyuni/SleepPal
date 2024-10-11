const bodyParser = require('body-parser');
const express = require('express');
const mongoose = require('mongoose');
const AuthRouter = require('./routes/authRoute');

const app = express();

app.use(bodyParser.json());

app.use('/', AuthRouter);

module.exports = app;