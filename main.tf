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
    Name = "dev-public"
  }
}

resource "aws_internet_gateway" "main_internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "dev-igw"
  }
}