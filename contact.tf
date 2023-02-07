##############################################################################################################
# ACCT.01 – Set account-level contacts to valid email distribution lists                                     # 
##############################################################################################################

resource "aws_account_alternate_contact" "operations" {
  count = var.create_account_alternate_contact ? 1 : 0

  alternate_contact_type = "OPERATIONS"

  name          = "OPERATIONS"
  title         = "Operations Contact"
  email_address = var.operations_email
  phone_number  = var.operations_phone_number
}

resource "aws_account_alternate_contact" "billing" {
  count                  = var.create_account_alternate_contact ? 1 : 0
  alternate_contact_type = "BILLING"

  name          = "BILLING"
  title         = "Billing contact"
  email_address = var.billing_email
  phone_number  = var.billing_phone_number
}

resource "aws_account_alternate_contact" "security" {
  count                  = var.create_account_alternate_contact ? 1 : 0
  alternate_contact_type = "SECURITY"

  name          = "SECURITY"
  title         = "Security contact"
  email_address = var.security_email
  phone_number  = var.security_phone_number
}