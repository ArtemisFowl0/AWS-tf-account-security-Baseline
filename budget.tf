##############################################################################################################
# ACCT.10 – Configure AWS Budgets to monitor your spending                                                   # 
##############################################################################################################

resource "aws_budgets_budget" "zero_spend_budget_aws_free_tier" {
  count       = var.aws-free-tier ? 0 : 1
  name        = "Zero Spend Budget"
  budget_type = "COST"

  time_unit = "MONTHLY"

  cost_filters = {
    "Example Filter" = "Example Value"
  }

  limit_amount = 0
  limit_unit   = "USD"

  threshold_rule {
    threshold_value = 0
    threshold_type  = "PERCENTAGE"

    trigger_actions {
      action_type         = "CUT_COST"
      comparison_operator = "GREATER_THAN"
      notification        = var.budget_notification
    }
  }
}

resource "aws_budgets_budget" "zero_spend_budget" {
  count       = var.aws-free-tier == 0 ? 0 : 1
  name        = "Example Budget"
  budget_type = "COST"

  time_unit = "MONTHLY"

  cost_filters = {
    "Example Filter" = "Example Value"
  }

  limit_amount = var.max_budget_notification
  limit_unit   = "USD"

  threshold_rule {
    threshold_value = 100
    threshold_type  = "PERCENTAGE"

    trigger_actions {
      action_type         = "CUT_COST"
      comparison_operator = "GREATER_THAN"
      notification        = var.budget_notification
    }
  }
}