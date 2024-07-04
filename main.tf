resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "main_public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.123.1.0/24" # This is one of the subnets within 10.123.0.0/16
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1a"

  tags = {
    Name = "dev-public-sn"
  }
}

resource "aws_internet_gateway" "main_internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "dev-public-rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.main_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_internet_gateway.id
}

resource "aws_route_table_association" "main_association" {
  subnet_id      = aws_subnet.main_public_subnet.id
  route_table_id = aws_route_table.main_route_table.id
}

resource "aws_security_group" "main_security_group" {
  name        = "dev_sg"
  description = "dev security group"
  vpc_id      = aws_vpc.main_vpc.id

  tags = {
    Name = "dev_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.main_security_group.id
  cidr_ipv4         = aws_vpc.main_vpc.cidr_block
  from_port         = 0 # setting all port equal to 0 means that we accept all the ports
  to_port           = 0
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.main_security_group.id
  cidr_ipv4         = "0.0.0.0/0" # this way we are llowing whatever goes into the subnet to acces the open internet
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_key_pair" "ssh_auth" {
  key_name   = "ssh-auth-key"
  public_key = file("~/.ssh/aws_env_dev.pub")
}