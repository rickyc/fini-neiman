# Module dependencies.
express = require('express')
connectStreamS3 = require('connect-stream-s3')
amazon = require('awssum').load('amazon/amazon')

config = require('./config/settings')

# Mongoose
mongoose = require('mongoose')
if process.env.NODE_ENV == 'production'
  mongoose.connect(process.env.MONGOHQ_URL)
else
  mongoose.connect('mongodb://localhost/my_database')

Album = require('./models/album')
Photo = require('./models/photo')

require('./lib/Math.uuid')

# S3 Upload
s3StreamMiddleware = connectStreamS3
  accessKeyId     : config.s3.accessKeyId,
  secretAccessKey : config.s3.secretAccessKey,
  awsAccountId    : config.s3.awsAccountId,
  region          : amazon.US_EAST_1,
  bucketName      : config.s3.bucketName,
  concurrency     : 2

setS3ObjectName = (req, res, next) ->
  req.files.file.s3ObjectName = (new Date()).toISOString().substr(0, 19) + "-" + req.files.file.name  if req.files.file
  next()

randomiseS3ObjectNames = (req, res, next) ->
  m = undefined
  path = "username/#{parseInt(Math.random() * 1000000000)}/"
  new_files = {}

  i = 0
  for file in req.files['filesToUpload'][0]
    util = require('util')
    req.files['filesToUpload'][0][i].s3ObjectName = parseInt(Math.random()*1000000000) + "-" + file.name.replace(/\s/g, '_')
    new_files[i] = req.files['filesToUpload'][0][i]
    i += 1
  req.files = new_files
  next()


# Express
app = module.exports = express.createServer(express.logger())
app.use(express.bodyParser())

    
# Configuration
app.configure ->
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use require('stylus').middleware({ src: "#{__dirname}/public" })
  app.use app.router
  app.use express.static("#{__dirname}/public")

app.configure 'development', ->
  app.use express.errorHandler
    dumpExceptions: true
    showStack: true

app.configure 'production', ->
  app.use express.errorHandler()

# Routes
app.get '/', require('./routes').index

app.post '/multiple-files', randomiseS3ObjectNames, s3StreamMiddleware, require('./routes/upload').upload

app.get "/:hash", require('./routes/show').show

# Run
port = process.env.PORT || 3000
app.listen port, ->
  console.log 'Express server listening on port %d in %s mode', app.address().port, app.settings.env
