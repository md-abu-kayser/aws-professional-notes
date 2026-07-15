/**
 * api-handler.js
 *
 * Sample Lambda function for an API Gateway HTTP API backed by DynamoDB.
 * Supports:
 *   GET  /items       -> list items
 *   POST /items       -> create an item
 */

const {
  DynamoDBClient,
} = require("@aws-sdk/client-dynamodb");
const {
  DynamoDBDocumentClient,
  ScanCommand,
  PutCommand,
} = require("@aws-sdk/lib-dynamodb");
const { randomUUID } = require("crypto");

const client = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(client);

const TABLE_NAME = process.env.TABLE_NAME || "items-table";

exports.handler = async (event) => {
  const method = event.requestContext?.http?.method || event.httpMethod;

  try {
    if (method === "GET") {
      const data = await docClient.send(
        new ScanCommand({ TableName: TABLE_NAME })
      );
      return respond(200, data.Items || []);
    }

    if (method === "POST") {
      const body = JSON.parse(event.body || "{}");
      const item = {
        id: randomUUID(),
        ...body,
        createdAt: new Date().toISOString(),
      };

      await docClient.send(
        new PutCommand({ TableName: TABLE_NAME, Item: item })
      );

      return respond(201, item);
    }

    return respond(405, { message: `Method ${method} not allowed` });
  } catch (err) {
    console.error("Error handling request:", err);
    return respond(500, { message: "Internal server error" });
  }
};

function respond(statusCode, body) {
  return {
    statusCode,
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  };
}
