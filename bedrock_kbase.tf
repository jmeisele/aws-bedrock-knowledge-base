# resource "aws_bedrockagent_knowledge_base" "this" {
#   name        = "pokemon"
#   description = "This KBase contains Pokemon related data"
#   role_arn    = aws_iam_role.knowledge_base.arn
#   knowledge_base_configuration {
#     vector_knowledge_base_configuration {
#       embedding_model_arn = "arn:aws:bedrock:${var.region}::foundation-model/${local.embedding_model_id}"
#       embedding_model_configuration {
#         bedrock_embedding_model_configuration {
#           dimensions          = 1024
#           embedding_data_type = "FLOAT32"
#         }
#       }
#     }
#     type = "VECTOR"
#   }
#   storage_configuration {
#     type = "OPENSEARCH_SERVERLESS"
#     opensearch_serverless_configuration {
#       collection_arn    = aws_opensearchserverless_collection.this.arn
#       vector_index_name = opensearch_index.pokemon_kb.name
#       field_mapping {
#         vector_field   = "bedrock-knowledge-base-default-vector"
#         text_field     = "AMAZON_BEDROCK_TEXT_CHUNK"
#         metadata_field = "AMAZON_BEDROCK_METADATA"
#       }
#     }
#   }
#   depends_on = [
#     opensearch_index.pokemon_kb
#   ]
# }

# resource "aws_bedrockagent_data_source" "s3" {
#   knowledge_base_id = aws_bedrockagent_knowledge_base.this.id
#   name              = "pokemon_s3_bucket"
#   data_source_configuration {
#     type = "S3"
#     s3_configuration {
#       bucket_arn = aws_s3_bucket.pokemon.arn
#     }
#   }
# }