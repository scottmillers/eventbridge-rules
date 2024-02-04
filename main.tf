provider "aws" {
  region = var.region

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true

}


resource "aws_dynamodb_table" "approved_transaction_table" {
  name           = "ApprovedTransactions"
  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "Account" # uses this as the partion key
  range_key = "Time"

  attribute {
    name = "Account"
    type = "S"
  }

  attribute {
    name = "Time"
    type = "S"
  }
}


resource "aws_dynamodb_table" "newyork_transaction_table" {
  name           = "NewYorkTransactions"
  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "Account" # uses this as the partion key
  range_key = "Time"

  attribute {
    name = "Account"
    type = "S"
  }

  attribute {
    name = "Time"
    type = "S"
  }
}

resource "aws_dynamodb_table" "failed_transaction_table" {
  name           = "FailedTransactions"
  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "Account" # uses this as the partion key
  range_key = "Time"

  attribute {
    name = "Account"
    type = "S"
  }

  attribute {
    name = "Time"
    type = "S"
  }
}


// Used to generate the events
module "lambda_producer" {
  source                   = "terraform-aws-modules/lambda/aws"
  version                  = "~> 6.0"
  function_name            = "producer"
  handler                  = "handler.lambdaHandler" # Assumes file name is index and handler is called handler
  runtime                  = "nodejs20.x"
  source_path              = "src/producer"
  attach_policy_statements = true # required to attach policy statement
  policy_statements = {
    eventbridge = {
      effect    = "Allow",
      actions   = ["events:PutEvents"],
      resources = [data.aws_cloudwatch_event_bus.default.arn]
    },
  }

}

// Lambda to get events from EventBridge
module "lambda_consumer1" {
  source        = "terraform-aws-modules/lambda/aws"
  version       = "~> 6.0"
  function_name = "consumer1"
  handler       = "handler.lambdaHandler" # Assumes file name is index and handler is called handler
  runtime       = "nodejs20.x"
  source_path   = "src/consumer1"
  attach_policy_statements = true # required to attach policy statement
  policy_statements = {
    dynamodb = {
      effect = "Allow"
      actions = [
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem"
      ],
      resources = [aws_dynamodb_table.approved_transaction_table.arn]
    }
  }

}

// A Lambda alias is required by the Terraform EventBridge module
module "lambda_consumer1_alias" {
  source           = "terraform-aws-modules/lambda/aws//modules/alias"
  refresh_alias    = false
  name             = "latest"
  function_name    = module.lambda_consumer1.lambda_function_name
  function_version = module.lambda_consumer1.lambda_function_version

  allowed_triggers = {
    EventBridgeRule = {
      principal  = "events.amazonaws.com"
      source_arn = module.eventbridge.eventbridge_rule_arns["consumer1"]
    }
  }

}

// Lambda to get events from an EventBridge rule and sends the output to cloudwatch
module "lambda_consumer2" {
  source        = "terraform-aws-modules/lambda/aws"
  version       = "~> 6.0"
  function_name = "consumer2"
  handler       = "handler.lambdaHandler" # Assumes file name is index and handler is called handler
  runtime       = "nodejs20.x"
  source_path   = "src/consumer2"
  attach_policy_statements = true # required to attach policy statement
  policy_statements = {
    dynamodb = {
      effect = "Allow"
      actions = [
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem"
      ],
      resources = [aws_dynamodb_table.newyork_transaction_table.arn]
    }
  }
}


// A Lambda alias is required by the Terraform EventBridge module
module "lambda_consumer2_alias" {
  source           = "terraform-aws-modules/lambda/aws//modules/alias"
  refresh_alias    = false
  name             = "latest"
  function_name    = module.lambda_consumer2.lambda_function_name
  function_version = module.lambda_consumer2.lambda_function_version

  allowed_triggers = {
    EventBridgeRule = {
      principal  = "events.amazonaws.com"
      source_arn = module.eventbridge.eventbridge_rule_arns["consumer2"]
    }
  }

}

// Lambda to get events from an EventBridge rule and sends the output to cloudwatch
module "lambda_consumer3" {
  source        = "terraform-aws-modules/lambda/aws"
  version       = "~> 6.0"
  function_name = "consumer3"
  handler       = "handler.lambdaHandler" # Assumes file name is index and handler is called handler
  runtime       = "nodejs20.x"
  source_path   = "src/consumer3"
  attach_policy_statements = true # required to attach policy statement
  policy_statements = {
    dynamodb = {
      effect = "Allow"
      actions = [
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem"
      ],
      resources = [aws_dynamodb_table.failed_transaction_table.arn]
    }
  }
}

// A Lambda alias is required by the Terraform EventBridge module
module "lambda_consumer3_alias" {
  source           = "terraform-aws-modules/lambda/aws//modules/alias"
  refresh_alias    = false
  name             = "latest"
  function_name    = module.lambda_consumer3.lambda_function_name
  function_version = module.lambda_consumer3.lambda_function_version

  allowed_triggers = {
    EventBridgeRule = {
      principal  = "events.amazonaws.com"
      source_arn = module.eventbridge.eventbridge_rule_arns["consumer3"]
    }
  }
}



// Get the default event bus
data "aws_cloudwatch_event_bus" "default" {
  name = "default"
}


module "eventbridge" {
  source     = "terraform-aws-modules/eventbridge/aws"
  create_bus = false

  attach_lambda_policy = true
  lambda_target_arns   = [module.lambda_consumer1_alias.lambda_alias_arn]

  rules = {
    consumer1 = {
      description = "Approved Transactions "
      event_pattern = jsonencode(
        {
          "source" : ["custom.myATMapp"],
          "detail-type" : ["transaction"],
          "detail" : {
            "result" : ["approved"]
          }
        })
    }
    
    consumer2 = {
      description = "Location New York Transactions"
      event_pattern = jsonencode(
        {
          "source" : ["custom.myATMapp"],
          "detail-type" : ["transaction"],
          "detail" : {
            "location" : [{
              "prefix" : "NY-"
            }]
          }
      })
    }

    consumer3 = {
      description = "Not Approved Transactions"
      event_pattern = jsonencode(
        {
          "source" : ["custom.myATMapp"],
          "detail-type" : ["transaction"],
          "detail" : {
            "result" : [{
              "anything-but" : "approved"
            }]
          }
      })
    }
   
  }


  targets = {
    consumer1 = [
      {
        name = "Send Approved Transaction to Lambda Consumer Case 1"
        arn  = module.lambda_consumer1_alias.lambda_alias_arn
      }
    ]

    consumer2 = [
      {
        name = "Send Approved Transaction to Lambda Consumer Case 2"
        arn  = module.lambda_consumer2_alias.lambda_alias_arn
      }
    ]
    consumer3 = [
      {
        name = "Send Not Approved Transaction to Lambda Consumer Case 3"
        arn  = module.lambda_consumer3_alias.lambda_alias_arn
      }

    ]
   
  }
}

