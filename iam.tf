##############################################################################################################
# ACCT.03 – Configure console access for each user                                                           # 
##############################################################################################################

#########
# Admin #
#########
resource "aws_iam_user" "admin" {
  name = "Admin"
  path = "/"
}

#########
# Enginner #
#########
resource "aws_iam_user" "engineer" {
  name = "Engineer"
  path = "/"
}

#########
# Read-Only #
#########
resource "aws_iam_user" "read_only" {
  name = "ReadOnly"
  path = "/"
}

##############################################################################################################
# ACCT.04 – Assign permissions                                                                               # 
##############################################################################################################

#########
# Admin #
#########
resource "aws_iam_group" "admin" {
  name = "Admin"
  path = "/"
}

# Group policy attachments
resource "aws_iam_group_policy_attachment" "admin" {
  group      = aws_iam_group.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

#########################
# AWSOrganisationsAdmin #
#########################
resource "aws_iam_group" "aws_organisations_admin" {
  name = "AWSOrganisationsAdmin"
  path = "/"
}

# Group policy attachments
resource "aws_iam_group_policy_attachment" "aws_organisations_admin_resource_groups" {
  group      = aws_iam_group.aws_organisations_admin.name
  policy_arn = "arn:aws:iam::aws:policy/ResourceGroupsandTagEditorFullAccess"
}

resource "aws_iam_group_policy_attachment" "aws_organisations_admin_custom" {
  group      = aws_iam_group.aws_organisations_admin.name
  policy_arn = aws_iam_policy.aws_organisations_admin.arn
}

#####################
# BillingFullAccess #
#####################
resource "aws_iam_group" "billing_full_access" {
  name = "BillingFullAccess"
  path = "/"
}

# Group policy attachments
resource "aws_iam_group_policy_attachment" "billing_full_access" {
  group      = aws_iam_group.billing_full_access.name
  policy_arn = aws_iam_policy.billing_full_access.arn
}

#########################
# IAMUserChangePassword #
#########################
resource "aws_iam_group" "iam_user_change_password" {
  name = "IAMUserChangePassword"
  path = "/"
}

# Group policy attachments
resource "aws_iam_group_policy_attachment" "iam_user_change_password" {
  group      = aws_iam_group.iam_user_change_password.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

##############################################################################################################
# ACCT.06 – Enforce a password policy                                                                        # 
##############################################################################################################

resource "aws_iam_account_password_policy" "cis_policy" {
  minimum_password_length        = 14
  require_lowercase_characters   = true
  require_uppercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
  max_password_age               = 90
  password_reuse_prevention      = 24
  hard_expiry                    = true
}




