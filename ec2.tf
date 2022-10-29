//Creating private key
resource "tls_private_key" "infr_exr_tls" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "infr_exr_key" {
  
  key_name = "infr_exr_key"
  public_key = tls_private_key.infr_exr_tls.public_key_openssh
  
  provisioner "local-exec" {
    command = "echo '${tls_private_key.infr_exr_tls.private_key_pem}' > ~/.ssh/${aws_key_pair.infr_exr_key.key_name}.pem ; chmod 400 ~/.ssh/${aws_key_pair.infr_exr_key.key_name}.pem"
  }
}


resource "aws_instance" "infr_exr_ins-1" {

  ami           = "ami-0d593311db5abb72b"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.infr_exr.id
  vpc_security_group_ids = [aws_security_group.allow_basic_ports.id]
  key_name      = aws_key_pair.infr_exr_key.key_name
  tags = {
    Terraform = "true"
    Name      = "infr_Instance-1"
  }

}

resource "aws_instance" "infr_exr_ins-2" {

  ami           = "ami-0d593311db5abb72b"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.infr_exr.id
  vpc_security_group_ids = [aws_security_group.allow_basic_ports.id]
  key_name      = aws_key_pair.infr_exr_key.key_name
  tags = {
    Terraform = "true"
    Name      = "infr_Instance-2"
  }

}