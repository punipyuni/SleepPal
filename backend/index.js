const app = require('./app');
const database = require('./config/database');
const AuthModel = require('./model/authModel');

const port = 3000;

app.get('/', (req, res) => {
    res.send('The server is working. It is running on port 3000!');
});

app.listen(port, () => {
  console.log(`Server listening on Port http://localhost:${port}`);
});