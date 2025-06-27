resource "aws_lambda_function" "invoke_lambda" {
  function_name = "bedrock_kbase_invoke_lambda"
  role          = aws_iam_role.lambda_invoke.arn
  description   = "Lambda function that queries Bedrock Foundational Model using a Knowledge Base"
  filename      = data.archive_file.kbase_invoke_handler.output_path
  handler       = "kbase_invoke_handler.lambda_handler"
  runtime       = "python3.13"
  architectures = ["arm64"]
  timeout       = 60
  # source_code_hash is required to detect changes to Lambda code/zip
  source_code_hash = data.archive_file.kbase_invoke_handler.output_base64sha256
  environment {
    variables = {
      BEDROCK_KNOWLEDGE_BASE_ID = aws_bedrockagent_knowledge_base.this.id
      BEDROCK_MODEL_ARN         = local.invoke_model_id
    }
  }
}