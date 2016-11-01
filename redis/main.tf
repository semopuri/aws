#
# ElastiCache resources
#

resource "aws_elasticache_subnet_group" "subnet" {
  name        = "${var.redis_subnet_name}"
  description = "Private subnets for the ElastiCache instances"
  subnet_ids  = ["${var.redis_private_subnet_ids}"]
}

resource "aws_elasticache_parameter_group" "group_redis" {
    name = "${var.redis_parameter_group_name}"
    family = "redis2.8"
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id = "${var.redis_cluster_id}"
  replication_group_description = "${var.redis_cluster_id} cluster group redis"
  engine = "redis"
  engine_version = "${var.redis_engine_version}"
  maintenance_window = "${var.maintenance_window}"
  snapshot_window = "${var.redis_snapshot_window}"
  snapshot_retention_limit = "${var.redis_snapshot_retention_limit}"
  parameter_group_name = "${aws_elasticache_parameter_group.group_redis.name}"
  node_type = "${var.redis_instance_type}"
  number_cache_clusters = "${var.redis_num_cache_nodes}"
  parameter_group_name = "default.redis2.8"
  port = "${var.redis_port}"
  security_group_ids = ["${var.redis_security_group_ids}"]
  availability_zones = ["${var.redis_azs}"]
  subnet_group_name  = "${aws_elasticache_subnet_group.subnet.name}"

  tags {
    Name = "${var.redis_cluster_id}"
    Environment = "${upper(var.env)}"
    CostCenter = "${var.redis_tag_costcenter}"
    ProjectName = "${var.redis_tag_projectname}"
    LineOfBusiness = "${var.redis_tag_lineofbusiness}"
  } 
}