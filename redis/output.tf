output "hostname" {
  value = "${aws_elasticache_replication_group.redis.primary_endpoint_address}"
}

output "port" {
  value = "${aws_elasticache_replication_group.redis.port}"
}

output "endpoint" {
  value = "${join(":", aws_elasticache_replication_group.redis.primary_endpoint_address, aws_elasticache_replication_group.redis.port)}"
}