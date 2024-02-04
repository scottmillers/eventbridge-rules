const { PutTableItem } = require('./db');

exports.lambdaHandler = async (event, context) => {
  return await PutTableItem(event, "FailedTransactions")  
}

