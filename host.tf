# Get the list of official Canonical Ubuntu AMIs
data "aws_ami" "this" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # canonical
}

# Load the startup script
data "template_file" "this" {
  template = file("${path.module}/scripts/startup.sh.tpl")
}

# Public/private key pair for the host
resource "aws_key_pair" "this" {
  key_name   = "${var.cluster_id}-keys"
  public_key = file(var.public_key_path)
  tags = var.additional_tags
}

# An EC2 instance acting as a bastion host
resource "aws_instance" "this" {
  ami           = coalesce(var.ami_override, data.aws_ami.this.id)
  instance_type = var.instance_type
  key_name      = aws_key_pair.this.id

  subnet_id              = aws_subnet.this[0].id
  vpc_security_group_ids = [aws_security_group.this.id]
  user_data              = data.template_file.this.rendered

  monitoring = var.monitoring_enabled

  tags = merge({
    Name = "${var.cluster_id}-ssh-host"
  }, var.additional_tags)
}
