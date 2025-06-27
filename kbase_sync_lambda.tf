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
