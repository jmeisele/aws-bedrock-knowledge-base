resource "aws_lambda_function" "start_kb_ingestion_jobs" {
  function_name = "start_kb_ingestion_job"
  role          = aws_iam_role.lambda_kbase.arn
  description   = "Lambda function that starts ingestion job for Bedrock Knowledge Base"
  filename      = data.archive_file.kbase_sync_handler.output_path
  handler       = "kbase_sync_handler.lambda_handler"
  runtime       = "python3.13"
  architectures = ["arm64"]
  timeout       = 60
  # source_code_hash is required to detect changes to Lambda code/zip
  source_code_hash = data.archive_file.kbase_sync_handler.output_base64sha256
  environment {
    variables = {
      BEDROCK_KNOWLEDGE_BASE_ID = aws_bedrockagent_knowledge_base.this.id
      BEDROCK_DATA_SOURCE_ID    = aws_bedrockagent_data_source.s3.data_source_id
    }
  }
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_kb_ingestion_jobs.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.pokemon.arn
}

# resource "aws_lambda_permission" "allow_cloudwatch" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.start_kb_ingestion_jobs.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.start_kb_ingestion_job.arn
# }
