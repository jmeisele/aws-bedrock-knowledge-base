resource "aws_bedrock_model_invocation_logging_configuration" "this" {
  logging_config {
    embedding_data_delivery_enabled = false
    image_data_delivery_enabled     = false
    text_data_delivery_enabled      = true
    cloudwatch_config {
      log_group_name = aws_cloudwatch_log_group.bedrock_model.name
      role_arn       = aws_iam_role.iam_for_bedrock_logs.arn
    }
  }
}

resource "aws_bedrock_guardrail" "this" {
  name                      = "ai-pokemon-assistant-guardrail"
  blocked_input_messaging   = "Sorry, I can not respond to this. I can recommend you Pokemon and answer your questions about these."
  blocked_outputs_messaging = "Sorry, I can not respond to this. I can recommend you Pokemon and answer your questions about these."
  description               = "Only respond to the Pokemon related questions, is protected against the most common prompt mis-use threads, provides content moderation, and doesn't answer to competitor's references."

  content_policy_config {
    filters_config {
      input_strength  = "HIGH"
      output_strength = "HIGH"
      type            = "HATE"
    }
    filters_config {
      input_strength  = "HIGH"
      output_strength = "HIGH"
      type            = "SEXUAL"
    }
    filters_config {
      input_strength  = "HIGH"
      output_strength = "HIGH"
      type            = "VIOLENCE"
    }
    filters_config {
      input_strength  = "HIGH"
      output_strength = "HIGH"
      type            = "INSULTS"
    }
    filters_config {
      input_strength  = "HIGH"
      output_strength = "HIGH"
      type            = "MISCONDUCT"
    }
    filters_config {
      input_strength  = "HIGH"
      output_strength = "NONE"
      type            = "PROMPT_ATTACK"
    }
  }

  sensitive_information_policy_config {
    pii_entities_config {
      type   = "NAME"
      action = "BLOCK"
    }
    pii_entities_config {
      type   = "AGE"
      action = "ANONYMIZE"
    }

    regexes_config {
      action      = "BLOCK"
      description = "example regex"
      name        = "regex_example"
      pattern     = "^\\d{3}-\\d{2}-\\d{4}$"
    }
  }

  topic_policy_config {
    topics_config {
      name = "Finance"
      examples = [
        "What are the cheapest rates?",
        "Where can I invest to get rich?",
        "I want a refund!"
      ]
      type       = "DENY"
      definition = "Investment advice refers to inquiries, guidance, or recommendations regarding the management or allocation of funds or assets with the goal of generating returns ."
    }
    topics_config {
      name = "Politics"
      examples = [
        "What is the political situation in that country?",
        "Give me a list of destinations governed by the greens"
      ]
      type       = "DENY"
      definition = "Statements or questions about politics or politicians"
    }
  }

  word_policy_config {
    managed_word_lists_config {
      type = "PROFANITY"
    }
    words_config {
      text = "Digimon"
    }
    words_config {
      text = "Yugioh"
    }
  }
}

resource "aws_bedrock_guardrail_version" "this" {
  description   = "example"
  guardrail_arn = aws_bedrock_guardrail.this.guardrail_arn
  skip_destroy  = false
}