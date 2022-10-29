resource "aws_security_group" "allow_basic_ports" {
  name        = "allow_basic_ports"
  description = "Allow Basic ports 22_443_80"
  vpc_id      = aws_vpc.infr_exr.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"      = "infr_sg"
    "Terraform" = "true"
  }
}