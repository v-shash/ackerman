
resource "random_pet" "this" {
  length = 2
}

module "dynamodb_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name           = "UrlTable-MoHusseini"
  hash_key       = "shortenUrl"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5

  autoscaling_read = {
    scale_in_cooldown  = 50
    scale_out_cooldown = 40
    target_value       = 55
    max_capacity       = 20
  }

  autoscaling_write = {
    scale_in_cooldown  = 50
    scale_out_cooldown = 40
    target_value       = 45
    max_capacity       = 10
  }

  attributes = [
    {
      name = "shortenUrl"
      type = "S"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}
