resource "aws_s3_bucket" "mybucket" {
  bucket = "mybucket"
  acl = "public"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
}


resource "aws_s3_bucket_versioning" "mybucket" {
  bucket = aws_s3_bucket.mybucket.id

  versioning_configuration {
    status = "Enabled"
  }
}



resource "aws_s3_bucket" "mybucket_log_bucket" {
  bucket = "mybucket-log-bucket"
}

resource "aws_s3_bucket_logging" "mybucket" {
  bucket = aws_s3_bucket.mybucket.id

  target_bucket = aws_s3_bucket.mybucket_log_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "b" {
  bucket = aws_s3_bucket.b.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = "IPAllow"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.b.arn,
          "${aws_s3_bucket.b.arn}/*",
        ]
        Condition = {
          IpAddress = {
            "aws:SourceIp" = "8.8.8.8/32"
          }
        }
      },
    ]
  })
}
