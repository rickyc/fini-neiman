Album = require('../models/album')
Photo = require('../models/photo')

exports.show = (req, res, next) ->
  Album.findOne {hash: req.params.hash}, (error, album) ->
    if album
      Photo.find {_album: album._id}, (error, photos) ->
        res.render 'album', { photos: photos, title: 'image' }
