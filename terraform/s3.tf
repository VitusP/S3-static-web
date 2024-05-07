## S3 Bucket
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

resource "aws_s3_bucket_notification" "vitus_mac_data_bucket_notification" {
  depends_on = [aws_sns_topic_subscription.vitus_mac_data_bucket_sns_topic_subscription, aws_sns_topic.vitus_mac_data_bucket_sns_topic]
  bucket     = aws_s3_bucket.vitus_mac_data_bucket.id

  topic {
    topic_arn = aws_sns_topic.vitus_mac_data_bucket_sns_topic.arn
    events    = ["s3:ObjectCreated:*"]
  }
}

## SNS Topic
resource "aws_sns_topic" "vitus_mac_data_bucket_sns_topic" {
  name   = "vitus_mac_data_bucket_sns_topic"
  policy = data.aws_iam_policy_document.vitus_mac_data_bucket_sns_topic_policy.json
}

data "aws_iam_policy_document" "vitus_mac_data_bucket_sns_topic_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions   = ["SNS:Publish"]
    resources = ["arn:aws:sns:*:*:vitus_mac_data_bucket_sns_topic"]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.vitus_mac_data_bucket.arn]
    }
  }
}

resource "aws_sns_topic_subscription" "vitus_mac_data_bucket_sns_topic_subscription" {
  topic_arn = aws_sns_topic.vitus_mac_data_bucket_sns_topic.arn
  protocol  = "email"
  endpoint  = "vitus.putra@gmail.com"
}
