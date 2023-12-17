# tomap & merge to add kv to map
resource "aws_vpc" "vpc" {
  cidr_block         = "10.0.0.0/16"
  enable_dns_support = true
  tags               = tomap(merge({ Name = "VPC-${var.env}-env" }, var.tags))
}

# for_each on kv map
resource "aws_subnet" "public_subnets" {
  for_each          = var.public_subnets
  availability_zone = each.key
  cidr_block        = each.value
  vpc_id            = aws_vpc.vpc.id
  tags              = tomap(merge({ Name = "Public-subnet-${each.key}-${var.env}-env" }, { "kubernetes.io/role/elb" = "1" }, var.tags))
}

resource "aws_subnet" "private_subnets" {
  for_each          = var.private_subnets
  availability_zone = each.key
  cidr_block        = each.value
  vpc_id            = aws_vpc.vpc.id
  tags              = tomap(merge({ Name = "Private-subnet-${each.key}-${var.env}-env" }, { "kubernetes.io/role/internal-elb" = "1" }, { "kubernetes.io/cluster/${var.cluster_name}" = "shared" }, { "karpenter.sh/discovery" = "${var.cluster_name}" }, var.tags))
}

# Export subnets IDs as array to reference it going forward
locals {
  private_subnets_ids = [for subnet in aws_subnet.private_subnets : subnet.id]
  public_subnets_ids  = [for subnet in aws_subnet.public_subnets : subnet.id]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = tomap(merge({ Name = "IGW-${var.env}-env" }, var.tags))
}

# depends_on
resource "aws_eip" "nat_ip" {
  domain = "vpc"
  tags   = tomap(merge({ Name = "NAT-IP-${var.env}-env" }, var.tags))
  depends_on = [
    aws_internet_gateway.igw
  ]
}

# Reference subnet ID created by for_each
resource "aws_nat_gateway" "nat" {
  allocation_id     = aws_eip.nat_ip.allocation_id
  connectivity_type = "public"
  subnet_id         = local.public_subnets_ids[0]
  tags              = tomap(merge({ Name = "NAT-${var.env}-env" }, var.tags))
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = tomap(merge({ Name = "Public-route-${var.env}-env" }, var.tags))
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = tomap(merge({ Name = "Private-route-${var.env}-env" }, var.tags))
}

# Pass for_each from subnets to route table associations
resource "aws_route_table_association" "public_routes_to_subnets" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_routes_to_subnets" {
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route_table.id
}
