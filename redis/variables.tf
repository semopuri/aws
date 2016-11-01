variable "env" {}

variable "redis_cluster_id" {}

variable "redis_engine_version" {
  default = "2.8.24"
}

variable "redis_num_cache_nodes" {
	default = "1"
}

variable "redis_port" {
	default = "6379"
}

variable "redis_instance_type" {
  default = "cache.m3.medium"
}

variable "maintenance_window" {
  # SUN 05:00AM-06:00AM ET
  default = "sun:05:00-sun:06:00"
}

variable "redis_security_group_ids" {
  default = []
}

variable "redis_azs" {
  description = "A list of Availability zones in the region"
  default     = []
}

variable "redis_subnet_name" {}

variable "redis_private_subnet_ids" {
  description = "A list of private subnet id"
  default     = []
}

variable "redis_snapshot_retention_limit" {
	default = 1
}

variable "redis_snapshot_window" {
	default = "20:00-21:00"
}

variable "redis_parameter_group_name" {}

#############################
#    Tags Configuration
#############################

variable "redis_tag_costcenter" {
  default = "03742"
}
variable "redis_tag_projectname" {
  default = "paas"
}

variable "redis_tag_lineofbusiness" {
  default = "N/A"
}