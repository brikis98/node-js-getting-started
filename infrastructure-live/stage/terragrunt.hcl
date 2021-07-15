locals {
  aws_region = "eu-west-1"
  account_id = "087285199408"
}

# ----------------------------------------------------------------------------------------------------------------
# GENERATED PROVIDER BLOCK
# ----------------------------------------------------------------------------------------------------------------

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"

  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${local.account_id}"]
}
EOF
}

# ----------------------------------------------------------------------------------------------------------------
# GENERATED REMOTE STATE BLOCK
# TODO: for simplicity, I'm just using local Terraform state.
# ----------------------------------------------------------------------------------------------------------------

# remote_state {
#   backend = "s3"
#   config = {
#     encrypt        = true
#     bucket         = "${local.name_prefix}-${local.account_name}-${local.aws_region}-tf-state"
#     key            = "${path_relative_to_include()}/terraform.tfstate"
#     region         = local.aws_region
#     dynamodb_table = "terraform-locks"
#   }
#   generate = {
#     path      = "backend.tf"
#     if_exists = "overwrite_terragrunt"
#   }
# }