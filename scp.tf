##############################################################################################################
# ACCT.02 – Restrict use of the root user                                                                    # 
##############################################################################################################

resource "aws_organizations_policy" "restrict_use_of_root" {
  count       = var.create_organization && var.restrict_use_of_root ? 1 : 0
  name        = "scp_root_account"
  description = "This SCP prevents restricts the root user in an AWS account from taking any action, either directly as a command or through the console. "
  type        = "SERVICE_CONTROL_POLICY"
  content     = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "*",
      "Resource": "*",
      "Effect": "Deny",
      "Condition": {
        "StringLike": {
          "aws:PrincipalArn": [
            "arn:aws:iam::*:root"
          ]
        }
      }
    }
  ]
}
POLICY
  tags = merge(var.tags, {
    Name = "SCP-RestrictUseOfRoot"
  })
}

resource "aws_organizations_policy_attachment" "root" {
  count     = var.create_organization && var.restrict_use_of_root ? 1 : 0
  policy_id = aws_organizations_policy.restrict_use_of_root.id
  target_id = aws_organizations_organization.org.roots[0].id
}

##############################################################################################################
# ACCT.05 – Require multi-factor authentication (MFA) to log in                                              # 
##############################################################################################################

resource "aws_organizations_policy" "require_mfa" {
  count       = var.create_organization && var.require_mfa ? 1 : 0
  name        = "scp_mfa"
  description = "This SCP requires multi-factor authentication (MFA) to log in to the AWS account."
  type        = "SERVICE_CONTROL_POLICY"
  content     = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "*",
      "Resource": "*",
      "Effect": "Deny",
      "Condition": {
        "BoolIfExists": {
          "aws:MultiFactorAuthPresent": "false"
        }
      }
    }
  ]
}
POLICY
  tags = merge(var.tags, {
    Name = "SCP-RequireMFA"
  })
}

resource "aws_organizations_policy_attachment" "root" {
  count     = var.create_organization && var.require_mfa ? 1 : 0
  policy_id = aws_organizations_policy.require_mfa.id
  target_id = aws_organizations_organization.org.roots[0].id
}