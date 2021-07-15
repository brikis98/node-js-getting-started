# ----------------------------------------------------------------------------------------------------------------
# WORKAROUND TO USE THE DEFAULT VPC AND SUBNETS
# The Service Catalog doesn't provide an easy way to use the default VPC and subnets for Terragrunt users, so this
# is an ugly workaround to fetch that data and expose it as a Terragrunt module that you can use in a dependency
# block.
# ----------------------------------------------------------------------------------------------------------------

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "public_subnet_ids" {
  value = data.aws_subnet_ids.default.ids
}



# ----------------------------------------------------------------------------------------------------------------
# WORKAROUND TO CREATE A SECURITY GROUP
# To run an ECS Fargate Service, you must create a Security Group to control the traffic in and out of that service.
# Unfortunately, our ecs-service module in the Service Catalog doesn't support doing this, and there's no way to do
# it in pure Terragrunt code and at the same time, output the Security Group ID that must be passed into the 
# network_configuration input param of ecs-service. Therefore, as a REALLY ugly / unmaintainable hack, we create the
# SG here and output its ID so it can be used when deploying the service.
# ----------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "fargate_sg" {
  name        = "node-js-getting-started"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "loadbalancer_to_service" {
  type              = "ingress"
  from_port         = 5000
  to_port           = 5000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.fargate_sg.id
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.fargate_sg.id
}

output "fargate_sg_id" {
  value = aws_security_group.fargate_sg.id
}