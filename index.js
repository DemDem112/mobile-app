const express = require('express');
const app = express();
app.use(express.json());

app.post('/customer/login', (req, res) => {
  console.log('Login request:', req.body);
  res.json({ message: 'Login received', data: req.body });
});

app.listen(3000, '0.0.0.0', () => {
  console.log('Server running on http://0.0.0.0:3000');
});
