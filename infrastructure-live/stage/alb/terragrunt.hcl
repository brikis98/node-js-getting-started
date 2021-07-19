terraform {
  source = "git::git@github.com:gruntwork-io/terraform-aws-service-catalog.git//modules/networking/alb?ref=v0.51.0"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../vpc"
}

inputs = {
  alb_name                              = "node-js-getting-started"
  is_internal_alb                       = false
  vpc_id                                = dependency.vpc.outputs.vpc_id
  vpc_subnet_ids                        = dependency.vpc.outputs.public_subnet_ids
  num_days_after_which_archive_log_data = 10
  num_days_after_which_delete_log_data  = 20
  http_listener_ports                   = ["80"]
  allow_inbound_from_cidr_blocks        = ["0.0.0.0/0"]

  # Not something you should use in prod, but handy for testing / experimenting.
  force_destroy = true
}