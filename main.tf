module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"

  name = "my-vpc"
  cidr = var.vpc_cidr_block

  azs             = ["eu-west-2a", "eu-west-2b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.0.0"

  name        = "allow-ssh-http"
  description = "Security group with HTTP and SSH"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.0.0"

  name           = "web-server"
  instance_count = 1

  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [module.security_group.this_security_group_id]
  subnet_id              = element(module.vpc.public_subnets, 0)

  user_data = file("user_data.sh")

  tags = {
    Name = "web-server"
  }
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.0.0"

  name               = "app-lb"
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [module.security_group.this_security_group_id]

  http_tcp_listeners = [
    {
      port              = 80
      protocol          = "HTTP"
      target_group_name = "app-tg"
      target_type       = "instance"
      target_port       = 80
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.0.0"

  identifier     = "recognition-db"
  engine         = var.rds_engine
  engine_version = var.rds_engine_version
  instance_class = var.rds_instance_class

  allocated_storage      = var.rds_allocated_storage
  storage_encrypted      = true
  username               = var.rds_username
  password               = var.rds_password
  db_name                = var.rds_db_name
  publicly_accessible    = true
  vpc_security_group_ids = [module.security_group.this_security_group_id]
  subnet_ids             = module.vpc.private_subnets

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

output "alb_dns_name" {
  value = module.alb.this_alb_dns_name
}

output "rds_endpoint" {
  value = module.rds.this_db_instance_address
}
