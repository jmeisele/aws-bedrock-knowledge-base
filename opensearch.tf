resource "aws_opensearchserverless_security_policy" "pokemon_kb_encryption" {
  name        = "${var.collection_name}-encryption"
  type        = "encryption"
  description = "Encryption"
  policy = jsonencode({
    "Rules" = [
      {
        "ResourceType" : "collection",
        "Resource" = [
          "collection/${var.collection_name}"
        ],
        "ResourceType" = "collection"
      }
    ],
    "AWSOwnedKey" = true
  })
}

resource "aws_opensearchserverless_security_policy" "pokemon_kb_network" {
  name        = "${var.collection_name}-network"
  type        = "network"
  description = "Bedrock access"
  policy = jsonencode([
    {
      Description = "Bedrock network access for ${var.collection_name} collection",
      Rules = [
        {
          ResourceType = "collection",
          Resource = [
            "collection/${var.collection_name}"
          ]
        },
      ],
      AllowFromPublic = true
      # SourceServices = [
      #   "bedrock.amazonaws.com"
      # ],
    }
  ])
}

resource "aws_opensearchserverless_access_policy" "pokemon_kb_data" {
  name        = "${var.collection_name}-data"
  type        = "data"
  description = "Bedrock data access for ${var.collection_name} index"
  policy = jsonencode([
    {
      Rules = [
        {
          ResourceType = "index",
          Resource = [
            "index/${var.collection_name}/*"
          ],
          Permission = [
            "aoss:*"
          ]
        },
        {
          ResourceType = "collection",
          Resource = [
            "collection/${var.collection_name}"
          ],
          Permission = [
            "aoss:*"
          ]
        }
      ],
      Principal = [
        aws_iam_role.knowledge_base.arn,
        data.aws_caller_identity.current.arn
      ]
    }
  ])
}

resource "aws_opensearchserverless_collection" "this" {
  name = "pokemon"
  type = "VECTORSEARCH"
  depends_on = [
    aws_opensearchserverless_security_policy.pokemon_kb_encryption,
    aws_opensearchserverless_security_policy.pokemon_kb_network,
    aws_opensearchserverless_access_policy.pokemon_kb_data
  ]
}

resource "time_sleep" "wait_before_index_creation" {
  depends_on      = [aws_opensearchserverless_access_policy.pokemon_kb_data]
  create_duration = "60s" # Wait for 60 seconds before creating the index
}

resource "opensearch_index" "pokemon_kb" {
  name = "bedrock-knowledge-base-default-index"
  #   number_of_shards               = "2"
  #   number_of_replicas             = "0"
  index_knn                      = true
  index_knn_algo_param_ef_search = "512"
  mappings                       = <<-EOF
    {
      "properties": {
        "bedrock-knowledge-base-default-vector": {
          "type": "knn_vector",
          "dimension": 1024,
          "method": {
            "name": "hnsw",
            "engine": "faiss",
            "parameters": {
              "m": 16,
              "ef_construction": 512
            },
            "space_type": "l2"
          }
        },
        "AMAZON_BEDROCK_METADATA": {
          "type": "text",
          "index": "false"
        },
        "AMAZON_BEDROCK_TEXT_CHUNK": {
          "type": "text",
          "index": "true"
        }
      }
    }
  EOF
  force_destroy                  = true
  lifecycle {
    ignore_changes = [mappings]
  }

  depends_on = [
    aws_opensearchserverless_collection.this,
    time_sleep.wait_before_index_creation
  ]
}