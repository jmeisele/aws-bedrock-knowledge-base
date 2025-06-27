resource "aws_cloudwatch_log_group" "start_kb_ingestion_jobs" {
  name              = "/aws/lambda/start_kb_ingestion_job"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_delivery_source" "kb_logs" {
  name         = "bedrock-kb-${aws_bedrockagent_knowledge_base.this.name}"
  log_type     = "APPLICATION_LOGS"
  resource_arn = aws_bedrockagent_knowledge_base.this.arn
}

resource "aws_cloudwatch_log_group" "kb_logs" {
  name              = "/aws/vendedlogs/bedrock/knowledge-base/APPLICATION_LOGS/${aws_bedrockagent_knowledge_base.this.id}"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_resource_policy" "kb_logs" {
  policy_name     = "bedrock-kb-${aws_bedrockagent_knowledge_base.this.id}-policy"
  policy_document = data.aws_iam_policy_document.kb_logs.json
}

resource "aws_cloudwatch_log_delivery_destination" "kb_logs_cloudwatch_logs" {
  name = "bedrock-kb-${aws_bedrockagent_knowledge_base.this.id}-cloudwatch-logs"
  delivery_destination_configuration {
    destination_resource_arn = aws_cloudwatch_log_group.kb_logs.arn
  }
  depends_on = [aws_cloudwatch_log_resource_policy.kb_logs]
}

resource "aws_cloudwatch_log_delivery" "kb_logs_cloudwatch_logs" {
  delivery_destination_arn = aws_cloudwatch_log_delivery_destination.kb_logs_cloudwatch_logs.arn
  delivery_source_name     = aws_cloudwatch_log_delivery_source.kb_logs.name
}