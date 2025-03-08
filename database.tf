resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = "aurora-cluster"
  engine                 = "aurora-mysql"
  engine_version         = "8.0.mysql_aurora.3.08.1"
  database_name          = "demodatabase"
  master_username        = "admin"
  master_password        = "freemovement123"
  backup_retention_period = 7
  preferred_backup_window = "07:00-09:00"
  db_subnet_group_name    = aws_db_subnet_group.aurora_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id] # Attach RDS SG
}

resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "aurora-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count              = 2
  identifier         = "aurora-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = "db.t3.medium"
  engine            = "aurora-mysql"
}

