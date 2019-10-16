module "aurora" {
  source                = "terraform-aws-modules/rds-aurora/aws"
  version               = "~> 2.0"
  name                  = "${var.project_name}-db-aurora-serverless"
  engine                = "aurora"
  engine_mode           = "serverless"
  replica_scale_enabled = false
  replica_count         = 0

  backtrack_window = 10 # ignored in serverless

  subnets                         = module.vpc.public_subnets
  vpc_id                          = module.vpc.vpc_id
  allowed_security_groups         = [aws_security_group.bastion.id, aws_security_group.webdmz.id]
  vpc_security_group_ids          = [aws_security_group.db.id]
  monitoring_interval             = 60
  instance_type                   = "db.r4.large"
  apply_immediately               = true
  skip_final_snapshot             = true
  storage_encrypted               = true
  db_parameter_group_name         = aws_db_parameter_group.aurora_db_postgres96_parameter_group.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_cluster_postgres96_parameter_group.id

  scaling_configuration = {
    auto_pause               = true
    max_capacity             = 1
    min_capacity             = 1
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
}

resource "aws_db_parameter_group" "aurora_db_postgres96_parameter_group" {
  name        = "test-aurora56-parameter-group"
  family      = "aurora5.6"
  description = "test-aurora56-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "aurora_cluster_postgres96_parameter_group" {
  name        = "test-aurora56-cluster-parameter-group"
  family      = "aurora5.6"
  description = "test-aurora56-cluster-parameter-group"
}