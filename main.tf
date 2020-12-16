provider "aws" {
  region  = "ap-south-1"
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.name}-VPC"
   }
}

resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_cidr)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.public_subnet_cidr,count.index)
  availability_zone = element(var.az,count.index)

  tags = {
    Name = "APP_Subnet-${count.index+1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count = length(var.db_subnet_cidr)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.db_subnet_cidr,count.index)

  tags = {
    Name = "DB_Subnet-${count.index+1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_route_table" "app-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "App-RT"
  }
}

resource "aws_route_table_association" "app-rt" {
  count = length(var.public_subnet_cidr)
  subnet_id = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.app-rt.id
}

resource "aws_eip" "eip" {
  vpc=true
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public_subnets[0].id
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.name}-Nat-gw"
  }
}
resource "aws_route_table" "db-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "DB-RT"
  }
}
resource "aws_route_table_association" "db-rt" {
  count = length(var.db_subnet_cidr)
  subnet_id = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.db-rt.id
}

/*resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "allow_http"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}
///Ecs-code-begins
*/