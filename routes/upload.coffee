Album = require('../models/album')
Photo = require('../models/photo')

# Post upload
exports.upload = (req, res, next) ->
  util = require('util')

  album = new Album({hash: Math.uuid(17)})
  album.save (err) -> console.log "album" + err

  for key of req.files
    s3ObjectName = req.files[key].s3ObjectName

    photo = new Photo({path: s3ObjectName, _album: album._id})
    photo.save (err) -> console.log "photo" + err

    console.log util.inspect(req.files[key])
    console.log "File \"" + key + "\" uploaded as : " + s3ObjectName

  req.method = 'get'
  res.redirect "/#{album.hash}"
  #res.send album.hash
