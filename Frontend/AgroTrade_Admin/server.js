const express = require('express');
const path = require('path');
const morgan = require('morgan');
const app = express();

const PORT = process.env.PORT || 3000;


app.use(morgan(':date[iso] | :remote-addr | :method :url | Status: :status | :response-time ms'));


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
