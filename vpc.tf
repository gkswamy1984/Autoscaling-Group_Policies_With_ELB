resource "aws_vpc" "default" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = "true"
  enable_classiclink   = "false"

  tags = {
    Name = "esafe-vpc"
  }
}

resource "aws_subnet" "public-subnet1" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${var.public_subnet1_cidr}"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "esafe-Subnet1"
  }
}

resource "aws_subnet" "public-subnet2" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${var.public_subnet2_cidr}"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "esafe-Subnet2"
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name = "esafe-VPC IGW"
  }
}

# Define the route table
resource "aws_route_table" "web-public-rt" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name = "esafe-Subnet's RT"
  }
}

# Assign the route table to the public Subnet1
resource "aws_route_table_association" "web-public1-rt" {
  subnet_id      = "${aws_subnet.public-subnet1.id}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}
# Assign the route table to the public Subnet2
resource "aws_route_table_association" "web-public2-rt" {
  subnet_id      = "${aws_subnet.public-subnet2.id}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}
