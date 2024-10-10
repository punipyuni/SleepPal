const app = require('./app');
const db = require('./config/db');
const UserModel = require('./model/user.model');
const ProfileModel = require('./model/profile.model');

const port = 3000;

app.get('/', (req, res) => {
    res.send('The server is working. It is running on port 3000!');
});

app.listen(port, () => {
  console.log(`Server listening on Port http://localhost:${port}`);
});