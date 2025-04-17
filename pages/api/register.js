import mysql from 'mysql2';

const db = mysql.createConnection({
  host: process.env.MYSQL_HOST,
  user: process.env.MYSQL_USER,
  database: process.env.MYSQL_DATABASE,
  password: process.env.MYSQL_PASSWORD,
  port: process.env.MYSQL_PORT
});

export default function handler(req, res) {
  if (req.method === 'POST') {
    let body = '';
    req.on('data', chunk => {
      body += chunk.toString(); // convert Buffer to string
    });

    req.on('end', () => {
      const params = new URLSearchParams(body);
      const fullName = params.get('fullName');
      const email = params.get('email');
      const bloodType = params.get('bloodType');

      const sql = "INSERT INTO donors (full_name, email, blood_type) VALUES (?, ?, ?)";

      db.query(sql, [fullName, email, bloodType], (err, result) => {
        if (err) {
          return res.status(500).send("Database error: " + err.message);
        }
        res.status(200).send("Donor registered successfully!");
      });
    });
  } else {
    res.status(405).send("Method Not Allowed");
  }
}
