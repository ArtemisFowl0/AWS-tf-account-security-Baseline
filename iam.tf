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
# Billing #
#########
resource "aws_iam_user" "billing" {
  name = "Billing"
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

resource "aws_iam_user_group_membership" "admin" {
  user = aws_iam_user.admin.name

  groups = [
    aws_iam_group.admin.name,
    aws_iam_group.aws_organisations_admin.name,
  ]
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
  policy_arn = "arn:aws:iam::aws:policy/AWSBillingConductorFullAccess"
}

resource "aws_iam_user_group_membership" "billing" {
  user = aws_iam_user.billing.name

  groups = [
    aws_iam_group.billing_full_access.name,
  ]
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

resource "aws_iam_group_membership" "team" {
  name = "tf-testing-group-membership"

  users = [
    aws_iam_user.admin.name,
    aws_iam_user.billing.name,
    aws_iam_user.read_only.name,
  ]

  group = aws_iam_group.iam_user_change_password.name
}

#########################
# Read_Only #
#########################
resource "aws_iam_group" "read_only" {
  name = "IAMUserChangePassword"
  path = "/"
}

# Group policy attachments
resource "aws_iam_group_policy_attachment" "read_only" {
  group      = aws_iam_group.read_only.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_user_group_membership" "read_only" {
  user = aws_iam_user.read_only.name

  groups = [
    aws_iam_group.iam_user_change_password.name,
  ]
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




