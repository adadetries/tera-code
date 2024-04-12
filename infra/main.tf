terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.16"
    }
  }
}

provider "aws" {
    region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "vpc_infrastructure" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vividart_vpc"
  }
}

provider "aws" {
  region = "us-east-1"
}

# Create the first Subnet
resource "aws_subnet" "infra_public_subnet" {
  vpc_id = aws_vpc.vpc_infrastructure.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "vividart_subnet1"
  }
}

# Create the second subnet
resource "aws_subnet" "infra_public_subnet2" {
  vpc_id = aws_vpc.vpc_infrastructure.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "vividart_subnet2"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_infrastructure.id
}

# Create a route table
resource "aws_route_table" "custom_route_table" {
  vpc_id = aws_vpc.vpc_infrastructure.id

  # Define the routes
  route = {
    cidr_block = "0.0.0.0/0"
    gatteway_id = aws_internet_gateway.igw.id

    tags = {
        Name = "CustomRouteTable"
    }
  }
}

# Associating the route table to the first subnet
resource "aws_route_table_association" "subnet1_ass" {
  route_table_id = aws_route_table.custom_route_table.id
  subnet_id = aws_subnet.infra_public_subnet.id
}

# Associating the route table to the second subnet
resource "aws_route_table_association" "subnet2_ass" {
  route_table_id = aws_route_table.custom_route_table.id
  subnet_id = aws_subnet.infra_public_subnet.id
}