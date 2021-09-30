module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"
  name            = "${var.base_name}-${var.env}"
  cidr            = "10.1.0.0/16"
  azs             = local.availability_zones
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  public_subnets  = ["10.1.11.0/24", "10.1.12.0/24", "10.1.13.0/24"]

  enable_nat_gateway = true
  tags = local.common_tags
}

module "aws_ecr" {
  source = "../../../modules/aws-ecr"
  basename = var.base_name
  env = var.env
  common_tags = local.common_tags
}

module "aws_alb" {
  source = "../../../modules/aws-alb"
  basename = var.base_name
  env = var.env
  common_tags = local.common_tags
  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
}


module "aws_ecs" {
  source  = "../../../modules/aws-ecs"
  basename = var.base_name
  env = var.env
  common_tags = local.common_tags
  azs = local.availability_zones
  private_subnets = module.vpc.private_subnets
  security_group = module.vpc.default_security_group_id
  registry = module.aws_ecr.registry
  branch = "master"
  tg_arn = module.aws_alb.tg_arn
  vpc_id = module.vpc.vpc_id
  task_port = var.task_port
  task_env = var.task_env
}
