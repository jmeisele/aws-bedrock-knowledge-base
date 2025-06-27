import json
import logging
import os

import boto3
from botocore.exceptions import ClientError

BEDROCK_KNOWLEDGE_BASE_ID = os.environ["BEDROCK_KNOWLEDGE_BASE_ID"]
BEDROCK_DATA_SOURCE_ID = os.environ["BEDROCK_DATA_SOURCE_ID"]

logger = logging.getLogger()
logger.setLevel(logging.INFO)

bedrock_agent = boto3.client("bedrock-agent", region_name=os.environ["AWS_REGION"])


def lambda_handler(event: dict, context: dict) -> dict:
    """Trigger knowledge base sync job

    Args:
        event (dict): Incoming payload to lambda runtime
        context (dict): Context

    Returns:
        dict: Status code and body
    """
    logger.info(f"Event: {event}:")
    logger.info(f"Context: {context}:")

    try:
        logger.info(
            f"Starting ingestion job for data source {BEDROCK_DATA_SOURCE_ID} of knowledge base {BEDROCK_KNOWLEDGE_BASE_ID}"
        )
        response = bedrock_agent.start_ingestion_job(
            knowledgeBaseId=BEDROCK_KNOWLEDGE_BASE_ID,
            dataSourceId=BEDROCK_DATA_SOURCE_ID,
        )
        ingestion_job_id = response["ingestionJob"]["ingestionJobId"]
        return {"statusCode": 200, "body": "Success"}
    except ClientError as e:
        return {"statusCode": 500, "body": f"Client error: {str(e)}"}
    except Exception as e:
        return {"statusCode": 500, "body": f"Unexpected error: {str(e)}"}
