##############################################################################################################
# ACCT.01 – Set account-level contacts to valid email distribution lists                                     # 
##############################################################################################################

#View account_infos in the organization
output "account_infos" {
  value = aws_organizations_organization.org[*].accounts[*]
}

##############################################################################################################
# ACCT.07 – Deliver CloudTrail logs to a protected S3 bucket                                                 # 
##############################################################################################################

output "cloudtrail_name" {
  value = aws_cloudtrail.default.name
}

output "s3_bucket_name" {
  value = aws_cloudtrail.default.s3_bucket_name
}

output "kms_key_arn" {
  value = aws_kms_key.cloudtrail.arn
}