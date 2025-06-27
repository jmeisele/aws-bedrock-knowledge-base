resource "aws_iam_role" "iam_for_bedrock_logs" {
  name               = "bedrock-logs-role"
  assume_role_policy = data.aws_iam_policy_document.assume_bedrock_logs.json
}

resource "aws_iam_role_policy" "iam_policy_for_bedrock_logs" {
  name   = "bedrock-logs-policy"
  policy = data.aws_iam_policy_document.bedrock_logs.json
  role   = aws_iam_role.iam_for_bedrock_logs.name
}