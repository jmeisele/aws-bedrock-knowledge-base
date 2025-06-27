import json
import logging
import os

import boto3

BEDROCK_KNOWLEDGE_BASE_ID = os.environ["BEDROCK_KNOWLEDGE_BASE_ID"]
BEDROCK_MODEL_ARN = os.environ["BEDROCK_MODEL_ARN"]
BEDROCK_GUARDRAIL_ID = os.environ["BEDROCK_GUARDRAIL_ID"]
BEDROCK_GUARDRAIL_VERSION = os.environ["BEDROCK_GUARDRAIL_VERSION"]


logger = logging.getLogger()
logger.setLevel(logging.INFO)

bedrock_agent_runtime = boto3.client("bedrock-agent-runtime", "us-east-1")


def lambda_handler(event: dict, context: dict) -> dict[str, any]:
    logger.info(f"Event: {event}")
    logger.info(f"Context: {context}")
    prompt = f"""
    You are a virtual assistant for Pokemon.
    <rules>
    - You only provide information, answer questions, and provide recommendations about Pokemon.
    - If the user asks about any non-pokemon related or relevant topic, just say 'Sorry, I can not respond to this. I can recommend you Regions products and answer your questions about these'.
    - If you have the information it's also OK to respond to Monster Hunter questions.
    - Do not make up or create answers that are not based on facts. It’s OK to say that you don’t know an answer.
    </rules>

    Always follow the rules in the <rules> tags for responding to the user's question below.
    {event["event"]}
    """

    # input_body = {"inputText": prompt}
    logger.info(f"prompt: {prompt}")

    response = bedrock_agent_runtime.retrieve_and_generate(
        input={"text": prompt},
        retrieveAndGenerateConfiguration={
            "knowledgeBaseConfiguration": {
                "knowledgeBaseId": BEDROCK_KNOWLEDGE_BASE_ID,
                "modelArn": BEDROCK_MODEL_ARN,
                "generationConfiguration": {
                    "guardrailConfiguration": {
                        "guardrailId": BEDROCK_GUARDRAIL_ID,
                        "guardrailVersion": BEDROCK_GUARDRAIL_VERSION,
                    }
                },
            },
            "type": "KNOWLEDGE_BASE",
        },
    )

    logger.info(f"response: {response}")

    if len(response["citations"][0]["retrievedReferences"]) != 0:
        context = response["citations"][0]["retrievedReferences"]["content"]["text"]
        doc_url = response["citations"][0]["retrievedReferences"]["s3Location"]["uri"]
        return {
            "statusCode": 200,
            "body": json.dumps(
                {
                    "knowledge_base_response": response["output"]["text"],
                    "context": context,
                    "doc_url": doc_url,
                }
            ),
        }

    return {
        "statusCode": 200,
        "body": json.dumps(
            {
                "knowledge_base_response": response["output"]["text"],
            }
        ),
    }
