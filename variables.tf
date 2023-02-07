##############################################################################################################
# ACCT.01 – Set account-level contacts to valid email distribution lists                                                # 
##############################################################################################################

variable "create_account_alternate_contact" {
  type        = bool
  description = "Create Account Alternate Contact"
  default     = true
}

variable "operations_email" {
  type        = string
  description = "Operations Email"
  default     = null
}

variable "operations_phone_number" {
  type        = string
  description = "Operations phone number"
  default     = null
}

variable "security_email" {
  type        = string
  description = "Security Email"
  default     = null
}

variable "security_phone_number" {
  type        = string
  description = "Security phone number"
  default     = null
}

variable "billing_email" {
  type        = string
  description = "Billing  Email"
  default     = null
}

variable "billing_phone_number" {
  type        = string
  description = "Billing  phone number"
  default     = null
}

##############################################################################################################
# ACCT.02 – Restrict use of the root user                                                                    # 
##############################################################################################################

variable "create_organization" {
  type        = bool
  description = "Create Organization"
  default     = true
}

variable "restrict_use_of_root" {
  type        = bool
  description = "Restrict use of the root user"
  default     = true
}

##############################################################################################################
# ACCT.05 – Require multi-factor authentication (MFA) to log in                                              # 
##############################################################################################################

variable "require_mfa" {
  type        = bool
  description = "Require multi-factor authentication (MFA) to log in"
  default     = true
}

##############################################################################################################
# ACCT.07 – Deliver CloudTrail logs to a protected S3 bucket                                                 # 
##############################################################################################################

variable "create_cloudtrail" {
  type        = bool
  description = "Create CloudTrail"
  default     = true
}

variable "create_cloudwatch" {
  type        = bool
  description = "Create CloudTrail KMS Key"
  default     = true
}

##############################################################################################################
# ACCT.10 – Configure AWS Budgets to monitor your spending                                                   # 
##############################################################################################################

variable "budget_notification" {
  description = "Budget email notification"
  type        = string
}

variable "aws-free-tier" {
  type        = bool
  description = "Is AWS Free Tier Account"
}

variable "max_budget_notification" {
  type        = number
  description = "Max Budget Notification"
  default     = 10
}

##############################################################################################################
# ACCT.11 – Enable and respond to GuardDuty notifications                                                    # 
##############################################################################################################

variable "create_guardduty_detector" {
  type        = bool
  description = "Create GuardDuty Detector"
  default     = true
}


##############################################################################################################
variable "tags" {
  type        = map(string)
  description = "Tags"
  default     = {}
}


