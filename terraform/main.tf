provider "aws" {
  access_key = "AKIA6CY4IDLETEVNMFW4"
  secret_key = "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"
  region     = "us-east-1"
}

/*
resource "aws_s3_bucket" "buckets_s3" {
  bucket = "bucketswnationaltest"
  tags = {
    Name = "bucketswnationaltest"
  }
}

resource "aws_s3_bucket_public_access_block" "buckets_s3" {
  bucket = aws_s3_bucket.buckets_s3.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "buckets_s3" {
  depends_on = [
    aws_s3_bucket_ownership_controls.buckets_s3,
    aws_s3_bucket_public_access_block.buckets_s3,
  ]

  bucket = aws_s3_bucket.buckets_s3.id
  acl    = "public-read"
}
*/