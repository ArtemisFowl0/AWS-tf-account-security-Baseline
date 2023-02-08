data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_vpc" "all_vpcs" {default = true}


