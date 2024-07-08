variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "eu-west-2"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "ec2_ami" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "ec2_instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "rds_db_name" {
  description = "Database name for RDS"
  type        = string
  default     = "recognitiondb"
}

variable "rds_username" {
  description = "Username for RDS"
  type        = string
}

variable "rds_password" {
  description = "Password for RDS"
  type        = string
}

variable "rds_instance_class" {
  description = "Instance class for RDS"
  type        = string
  default     = "db.t2.micro"
}

variable "rds_allocated_storage" {
  description = "Allocated storage for RDS in GB"
  type        = number
  default     = 20
}

variable "rds_engine" {
  description = "Database engine for RDS"
  type        = string
  default     = "mysql"
}

variable "rds_engine_version" {
  description = "Database engine version for RDS"
  type        = string
  default     = "8.0"
}
