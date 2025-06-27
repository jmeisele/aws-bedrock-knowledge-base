provider "aws" {
  allowed_account_ids     = [var.account_id]
  access_key              = var.access_key
  secret_key              = var.secret_key
  region                  = var.region
  skip_metadata_api_check = true
  default_tags {
    tags = {
      GitHubRepo = "aws-bedrock-knowldge-base"
      Workspace  = "aws-bedrock-knowldge-base"
    }
  }
}

provider "opensearch" {
  url            = aws_opensearchserverless_collection.this.collection_endpoint
  aws_access_key = var.access_key
  aws_secret_key = var.secret_key
  healthcheck    = false
}