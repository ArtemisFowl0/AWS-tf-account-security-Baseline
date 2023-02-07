##############################################################################################################
# ACCT.09 – Delete unused VPCs, subnets, and security groups                                                     # 
##############################################################################################################

resource "aws_subnet" "delete_default_subnets" {
  count = length(data.aws_vpc.default.subnet_ids)

  subnet_id = data.aws_vpc.default.subnet_ids[count.index]

  depends_on = [
    aws_security_group.delete_default_security_group,
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "delete_default_security_group" {
  vpc_id = data.aws_vpc.default.id

  security_group_id = data.aws_vpc.default.default_security_group_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc" "delete_default_vpc" {
  vpc_id = data.aws_vpc.default.id

  depends_on = [
    aws_security_group.delete_default_security_group,
  ]

  lifecycle {
    create_before_destroy = true
  }
}
