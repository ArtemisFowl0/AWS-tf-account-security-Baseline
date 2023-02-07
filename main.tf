terraform {
  required_version = ">= 1.1.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.51.0"

      # A provider alias should be passed for each AWS region.
      # Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html
      configuration_aliases = [
        aws.ap-northeast-1, aws.ap-northeast-2, aws.ap-northeast-3,
        aws.ap-south-1,
        aws.ap-southeast-1, aws.ap-southeast-2,
        aws.ca-central-1,
        aws.eu-central-1,
        aws.eu-north-1,
        aws.eu-west-1, aws.eu-west-2, aws.eu-west-3,
        aws.sa-east-1,
        aws.us-east-1, aws.us-east-2,
        aws.us-west-1, aws.us-west-2,
      ]
    }
  }
}


