resource "aws_s3_bucket" "vitus_mac_data_bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_policy" "vitus_mac_data_bucket_policy" {
  bucket = aws_s3_bucket.vitus_mac_data_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",

    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::126163598931:user/vitus"
        },
        Action = "s3:*",
        Resource = [
          aws_s3_bucket.vitus_mac_data_bucket.arn,
          "${aws_s3_bucket.vitus_mac_data_bucket.arn}/*"
        ]
      },
    ]
  })
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.vitus_mac_data_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
