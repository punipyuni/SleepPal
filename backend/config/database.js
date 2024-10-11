const mongoose = require('mongoose');

const connection = mongoose.createConnection(`mongodb+srv://admin:tyGTnggu82RmL!N@database.das0c.mongodb.net/user-data`).on('open', () => {
    console.log('MongoDB connected');
}).on('error', () => {
    console.log('MongoDB Connection error');
});

module.exports = connection;