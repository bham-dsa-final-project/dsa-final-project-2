output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "The IDs of the public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "The IDs of the private subnets"
  value       = module.vpc.private_subnets
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = module.security_group.this_security_group_id
}

output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2.instance_ids
}

output "ec2_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = module.ec2.public_ips
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.alb.this_alb_dns_name
}

output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = module.rds.this_db_instance_address
}

output "rds_instance_id" {
  description = "The ID of the RDS instance"
  value       = module.rds.this_db_instance_id
}
