# resource "aws_cloudwatch_log_metric_filter" "guardrail_did_not_intervene" {
#   name           = "GUARDRAIL_DID_NOT_INTERVENE"
#   pattern        = "{$.output.outputBodyJson.amazon-bedrock-guardrailAction=\"NONE\"}"
#   log_group_name = aws_cloudwatch_log_group.bedrock_model.name

#   metric_transformation {
#     name      = "GUARDRAIL_DID_NOT_INTERVENE"
#     namespace = "/aws/Bedrock/Guardrails"
#     value     = "1"
#     unit      = "Count"
#   }
# }

# resource "aws_cloudwatch_log_metric_filter" "guardrail_did_intervene" {
#   name           = "GUARDRAIL_INTERVENED"
#   pattern        = "{$.output.outputBodyJson.amazon-bedrock-guardrailAction=\"INTERVENED\"}"
#   log_group_name = aws_cloudwatch_log_group.bedrock_model.name

#   metric_transformation {
#     name      = "GUARDRAIL_INTERVENED"
#     namespace = "/aws/Bedrock/Guardrails"
#     value     = "1"
#     unit      = "Count"
#   }
# }

# resource "aws_cloudwatch_log_metric_filter" "invocations_with_guardrails" {
#   name           = "Invocations-with-Guardrails"
#   pattern        = "%amazon-bedrock-trace%"
#   log_group_name = aws_cloudwatch_log_group.bedrock_model.name

#   metric_transformation {
#     name      = "Invocations-with-Guardrails"
#     namespace = "/aws/Bedrock/Guardrails"
#     value     = "1"
#     unit      = "Count"
#   }
# }

# resource "aws_cloudwatch_log_metric_filter" "prompt_sexual_filter_failed" {
#   name           = "PROMPT_SEXUAL_FILTER_FAILED"
#   pattern        = "${replace(local.filters_base_pattern, "{}", aws_bedrock_guardrail.this.guardrail_id)}SEXUAL\"}"
#   log_group_name = aws_cloudwatch_log_group.bedrock_model.name

#   metric_transformation {
#     name      = "PROMPT_SEXUAL_FILTER_FAILED"
#     namespace = "/aws/Bedrock/Guardrails"
#     value     = "1"
#     unit      = "Count"
#   }
# }

# resource "aws_cloudwatch_log_metric_filter" "prompt_violence_filter_failed" {
#   name           = "PROMPT_VIOLENCE_FILTER_FAILED"
#   pattern        = "${replace(local.filters_base_pattern, "{}", aws_bedrock_guardrail.this.guardrail_id)}VIOLENCE\"}"
#   log_group_name = aws_cloudwatch_log_group.bedrock_model.name

#   metric_transformation {
#     name      = "PROMPT_VIOLENCE_FILTER_FAILED"
#     namespace = "/aws/Bedrock/Guardrails"
#     value     = "1"
#     unit      = "Count"
#   }
# }

# resource "aws_cloudwatch_log_metric_filter" "prompt_hate_filter_failed" {
#   name           = "PROMPT_HATE_FILTER_FAILED"
#   pattern        = "${replace(local.filters_base_pattern, "{}", aws_bedrock_guardrail.this.guardrail_id)}HATE\"}"
#   log_group_name = aws_cloudwatch_log_group.bedrock_model.name

#   metric_transformation {
#     name      = "PROMPT_HATE_FILTER_FAILED"
#     namespace = "/aws/Bedrock/Guardrails"
#     value     = "1"
#     unit      = "Count"
#   }
# }

# resource "aws_cloudwatch_log_metric_filter" "prompt_insults_filter_failed" {
#   name           = "PROMPT_INSULTS_FILTER_FAILED"
#   pattern        = "${replace(local.filters_base_pattern, "{}", aws_bedrock_guardrail.this.guardrail_id)}INSULTS\"}"
#   log_group_name = aws_cloudwatch_log_group.bedrock_model.name

