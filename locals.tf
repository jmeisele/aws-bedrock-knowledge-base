locals {
  embedding_model_id         = "amazon.titan-embed-text-v2:0"
  invoke_model_id            = "amazon.nova-micro-v1:0"
  filters_base_pattern       = "{$.output.outputBodyJson.amazon-bedrock-trace.guardrail.input.{}.contentPolicy.filters[*].action=\"BLOCKED\" && $.output.outputBodyJson.amazon-bedrock-trace.guardrail.input.{}.contentPolicy.filters[*].type=\""
  topics_input_base_pattern  = "{$.output.outputBodyJson.amazon-bedrock-trace.guardrail.input.{}.topicPolicy.topics[*].action=\"BLOCKED\" && $.output.outputBodyJson.amazon-bedrock-trace.guardrail.input.{}.topicPolicy.topics[*].name=\""
  topics_output_base_pattern = "{$.output.outputBodyJson.amazon-bedrock-trace.guardrail.outputs[0].{}.topicPolicy.topics[*].action=\"BLOCKED\" && $.output.outputBodyJson.amazon-bedrock-trace.guardrail.outputs[0].{}.topicPolicy.topics[*].name=\""
}