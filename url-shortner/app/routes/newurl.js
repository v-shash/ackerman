const express = require('express');
const router = express.Router();
const validUrl = require('valid-url');
const urlService = require('../services/UrlService');
const _ = require("lodash")


const BASE_URL = process.env.BASE_URL;

if (!validUrl.isUri(BASE_URL)) {
    console.log("Invalid BASE_URL. Exiting")
    process.exit(1);
  }


router.post('/', async (req, res) => {
  const { url } = req.body;

  // Check long url
  if (validUrl.isUri(url)) {
    try {
      let savedUrl = await urlService.getANewUrl(url);

      if (!_.isEmpty(savedUrl)) {
        const ret = {
          ...savedUrl,
          shortenUrl: BASE_URL + "/" + savedUrl.shortenUrl
        }

        return res.status(201).json(ret);
      } else {
        return res.status(500).json({ error: 'unable to generate new shortenUrl. Server error'  });
      }
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Server error' });
    }
  } else {
    res.status(401).json({ error: 'Invalid long url' });
  }
});

module.exports = router;