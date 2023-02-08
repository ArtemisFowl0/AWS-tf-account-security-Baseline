##############################################################################################################
# ACCT.07 – Deliver CloudTrail logs to a protected S3 bucket                                                 # 
##############################################################################################################

resource "aws_cloudtrail" "default" {
  count          = var.create_cloudtrail ? 1 : 0
  name           = "cloudtrail"
  s3_bucket_name = "cloudtrail-logs-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail[0].arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail.arn
  enable_log_file_validation = true
  enable_logging             = true

  event_selector {
    exclude_management_event_sources = []
    include_management_events        = true
    read_write_type                  = "All"

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3"]
    }

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }

    data_resource {
      type   = "AWS::DynamoDB::Table"
      values = ["arn:aws:dynamodb"]
    }
  }

  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = false

  kms_key_id = aws_kms_key.cloudtrail[0].arn
  tags = merge(var.tags, {
    Name = "CloudTrail"
  })
}

###################
# CloudTrail role #
###################
resource "aws_iam_role" "cloudtrail" {
  name               = "cloudtrail"
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_assume_role.json
  tags = merge(var.tags, {
    Name = "CloudTrail"
  })
}

data "aws_iam_policy_document" "cloudtrail_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

# Role policy attachments
resource "aws_iam_role_policy_attachment" "cloudtrail" {
  count      = var.create_cloudtrail ? 1 : 0
  role       = aws_iam_role.cloudtrail.arn
  policy_arn = aws_iam_policy.cloudtrail[0].arn
}

#######################
# CloudTrail policies #
#######################
resource "aws_iam_policy" "cloudtrail" {
  count  = var.create_cloudtrail ? 1 : 0
  name   = "AWSCloudTrail"
  policy = data.aws_iam_policy_document.cloudtrail.json
  tags = merge(var.tags, {
    Name = "CloudTrail"
  })
}

data "aws_iam_policy_document" "cloudtrail" {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogStream"]
    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.cloudtrail[0].name}:log-stream:*"]
  }

  statement {
    effect  = "Allow"
    actions = ["logs:PutLogEvents"]
    #tfsec:ignore:aws-iam-no-policy-wildcards
    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.cloudtrail[0].name}:log-stream:*"]
  }
}

########################
# CloudWatch log group #
########################
resource "aws_cloudwatch_log_group" "cloudtrail" {
  count             = var.create_cloudtrail && var.create_cloudwatch ? 1 : 0
  name              = "cloudtrail"
  retention_in_days = 0
  kms_key_id        = aws_kms_key.cloudtrail[0].arn
  tags = merge(var.tags, {
    Name = "CloudTrail"
  })
}

######################
# CloudWatch KMS key #
######################
resource "aws_kms_key" "cloudtrail" {
  count               = var.create_cloudtrail ? 1 : 0
  key_usage           = "ENCRYPT_DECRYPT"
  policy              = data.aws_iam_policy_document.cloudtrail_kms.json
  is_enabled          = true
  enable_key_rotation = true
  tags = merge(var.tags, {
    Name = "CloudTrail"
  })
}

data "aws_iam_policy_document" "cloudtrail_kms" {
  statement {
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["kms:GenerateDataKey*"]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = ["arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"]
    }

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["kms:DescribeKey"]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:ReEncryptFrom"
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = ["arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["kms:CreateAlias"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["ec2.${data.aws_region.current.name}.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:ReEncryptFrom"
    ]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = ["arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:GenerateDataKey*",
      "kms:Decrypt"
    ]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  # CloudWatch
  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
    }

    condition {
      test     = "ArnLike"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
    }
  }
}