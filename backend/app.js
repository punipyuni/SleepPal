// In backend/app.js
const express = require('express');
const bodyParser = require('body-parser');
const authRoutes = require('./routes/authRoute');
const profileRoutes = require('./routes/profileRoute');
const sleepRoutes = require('./routes/sleepRoute');

const app = express();

app.use(bodyParser.json());
app.use('/auth', authRoutes);
app.use('/profile', profileRoutes);
app.use('/sleep', sleepRoutes);

module.exports = app;
