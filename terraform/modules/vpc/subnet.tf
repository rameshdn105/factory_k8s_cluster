resource "aws_subnet" "public_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pubcidr1

  tags = {
    Name = "Public-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pubcidr2

  tags = {
    Name = "Public-2"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pricidr1

  tags = {
    Name = "Private-1"
  }
}
resource "aws_subnet" "private_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pricidr2

  tags = {
    Name = "Private-2"
  }
}
