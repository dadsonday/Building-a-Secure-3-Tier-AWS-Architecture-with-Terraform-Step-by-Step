# Database subnet group for private subnets 2 & 3
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.project_name}_rds_subnet_group"
  subnet_ids = [aws_subnet.private_2.id, aws_subnet.private_3.id]

  tags = {
    Name = "${var.project_name}_RDS_Subnet_Group"
  }
}

# RDS MariaDB Instance (free tier class, single AZ for simplicity)
resource "aws_db_instance" "mariadb" {
  identifier             = lower("${var.project_name}-mariadb")
  allocated_storage      = var.rds_allocated_storage
  engine                 = "mariadb"
  engine_version         = "10.5"
  instance_class         = "db.t3.micro"
  username               = var.rds_username
  password               = var.rds_password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  multi_az               = false
  publicly_accessible    = false
  skip_final_snapshot    = true

  tags = {
    Name = "${var.project_name}_MariaDB_Instance"
  }
  # Disabled backups for speed in demo environment (not recommended for production)
  backup_retention_period = 0
  deletion_protection     = false
}