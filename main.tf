# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket       = "cie-terraform-state-bucket-005"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

module "vpc" {
  source                      = "./VPC"
  vpc_cidr_block              = var.vpc_cidr_block
  tags                        = local.project_tags
  availability_zones          = var.availability_zones
  public_subnet_cidr_blocks   = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks  = var.private_subnet_cidr_blocks
  database_subnet_cidr_blocks = var.database_subnet_cidr_blocks
}

module "auto-scaling" {
  source                 = "./AUTO-SCALING"
  vpc_id                 = module.vpc.vpc_id
  public_subnet_az_1a_id = module.vpc.public_subnet_az_1a_id
  public_subnet_az_1b_id = module.vpc.public_subnet_az_1b_id
  cie_webserver_tg_arn   = module.alb.cie_webserver_tg_arn
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  alb_sg_id              = module.alb.alb_sg_id
  tags                   = local.project_tags
}

module "alb" {
  source                 = "./ALB"
  vpc_id                 = module.vpc.vpc_id
  public_subnet_az_1a_id = module.vpc.public_subnet_az_1a_id
  public_subnet_az_1b_id = module.vpc.public_subnet_az_1b_id
  ssl_policy             = var.ssl_policy
  certificate_arn        = var.certificate_arn
  tags                   = local.project_tags
}

module "route-53" {
  source       = "./Route-53"
  r53_zone_id  = var.r53_zone_id
  domain_name  = var.domain_name
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

module "ec2" {
  source                 = "./EC2"
  public_subnet_az_1a_id = module.vpc.public_subnet_az_1a_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  vpc_id                 = module.vpc.vpc_id
  image_id               = var.image_id
  key_name               = var.key_name
  instance_type          = var.instance_type
  tags                   = local.project_tags
}

module "rds" {
  source                 = "./RDS"
  vpc_id                 = module.vpc.vpc_id
  database_subnet_ids    = module.vpc.database_subnet_ids
  private_ec2_sg_id      = module.ec2.private_ec2_sg_id
  secret_name            = var.secret_name
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  db_name                = var.db_name
  parameter_group_name   = var.parameter_group_name
  parameter_group_family = var.parameter_group_family
  tags                   = local.project_tags
}