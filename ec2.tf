

resource "aws_instance" "infr_exr_ins-1" {

  ami           = "ami-0d593311db5abb72b"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.infr_exr.id
  key_name      = "vockey"
  tags = {
    Terraform = "true"
    Name      = "infr_Instance-1"
  }

}

resource "aws_instance" "infr_exr_ins-2" {

  ami           = "ami-0d593311db5abb72b"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.infr_exr.id
  key_name      = "vockey"
  tags = {
    Terraform = "true"
    Name      = "infr_Instance-2"
  }

}