# Create a VPC to launch our instances into
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = merge({
    Name = var.cluster_id
  }, var.additional_tags)
}

# Create an internet gateway to enable our resources to connect to the internet
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge({
    Name = var.cluster_id
  }, var.additional_tags)
}

# Grant the VPC internet access on its main route table
resource "aws_route" "this" {
  route_table_id         = aws_vpc.this.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# Grab the list of availability zones
data "aws_availability_zones" "this" {}

# Create a subnet to launch our instances into
resource "aws_subnet" "this" {
  count                   = length(var.cidr_blocks)
  vpc_id                  = aws_vpc.this.id
  availability_zone       = data.aws_availability_zones.this.names[count.index]
  cidr_block              = var.cidr_blocks[count.index]
  map_public_ip_on_launch = true

  tags = merge({
    Name = var.cluster_id
  }, var.additional_tags)
}