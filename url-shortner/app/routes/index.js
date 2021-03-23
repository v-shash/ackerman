const express = require('express');
const router = express.Router();

const urlService = require('../services/UrlService');

let shortUrlRgex = new RegExp('[a-zA-Z0-9]{9}');
const _ = require("lodash")


// @route     GET /:shortUrl
// @desc      Redirect to long/original URL
router.get('/:shortUrl', async (req, res) => {

  if (!shortUrlRgex.test(req.params.shortUrl)) {
    return res.status(400).json({
      error: "Url not supported by service"
    })
  }

  try {
    const url = await urlService.getOne(req.params.shortUrl);

    if (!_.isEmpty(url)) {
      return res.redirect(url.Item.url);
    } else {
      return res.status(404).json({ error: 'No url found' });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({error: 'Server error'});
  }
});

module.exports = router;
