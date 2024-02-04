# Output a file with variable for testing scripts

# Output a set of variables used by your scripts
resource "local_file" "output_variables" {
  content  = local.variables
  filename = "${path.module}/scripts/variables.zsh"
}

locals {
  variables = <<-EOT
    #!/bin/zsh
    ##
    ## variables for the ZSH shell scripts
    ##
    REGION=${var.region}
    LAMBDA=${module.lambda_producer.lambda_function_name}
    APPROVED_TRANSACTION_TABLE=${aws_dynamodb_table.approved_transaction_table.name}
    NY_TRANSACTION_TABLE=${aws_dynamodb_table.newyork_transaction_table.name}
    FAILED_TRANSACTION_TABLE=${aws_dynamodb_table.failed_transaction_table.name}

  EOT

}

