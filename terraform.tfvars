region = "us-west-2"

vpc_cidr_block = "10.0.0.0/16"

ec2_ami           = "ami-05d929ac8893c382f"
ec2_instance_type = "t2.micro"

rds_db_name           = "recognitiondb"
rds_username          = "admin"
rds_password          = "password"
rds_instance_class    = "db.t2.micro"
rds_allocated_storage = 20
rds_engine            = "mysql"
rds_engine_version    = "8.0"
