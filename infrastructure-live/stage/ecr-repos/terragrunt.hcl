terraform {
  source = "git::git@github.com:gruntwork-io/terraform-aws-service-catalog.git//modules/data-stores/ecr-repos?ref=v0.51.0"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  repositories = {
    node_js_getting_started = {}
  }
}