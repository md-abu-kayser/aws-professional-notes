"""
s3-event-processor.py

Sample Lambda function triggered by S3 ObjectCreated events.
Reads the uploaded object's metadata and logs basic info.
Extend this to trigger downstream processing (e.g. image resizing,
virus scanning, indexing into DynamoDB, etc).
"""

import json
import logging
import urllib.parse
import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3_client = boto3.client("s3")


def handler(event, context):
    """
    Entry point for the S3 event processor Lambda function.
    """
    logger.info("Received event: %s", json.dumps(event))

    results = []

    for record in event.get("Records", []):
        bucket = record["s3"]["bucket"]["name"]
        key = urllib.parse.unquote_plus(record["s3"]["object"]["key"])
        size = record["s3"]["object"].get("size")

        logger.info("Processing s3://%s/%s (%s bytes)", bucket, key, size)

        try:
            head = s3_client.head_object(Bucket=bucket, Key=key)
            content_type = head.get("ContentType", "unknown")
        except Exception as exc:  # noqa: BLE001
            logger.error("Failed to head object %s/%s: %s", bucket, key, exc)
            content_type = "unknown"

        results.append(
            {
                "bucket": bucket,
                "key": key,
                "size": size,
                "content_type": content_type,
            }
        )

    return {
        "statusCode": 200,
        "body": json.dumps({"processed": results}),
    }
