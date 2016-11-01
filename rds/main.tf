resource "aws_db_parameter_group" "paas-mysql-parameters" {
  name = "${lower(var.env)}-paas-mysql-parameters"
  family = "mysql5.6"
}
resource "aws_db_instance" "main_rds_instance" {
    identifier = "${var.rds_instance_name}"
    allocated_storage = "${var.rds_allocated_storage}"
    engine = "${var.rds_engine_type}"
    engine_version = "${var.rds_engine_version}"
    instance_class = "${var.rds_instance_class}"
    name = "${var.rds_database_name}"
    username = "${var.rds_database_user}"
    password = "${var.rds_database_password}"
    // Because we're assuming a VPC, we use this option, but only one SG id
    vpc_security_group_ids = ["${var.rds_security_group_id}"]
    // We're creating a subnet group in the module and passing in the name
    db_subnet_group_name = "${aws_db_subnet_group.main_db_subnet_group.name}"
    parameter_group_name = "${aws_db_parameter_group.paas-mysql-parameters.name}"
    // We want the multi-az setting to be toggleable, but off by default
    multi_az = "${var.rds_is_multi_az}"
    storage_type = "${var.rds_storage_type}"
    backup_retention_period = "${var.rds_backup_retention_period}"
    maintenance_window = "${var.rds_maintenance_window}"
    backup_window = "${var.rds_backup_window}"
}

resource "aws_db_subnet_group" "main_db_subnet_group" {
    name = "${var.rds_instance_name}-subnetgroup"
    description = "RDS subnet group"
    subnet_ids = ["${var.rds_subnets}"]
}