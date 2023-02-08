##############################################################################################################
# ACCT.12 – Monitor for and resolve high-risk issues by using Trusted Advisor                                # 
##############################################################################################################
/*
data "aws_trusted_advisor_check_result" "example" {
  check_id = "test123"

  filter {
    name   = "status"
    values = ["warning", "error"]
  }
}
*/