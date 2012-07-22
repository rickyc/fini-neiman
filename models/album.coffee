mongoose = require('mongoose')
Schema = mongoose.Schema

AlbumSchema = new Schema
  title: String
  hash: String
  created_at: { type: Date, default: Date.now }

module.exports = mongoose.model('Album', AlbumSchema)
