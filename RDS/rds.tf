# Create a DB subnet group for the RDS instance
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = var.database_subnet_ids

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-db-subnet-group"
  })
}


#Create a security group for the RDS instance
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow traffic for MySQL Database"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-rds-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "allow_mysql_from_private_ec2" {
  security_group_id            = aws_security_group.rds_sg.id
  referenced_security_group_id = var.private_ec2_sg_id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


# Create the RDS Database
data "aws_secretsmanager_secret" "db_credentials" {
  name = var.secret_name # Replace with your secret name
}

data "aws_secretsmanager_secret_version" "by-secret-id" {
  secret_id = data.aws_secretsmanager_secret.db_credentials.id
}


resource "aws_db_parameter_group" "custom_parameter_group" {
  name   = var.parameter_group_name
  family = var.parameter_group_family

  parameter {
    name  = "require_secure_transport"
    value = "ON"
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-custom-parameter-group"
  })

}


resource "aws_db_instance" "mysql_db" {
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  parameter_group_name   = aws_db_parameter_group.custom_parameter_group.name
  db_name                = var.db_name
  identifier             = "cie-ananse-dev-mysql-db"
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  username = jsondecode(data.aws_secretsmanager_secret_version.by-secret-id.secret_string)["mysql_username"] # Replace with your secret key for username
  password = jsondecode(data.aws_secretsmanager_secret_version.by-secret-id.secret_string)["mysql_password"] # Replace with your secret key for password

  #   username             = var.db_username  
  #   manage_master_user_password = true

  multi_az            = true
  publicly_accessible = false
  skip_final_snapshot = true
  storage_type        = "gp2"
  storage_encrypted   = true
  deletion_protection = false

  # backup_retention_period = 7
  #   backup_window          = "03:00-04:00"
  #   maintenance_window     = "Mon:04:00-Mon:05:00"
}


