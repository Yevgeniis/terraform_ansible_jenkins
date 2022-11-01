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


resource "null_resource" "apply_ansible" {
  depends_on = [aws_instance.infr_exr_ins-2,aws_volume_attachment.infr_ebs_ins_2_attach]
  provisioner "local-exec" {
        command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ec2-user --private-key ~/.ssh/${aws_key_pair.infr_exr_key.key_name}.pem -i '${aws_instance.infr_exr_ins-2.public_ip},' playbook-master.yml"   
  
  }  
}


resource "aws_ebs_volume" "infr_ebs_ins_2" {
  availability_zone = "${aws_instance.infr_exr_ins-2.availability_zone}"
  size = 1
  tags = {
    Name = "infr_ebs_ins_2"
    Terraform = true
  }
}



resource "aws_volume_attachment" "infr_ebs_ins_2_attach" {
  depends_on = [aws_ebs_volume.infr_ebs_ins_2]
  device_name = "/dev/sdc"
  volume_id = "${aws_ebs_volume.infr_ebs_ins_2.id}"
  instance_id = "${aws_instance.infr_exr_ins-2.id}"
  skip_destroy = true
}