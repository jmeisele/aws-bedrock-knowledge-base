resource "aws_cloudwatch_dashboard" "this" {
  dashboard_name = "Bedrock-Guardrails-Dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        height = 6
        width  = 8
        x      = 0
        y      = 0
        type   = "metric"

        properties = {
          metrics = [
            ["/aws/Bedrock/Guardrails", "GUARDRAIL_INTERVENED", { "region" : "us-east-1", "color" : "#d62728" }, ],
            [".", "GUARDRAIL_DID_NOT_INTERVENE", { "region" : "us-east-1", "color" : "#2ca02c" }]
          ]
          view                 = "pie"
          region               = "us-east-1"
          title                = "Guardrails Intervention"
          period               = 60
          stat                 = "Sum"
          setPeriodToTimeRange = true
          sparkline            = false
          trend                = false
        }
      },
      {
        height = 6
        width  = 9
        y      = 0
        x      = 8
        type   = "metric"
        properties = {
          metrics = [
            ["AWS/Bedrock", "Invocations"],
            ["/aws/Bedrock/Guardrails", "Invocations-with-Guardrails"]
          ]
          view                 = "bar"
          region               = "us-east-1"
          title                = "Invocations vs Invocations With Guardrails"
          period               = 60
          stat                 = "Sum"
          setPeriodToTimeRange = true
          sparkline            = false
          trend                = false
        }
      },
      {
        height = 6
        width  = 8
        y      = 6
        x      = 0
        type   = "metric"
        properties = {
          metrics = [
            ["/aws/Bedrock/Guardrails", "PROMPT_HATE_FILTER_FAILED", { "region" : "us-east-1" }],
            [".", "PROMPT_INSULTS_FILTER_FAILED", { "region" : "us-east-1" }],
            [".", "PROMPT_VIOLENCE_FILTER_FAILED", { "region" : "us-east-1" }],
            [".", "PROMPT_SEXUAL_FILTER_FAILED", { "region" : "us-east-1" }],
            [".", "PROMPT_MISCONDUCT_FILTER_FAILED", { "region" : "us-east-1" }],
            [".", "PROMPT_PROMPT_ATTACK_FILTER_FAILED", { "region" : "us-east-1" }]
          ]
          view                 = "bar"
          region               = "us-east-1"
          title                = "Failed Prompt Filters"
          period               = 60
          stat                 = "Sum"
          setPeriodToTimeRange = true
          sparkline            = false
          trend                = false
        }
      },
      {
        height = 6
        width  = 9
        y      = 6
        x      = 8
        type   = "metric"
        properties = {
          metrics = [
            ["/aws/Bedrock/Guardrails", "POLITICS_TOPIC_INPUT_DENIED", { "region" : "us-east-1" }],
            [".", "POLITICS_TOPIC_OUTPUT_DENIED", { "region" : "us-east-1" }],
            [".", "FINANCE_TOPIC_INPUT_DENIED", { "region" : "us-east-1" }],
            [".", "FINANCE_TOPIC_OUTPUT_DENIED", { "region" : "us-east-1" }]
          ],
          view                 = "bar"
          region               = "us-east-1"
          period               = 60
          stat                 = "Sum"
          setPeriodToTimeRange = true
          sparkline            = false
          trend                = false
          title                = "Denied Topics"
          stacked              = false
        }
      }
    ]
  })
}