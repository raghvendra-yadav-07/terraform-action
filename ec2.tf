# Key Pair
resource "aws_key_pair" "key" {
  key_name   = "terraformkey"
  public_key = file("terraformkey.pub")
}

# Default VPC
resource "aws_default_vpc" "newvpc" {
}

# Security Group
resource "aws_security_group" "practice" {
  name        = "front-demo"
  description = "This is to practice"
  vpc_id      = aws_default_vpc.newvpc.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_ip
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2
resource "aws_instance" "aws_new" {
  for_each = tomap({
    instance_1 = "t2.micro"
    instance_2 = "t2.medium"
  }) #meta argument
  depends_on             = [aws_default_vpc.newvpc, aws_security_group.practice]
  key_name               = aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.practice.id]

  instance_type = each.value
  ami           = "ami-07574623ba26e48f8"

  root_block_device {
    volume_size = var.env == "production" ? 20 : var.storage_default
    volume_type = "gp3"
  }

  tags = {
    Name = each.value
  }
}