#   metric_transformation {
#     name      = "PROMPT_INSULTS_FILTER_FAILED"
#     namespace = "/aws/Bedrock/Guardrails"
#     value     = "1"
#     unit      = "Count"
#   }
# }

# resource "aws_cloudwatch_log_metric_filter" "prompt_misconduct_filter_failed" {
#   name           = "PROMPT_MISCONDUCT_FILTER_FAILED"
#   pattern        = "${replace(local.filters_base_pattern, "{}", aws_bedrock_guardrail.this.guardrail_id)}MISCONDUCT\"}"
#   log_group_name = aws_cloudwatch_log_group.bedrock_model.name

#   metric_transformation {
#     name      = "PROMPT_MISCONDUCT_FILTER_FAILED"
#     namespace = "/aws/Bedrock/Guardrails"
#     value     = "1"
#     unit      = "Count"
#   }
# }

# resource "aws_cloudwatch_log_metric_filter" "prompt_attack_filter_failed" {
#   name           = "PROMPT_PROMPT_ATTACK_FILTER_FAILED"
#   pattern        = "${replace(local.filters_base_pattern, "{}", aws_bedrock_guardrail.this.guardrail_id)}PROMPT_ATTACK\"}"
#   log_group_name = aws_cloudwatch_log_group.bedrock_model.name

#   metric_transformation {
#     name      = "PROMPT_PROMPT_ATTACK_FILTER_FAILED"
#     namespace = "/aws/Bedrock/Guardrails"
#     value     = "1"
#     unit      = "Count"
#   }
# }

# resource "aws_cloudwatch_log_metric_filter" "finance_topic_input_denied" {
#   name           = "FINANCE_TOPIC_INPUT_DENIED"
#   pattern        = "${replace(local.topics_input_base_pattern, "{}", aws_bedrock_guardrail.this.guardrail_id)}Finance\"}"
#   log_group_name = aws_cloudwatch_log_group.bedrock_model.name

#   metric_transformation {
#     name      = "FINANCE_TOPIC_INPUT_DENIED"
#     namespace = "/aws/Bedrock/Guardrails"
#     value     = "1"
#     unit      = "Count"
#   }
# }

# resource "aws_cloudwatch_log_metric_filter" "politicis_topic_input_denied" {
#   name           = "POLITICS_TOPIC_INPUT_DENIED"
#   pattern        = "${replace(local.topics_input_base_pattern, "{}", aws_bedrock_guardrail.this.guardrail_id)}Politics\"}"
#   log_group_name = aws_cloudwatch_log_group.bedrock_model.name

#   metric_transformation {
#     name      = "POLITICS_TOPIC_INPUT_DENIED"
#     namespace = "/aws/Bedrock/Guardrails"
#     value     = "1"
#     unit      = "Count"
#   }
# }

# resource "aws_cloudwatch_log_metric_filter" "finance_topic_output_denied" {
#   name           = "FINANCE_TOPIC_OUTPUT_DENIED"
#   pattern        = "${replace(local.topics_output_base_pattern, "{}", aws_bedrock_guardrail.this.guardrail_id)}Finance\"}"
#   log_group_name = aws_cloudwatch_log_group.bedrock_model.name

#   metric_transformation {
#     name      = "FINANCE_TOPIC_OUTPUT_DENIED"
#     namespace = "/aws/Bedrock/Guardrails"
#     value     = "1"
#     unit      = "Count"
#   }
# }

# resource "aws_cloudwatch_log_metric_filter" "politics_topic_output_denied" {
#   name           = "POLITICS_TOPIC_OUTPUT_DENIED"
#   pattern        = "${replace(local.topics_output_base_pattern, "{}", aws_bedrock_guardrail.this.guardrail_id)}Politics\"}"
#   log_group_name = aws_cloudwatch_log_group.bedrock_model.name

#   metric_transformation {
#     name      = "POLITICS_TOPIC_OUTPUT_DENIED"
#     namespace = "/aws/Bedrock/Guardrails"
#     value     = "1"
#     unit      = "Count"
#   }
# }