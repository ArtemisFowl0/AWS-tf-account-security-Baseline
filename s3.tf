##############################################################################################################
# ACCT.08 – Prevent public access to private S3 buckets                                                      # 
##############################################################################################################

resource "aws_s3_account_public_access_block" "example" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

##############################################################################################################
# ACCT.07 – Deliver CloudTrail logs to a protected S3 bucket                                                 # 
##############################################################################################################

resource "aws_s3_bucket" "default" {
  count         = var.create_cloudtrail ? 1 : 0
  bucket        = "cloudtrail-logs-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  force_destroy = var.force_destroy

  tags = merge(var.tags, {
    Name = "cloudtrail-logs-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  })
}

resource "aws_s3_bucket_acl" "default" {
  count  = var.create_cloudtrail ? 1 : 0
  bucket = aws_s3_bucket.default.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_versioning" "default" {

  bucket = aws_s3_bucket.default.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  count  = var.create_cloudtrail ? 1 : 0
  bucket = aws_s3_bucket.default.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "default" {
  count  = var.create_cloudtrail ? 1 : 0
  bucket = aws_s3_bucket.default.id
  policy = data.aws_iam_policy_document.combined.json
}

data "aws_iam_policy_document" "combined" {
  version = "2012-10-17"
  #require_ssl_requests
  statement {
    sid     = "AllowSSLRequestsOnly"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      "${aws_s3_bucket.default.arn}/*",
      "${aws_s3_bucket.default.arn}"
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
  
    statement {
    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${module.cloudtrail_s3_bucket.bucket_name}"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${module.cloudtrail_s3_bucket.bucket_name}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket_public_access_block" "default" {
  count  = var.create_cloudtrail ? 1 : 0
  bucket = aws_s3_bucket.default.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}