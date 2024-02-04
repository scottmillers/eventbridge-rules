

12/22 
When I apply the Terraform I get this deprecated warning:


│ Warning: Argument is deprecated
│ 
│   with module.eventbridge.aws_cloudwatch_event_rule.this["consumer1"],
│   on .terraform/modules/eventbridge/main.tf line 91, in resource "aws_cloudwatch_event_rule" "this":
│   91:   is_enabled          = lookup(each.value, "enabled", true)
│ 
│ Use "state" instead
╵
╷

12/22 Fixed by adding an lambda alias to the lambda module.  The lambda module now has a default alias of "current".  The eventbridge module now uses the alias instead of the $LATEST version.


│ Error: adding Lambda Permission (atm-consumer-1/EventBridgeRule): InvalidParameterValueException: We currently do not support adding policies for $LATEST.
│ {
│   RespMetadata: {
│     StatusCode: 400,
│     RequestID: "f402a717-f1ff-48a4-9b1e-e68fd063c21a"
│   },
│   Message_: "We currently do not support adding policies for $LATEST.",
│   Type: "User"
│ }
│ 
│   with module.lambda_consumer1.aws_lambda_permission.current_version_triggers["EventBridgeRule"],
│   on .terraform/modules/lambda_consumer1/main.tf line 243, in resource "aws_lambda_permission" "current_version_triggers":
│  243: resource "aws_lambda_permission" "current_version_triggers" {
│ 