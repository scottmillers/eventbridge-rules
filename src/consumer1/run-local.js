// A simple wrapper for running the Lambda handler locally.

const main = async function() {
  await require('./handler').lambdaHandler()
}
main();
