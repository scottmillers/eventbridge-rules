/*
  Write to the Dynamodb database
*/
const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { PutCommand, DynamoDBDocumentClient } = require("@aws-sdk/lib-dynamodb");

async function PutTableItem(event, tableName) {
    try {
      // Get the lambda region from environment variable
      const region = process.env.AWS_REGION || 'us-east-1';
  
  
      // Create an DynamoDb client
      const dynamoDbClient = new DynamoDBClient({ region });
      const docClient = DynamoDBDocumentClient.from(dynamoDbClient);
  
      // Extract the data for insertion into DB
      const account = event.detail.account;
      const time = event.detail.time;
      const data = JSON.stringify(event, null, 2)
  
      const command = new PutCommand({
        TableName: tableName,
        Item: {
          Account: account,
          Time: time,
          Transaction: data
        },
      })
  
      console.log(data);
  
      // Insert into DB
      const response = await docClient.send(command);
  
      console.log(response);
  
      return response;
    } catch (error) {
      console.error(error);
      return error;
    }
  }

  module.exports = { PutTableItem };