


resource "aws_internet_gateway" "igw" {}

resource "aws_vpc" "infr_exr" {
  cidr_block = "192.168.0.0/16"

  tags = {
    "Name"      = "infra_project"
    "Terraform" = "true"
  }
}

resource "aws_internet_gateway_attachment" "infr_igw_attach" {
  internet_gateway_id = aws_internet_gateway.igw.id
  vpc_id              = aws_vpc.infr_exr.id
}

resource "aws_subnet" "infr_exr" {
  vpc_id            = aws_vpc.infr_exr.id
  cidr_block        = "192.168.10.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    "Name"      = "infr_public-1"
    "Terraform" = "true"
  }

}


resource "aws_route_table" "infr_exr" {

  vpc_id = aws_vpc.infr_exr.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name      = "public_rtb_infr"
    Terraform = "true"
  }
}

resource "aws_route_table_association" "infr_exr" {
  subnet_id      = aws_subnet.infr_exr.id
  route_table_id = aws_route_table.infr_exr.id
}