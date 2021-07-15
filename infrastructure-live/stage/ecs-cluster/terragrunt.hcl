terraform {
  source = "git::git@github.com:gruntwork-io/terraform-aws-service-catalog.git//modules/services/ecs-fargate-cluster?ref=v0.51.0"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  cluster_name = "node_js_getting_started"
}