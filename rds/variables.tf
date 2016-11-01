
variable "env"{}
variable "rds_instance_name"{}
variable "rds_instance_class" {}
variable "rds_database_name" {
    description = "The name of the database to create"
}

variable "rds_database_user" {}
variable "rds_database_password" {}
variable "rds_is_multi_az" {
    default = "false"
}

variable "rds_storage_type" {
    default = "standard"
}

variable "rds_allocated_storage" {
    description = "The allocated storage in GBs"
    // You just give it the number, e.g. 10
}
variable "rds_engine_type" {
    // Valid types are
    // - mysql
    // - postgres
    // - oracle-*
    // - sqlserver-*
    // See http://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html
    // --engine
}

variable "rds_engine_version" {
    // For valid engine versions, see:
    // See http://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html
    // --engine-version

}
variable "rds_security_group_id" {
  default = []
}

// RDS Subnet Group Variables
variable "rds_subnets" {
  description = "RDS Subnet Group Variables"
  default     = []
}

variable "rds_backup_retention_period" {}

variable "rds_maintenance_window" {}

variable "rds_backup_window" {}
