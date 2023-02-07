##############################################################################################################
# ACCT.11 – Enable and respond to GuardDuty notifications                                                    # 
##############################################################################################################

resource "aws_guardduty_detector" "MyDetector" {
  count  = var.create_guardduty_detector ? 1 : 0
  enable = true

  datasources {
    s3_logs {
      enable = true
    }
    kubernetes {
      audit_logs {
        enable = true
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = true
        }
      }
    }
  }
  tags = merge(var.tags, {
    Name = "GuardDuty Detector"
  })
}