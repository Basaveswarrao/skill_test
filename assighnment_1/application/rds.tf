resource "aws_db_instance" "db" {
  allocated_storage        = 10 # gigabytes
  backup_retention_period  = 7   # in days
  db_subnet_group_name     = data.terraform_remote_state.backend_network.outputs.db_subnet_group
  engine                   = "postgres"
  engine_version           = "9.5.4"
  identifier               = "db"
  instance_class           = "t2.medium"
  multi_az                 = false
  name                     = "db"
  parameter_group_name     = "dbparamgroup" # if you have tuned it
  password                 = "hh28281ih@8342139"
  port                     = 5432
  publicly_accessible      = true
  storage_encrypted        = true # you should always do this
  storage_type             = "gp2"
  username                 = "db"
  vpc_security_group_ids   = [data.aws_security_group.cluster.id]
}