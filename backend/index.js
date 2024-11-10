const app = require('./app');
const database = require('./config/database');

const port = 3000;

app.listen(port, () => {
  console.log(`Server listening on Port http://localhost:${port}`);
});