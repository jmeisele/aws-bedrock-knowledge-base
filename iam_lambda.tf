resource "aws_iam_role" "lambda_kbase" {
  name               = "bedrock_knowledge_base_sync"
  assume_role_policy = data.aws_iam_policy_document.assume_lambda.json
}

resource "aws_iam_policy" "lambda_kbase" {
  name        = "lambda_kbase_ingestion"
  description = "Lambda to start Bedrock Knowledge base ingestion/sync job"
  policy      = data.aws_iam_policy_document.lambda_start_kb_sync.json
}

resource "aws_iam_role_policy_attachment" "lambda_start_kb_sync" {
  role       = aws_iam_role.lambda_kbase.name
  policy_arn = aws_iam_policy.lambda_kbase.arn
}

resource "aws_iam_role" "lambda_invoke" {
  name               = "bedrock_invoke_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_lambda.json
}

resource "aws_iam_policy" "lambda_invoke" {
  name        = "bedrock_model_policies"
  description = "Bedrock Model policies"
  policy      = data.aws_iam_policy_document.bedrock_model_policies.json
}

resource "aws_iam_role_policy_attachment" "lambda_invoke" {
  role       = aws_iam_role.lambda_invoke.name
  policy_arn = aws_iam_policy.lambda_invoke.arn
}