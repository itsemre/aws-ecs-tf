# Create a security group to control traffic
resource "aws_security_group" "this" {
  name   = "${var.cluster_id}-security-group"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.additional_tags
}

# The cluster's subnet group
resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.cluster_id}-subnet-group"
  subnet_ids = tolist(aws_subnet.this[*].id)

  tags = var.additional_tags
}

# The replicated Redis cluster
resource "aws_elasticache_replication_group" "this" {
  replication_group_id = var.cluster_id
  description          = "Replicated Redis cluster."

  node_type = var.node_type
  port      = var.port

  automatic_failover_enabled = var.automatic_failover_enabled
  num_node_groups            = var.node_groups

  subnet_group_name  = aws_elasticache_subnet_group.this.name
  security_group_ids = [aws_security_group.this.id]

  tags = var.additional_tags
}
