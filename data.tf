data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_vpc" "default" {default = true}
data "aws_security_groups" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

