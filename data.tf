data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["bedrock.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.account_id]
    }
    condition {
      test     = "ArnLike"
      variable = "AWS:SourceArn"
      values   = ["arn:aws:bedrock:${var.region}:${var.account_id}:knowledge-base/*"]
    }
  }
}

data "aws_iam_policy_document" "bedrock_model_policies" {
  statement {
    effect = "Allow"
    actions = [
      "bedrock:ListFoundationModels",
      "bedrock:ListCustomModels"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "bedrock:InvokeModel"
    ]
    resources = [
      "*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "bedrock:RetrieveAndGenerate"
    ]
    resources = ["*"]
  }
  statement {
    effect  = "Allow"
    actions = ["bedrock:Retrieve"]
    resources = [
      aws_bedrockagent_knowledge_base.this.arn
    ]
  }
}

data "aws_iam_policy_document" "s3_policies" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [aws_s3_bucket.pokemon.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceAccount"
      values   = [var.account_id]
    }
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.pokemon.bucket}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceAccount"
      values   = [var.account_id]
    }
  }
}

data "aws_iam_policy_document" "opensearch_policies" {
  statement {
    effect = "Allow"
    actions = [
      "aoss:APIAccessAll"
    ]
    resources = [aws_opensearchserverless_collection.this.arn]
  }
}

data "aws_iam_policy_document" "kb_logs" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["${aws_cloudwatch_log_group.kb_logs.arn}:log-stream:*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.account_id]
    }
  }
}

data "aws_iam_policy_document" "assume_lambda" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda_start_kb_sync" {
  statement {
    effect = "Allow"
    actions = [
      "bedrock:StartIngestionJob"
    ]
    resources = [
      "arn:aws:bedrock:${var.region}:${var.account_id}:knowledge-base/*"
    ]
  }
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

data "archive_file" "kbase_sync_handler" {
  type        = "zip"
  source_file = "${path.module}/src/kbase_sync_handler.py"
  output_path = "kbase_sync_handler.zip"
}

data "archive_file" "kbase_invoke_handler" {
  type        = "zip"
  source_file = "${path.module}/src/kbase_invoke_handler.py"
  output_path = "kbase_invoke_handler.zip"
}