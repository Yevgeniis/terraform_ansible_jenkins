//Creating private key
resource "tls_private_key" "infr_exr_tls" {
  algorithm = "RSA"
  rsa_bits = 4096
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"
  key_name = "infr_exr_key"
  public_key = tls_private_key.infr_exr_tls.public_key_openssh
}


resource "aws_instance" "infr_exr_ins-1" {

  ami           = "ami-0d593311db5abb72b"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.infr_exr.id
  key_name      = "infr_exr_key"
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