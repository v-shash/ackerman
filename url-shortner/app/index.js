'use strict';

const express = require('express');
const morgan = require('morgan');
const helmet = require('helmet');
const cors = require('cors');

var AWS = require("aws-sdk");

AWS.config.getCredentials(function(err) {
  if (err) {
    console.log("Error getting AWS creds", err.stack);
    process.exit(1);
  }
  else {
    if (!AWS.config.region) {
      console.log("Region not specified. Must specify it in EV");
      process.exit(1)
    }
  }
});



// Constants
const PORT = 8080;
const HOST = '0.0.0.0';

morgan('tiny');

// App
const app = express();
app.use(helmet());
app.use(cors());
app.use(morgan());
app.use(helmet());
app.use(express.json({ extended: false }));


app.use('/newurl', require('./routes/newurl'))
app.use('/ping', require('./routes/ping'))
app.use('/', require('./routes/index'))


app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);