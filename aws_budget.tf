resource "aws_budgets_budget" "capstone_budget" {
  name              = "CapstoneBudget"
  budget_type       = "COST"
  limit_amount      = "50"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"

  cost_types {
    include_tax       = true
    include_subscription = true
    use_blended        = true
    include_refund    = false
    include_credit    = false
    include_upfront   = true
    include_recurring = true
    include_other_subscription = true
    include_support   = true
    include_discount  = true
    use_amortized     = true
  }

  time_period_start = "2024-07-27_00:00"
  time_period_end   = "2025-08-31_00:00"

  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = 50
    threshold_type      = "PERCENTAGE"
    notification_type   = "ACTUAL"
    subscriber_email_addresses = ["mcitccrf2301@gmail.com"]
  }

  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = 25
    threshold_type      = "PERCENTAGE"
    notification_type   = "ACTUAL"
    subscriber_email_addresses = ["mcitccrf2301@gmail.com"]
  }
}
