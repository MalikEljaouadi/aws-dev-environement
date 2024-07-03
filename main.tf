resource "aws_vpc" "main-vpc" {
  cidr_block           = "10.123.0.0/18"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "dev"
  }
}