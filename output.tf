output "default_event_bus_arn" {
  description = "The ARN of the default event bus"
  value       = data.aws_cloudwatch_event_bus.default.arn
}

output "lambda_consumer1_alias_arn" {
  value = module.lambda_consumer1_alias.lambda_alias_arn
}


output "lambda_consumer2_alias_arn" {
  value = module.lambda_consumer2_alias.lambda_alias_arn
}


output "lambda_consumer3_alias_arn" {
  value = module.lambda_consumer3_alias.lambda_alias_arn
}


