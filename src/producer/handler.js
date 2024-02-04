const { EventBridgeClient, PutEventsCommand } = require("@aws-sdk/client-eventbridge");


exports.lambdaHandler = async (event) => {
    try {

        // Get the lambda region from environment variable
        const region = process.env.AWS_REGION || 'us-east-1'; 

        // Create an EventBridge client
        const eventBridgeClient = new EventBridgeClient({ region });

        /*const params = [
            {
                Source: "myApp",
                DetailType: "myEventType",
                Detail: JSON.stringify({ message: "Hello, EventBridge!" }),
            },
        ];
        */
        const {params} = require('./events.js')
     
        console.log('--- Sending Events ---')
        console.log(params)

        // Create the PutEventsCommand
        //const putEventsCommand = new PutEventsCommand({ Entries: params });
        const putEventsCommand = new PutEventsCommand(params);
        // Send the events to EventBridge
        const response = await eventBridgeClient.send(putEventsCommand);
        console.log("Events sent successfully:", response);
        return response;
    } catch (error) {
        console.error(error);
    }
};