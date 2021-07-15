terraform {
  source = "git::git@github.com:gruntwork-io/terraform-aws-service-catalog.git//modules/services/ecs-service?ref=v0.51.0"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../vpc"
}

dependency "alb" {
  config_path = "${get_terragrunt_dir()}/../alb"
}

dependency "ecr_repos" {
  config_path = "${get_terragrunt_dir()}/../ecr-repos"
}

dependency "ecs_cluster" {
  config_path = "${get_terragrunt_dir()}/../ecs-cluster"
}

locals {
  container_name      = "node_js_getting_started"
  container_port      = 5000
}

inputs = {
  service_name          = "node-js-getting-started"
  ecs_cluster_arn       = dependency.ecs_cluster.outputs.arn 
  ecs_cluster_name      = "node_js_getting_started" # TODO: this should be an output var: https://github.com/gruntwork-io/terraform-aws-service-catalog/issues/808
  launch_type           = "FARGATE"
  network_mode          = "awsvpc"
  
  task_cpu                = 256
  task_memory             = 512
  desired_number_of_tasks = 1

  # TODO: add support for default VPC in service catalog: https://github.com/gruntwork-io/terraform-aws-service-catalog/issues/809
  network_configuration = {
    subnets          = dependency.vpc.outputs.public_subnet_ids 
    security_groups  = [dependency.vpc.outputs.fargate_sg_id] # TODO: no way to create SGs!!! So this is a VERY ugly hack. https://github.com/gruntwork-io/terraform-aws-service-catalog/issues/810
    assign_public_ip = true
  }

  container_definitions = [
    {
      name         = local.container_name
      image        = "${dependency.ecr_repos.outputs.ecr_repo_urls[local.container_name]}:v1"
      essential    = true
      portMappings = [
        {
          "hostPort"      = local.container_port
          "containerPort" = local.container_port
          "protocol"      = "tcp"
        }
      ]      
    }
  ]

  elb_target_groups = {
    alb = {
      name                  = "node-js-getting-started"
      container_name        = local.container_name
      container_port        = local.container_port
      protocol              = "HTTP"
      health_check_protocol = "HTTP"
    }
  }

  elb_target_group_vpc_id = dependency.vpc.outputs.vpc_id

  default_listener_arns  = dependency.alb.outputs.listener_arns
  default_listener_ports = keys(dependency.alb.outputs.listener_arns)

  forward_rules = {
    "all" = {
      priority      = 100
      port          = local.container_port
      path_patterns = ["/*"]
    }
  }  
}