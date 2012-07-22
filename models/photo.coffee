mongoose = require('mongoose')
Schema = mongoose.Schema

PhotoSchema = new Schema
  name: String
  path: String
  _album: {type: Schema.ObjectId, ref: 'Album'}
  created_at: { type: Date, default: Date.now }

module.exports = mongoose.model('Photo', PhotoSchema)
