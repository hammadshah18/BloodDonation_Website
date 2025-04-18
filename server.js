const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// Connect to local MySQL
const db = mysql.createConnection({
  host: 'http://b8qdfxar6hvmbqwwykpc-mysql.services.clever-cloud.com',
  user: 'udgsco5v0isczcc5',
  password: 'tWY965BCMv8Hdhx2a9vP',
  database: 'b8qdfxar6hvmbqwwykpc'
});

db.connect(err => {
  if (err) throw err;
  console.log('Connected to MySQL Database');
});

app.post('/submit', (req, res) => {
  const { fullName, email, bloodType } = req.body;
  const sql = 'INSERT INTO donors (full_name, email, blood_type) VALUES (?, ?, ?)';
  db.query(sql, [fullName, email, bloodType], (err, result) => {
    if (err) throw err;
    res.send('Donor Registered!');
  });
});

app.listen(3000, () => console.log('Server running on port 3306'));
