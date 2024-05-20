## S3 Bucket
resource "aws_s3_bucket" "vitus_personal_site_bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_website_configuration" "vitus_personal_site_bucket" {
  bucket = aws_s3_bucket.vitus_personal_site_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "vitus_personal_site_bucket" {
  bucket = aws_s3_bucket.vitus_personal_site_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.vitus_personal_site_bucket]
}

resource "aws_s3_bucket_public_access_block" "vitus_personal_site_bucket" {
  bucket = aws_s3_bucket.vitus_personal_site_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.vitus_personal_site_bucket,
  ]

  bucket = aws_s3_bucket.vitus_personal_site_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_versioning" "vitus_personal_site_bucket" {
  bucket = aws_s3_bucket.vitus_personal_site_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "static_site_policy" {
  bucket = aws_s3_bucket.vitus_personal_site_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.vitus_personal_site_bucket.arn}/*"
      }
    ]
  })
}

# resource "aws_s3_object" "object-upload-html" {
#     for_each        = fileset("../src/", "*.html")
#     bucket          = data.aws_s3_bucket.selected-bucket.bucket
#     key             = each.value
#     source          = "${each.value}"
#     content_type    = "text/html"
#     etag            = filemd5("${each.value}")
#     acl             = "public-read"
# }

resource "aws_s3_object" "index" {
  key          = "index.html"
  bucket       = aws_s3_bucket.vitus_personal_site_bucket.id
  source       = "../src/index.html"
  content_type = "text/html"
  acl          = "public-read"
}

resource "aws_s3_object" "error" {
  key          = "error.html"
  bucket       = aws_s3_bucket.vitus_personal_site_bucket.id
  source       = "../src/error.html"
  content_type = "text/html"
  acl          = "public-read"
}

resource "aws_s3_object" "css" {
  key          = "portfolio.css"
  bucket       = aws_s3_bucket.vitus_personal_site_bucket.id
  source       = "../src/portfolio.css"
  content_type = "text/css"
  acl          = "public-read"
}

output "bucket_endpoint" {
  value = aws_s3_bucket_website_configuration.vitus_personal_site_bucket.website_endpoint
}
