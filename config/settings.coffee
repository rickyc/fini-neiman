config = {}
config.s3 = {}
config.s3.accessKeyId = process.env.S3_ACCESS_KEY_ID
config.s3.secretAccessKey = process.env.S3_SECRET_ACCESS_KEY
config.s3.awsAccountId = process.env.S3_AWS_ACCOUNT_ID
config.s3.bucketName = process.env.S3_BUCKET_NAME

module.exports = config
