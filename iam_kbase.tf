resource "aws_iam_role" "knowledge_base" {
  name               = "bedrock_pokemon_knowledge_base"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

resource "aws_iam_policy" "iam_policy_for_bedrock_models" {
  name        = "bedrock-model-policies"
  description = "AWS IAM Policy for accessing Bedrock models"
  policy      = data.aws_iam_policy_document.bedrock_model_policies.json
}

resource "aws_iam_policy" "iam_policy_for_s3" {
  name        = "s3-policies"
  description = "AWS IAM Policy for accessing bucket/objects"
  policy      = data.aws_iam_policy_document.s3_policies.json
}

resource "aws_iam_policy" "iam_policy_for_opensearch" {
  name        = "opensearch-serverless-policies"
  description = "AWS IAM Policy for accessing OpenSearch Collection"
  policy      = data.aws_iam_policy_document.opensearch_policies.json
}

resource "aws_iam_role_policy_attachment" "attach_bedrock_policy_to_iam_role" {
  role       = aws_iam_role.knowledge_base.name
  policy_arn = aws_iam_policy.iam_policy_for_bedrock_models.arn
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy_to_iam_role" {
  role       = aws_iam_role.knowledge_base.name
  policy_arn = aws_iam_policy.iam_policy_for_s3.arn
}

resource "aws_iam_role_policy_attachment" "attach_opensearch_policy_to_iam_role" {
  role       = aws_iam_role.knowledge_base.name
  policy_arn = aws_iam_policy.iam_policy_for_opensearch.arn
}