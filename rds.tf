resource "aws_db_subnet_group" "mariadb-subnet" {
  name        = "mariadb-subnet"
  description = "RDS subnet group"
  subnet_ids  = [aws_subnet.secondary.id, aws_subnet.private.id]
}

resource "aws_db_parameter_group" "mariadb-parameters" {
  name        = "mariadb-parameters"
  family      = "mariadb10.2"
  description = "MariaDB parameter group"

  parameter {
    name  = "max_allowed_packet"
    value = "16777216"
  }
}

resource "aws_db_instance" "mariadb" {
  allocated_storage       = 100 # 100 GB of storage, gives us more IOPS than a lower number
  max_allocated_storage   = 200
  engine                  = "mariadb"
  engine_version          = "10.2.21"
  instance_class          = "db.t2.small" # use micro if you want to use the free tier
  identifier              = "mariadb"
  name                    = "mariadb"
  username                = var.RDS_USERNAME # username
  password                = var.RDS_PASSWORD # password
  port                    = 3306
  db_subnet_group_name    = aws_db_subnet_group.mariadb-subnet.name
  parameter_group_name    = aws_db_parameter_group.mariadb-parameters.name
  multi_az                = "false" # set to true to have high availability: 2 instances synchronized with each other
  vpc_security_group_ids  = [aws_security_group.allow-mariadb.id]
  storage_type            = "gp2"
  backup_retention_period = 30                                     # how long you’re going to keep your backups
  availability_zone       = aws_subnet.secondary.availability_zone # prefered AZ
  skip_final_snapshot     = true                                   # skip final snapshot when doing terraform destroy
  tags = {
    Name = "mariadb-instance"
  }
}
