const express = require('express');
const path = require('path');
const morgan = require('morgan');
const app = express();

const PORT = process.env.PORT || 3000;

require('dotenv').config();

app.use(morgan(':date[iso] | :remote-addr | :method :url | Status: :status | :response-time ms'));

// Ruta dinámica para variables de entorno
app.get('/env-config.js', (req, res) => {
  res.type('application/javascript');
  res.send(`
    window.ENV = {
      API_BASE_URL: "${process.env.API_BASE_URL || 'http://localhost:5080/api'}"
    };
  `);
});

app.use(express.static(path.join(__dirname, '')));


app.use((req, res, next) => {
  if (req.accepts('html')) {
    res.sendFile(path.join(__dirname, 'index.html'));
  } else {
    res.status(404).send('Recurso no encontrado');
  }
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
