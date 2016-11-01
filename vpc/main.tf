resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"

  tags {
    Name = "${var.name}"
    Environment    = "${upper(var.env)}"
    CostCenter     = "${var.vpc_tag_costcenter}"
    ProjectName    = "${var.vpc_tag_projectname}"
    LineOfBusiness = "${var.vpc_tag_lineofbusiness}"
  }
}

############
## DHCP
############

resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name = "${var.domain}"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags {
    Name = "${var.domain}"
    Owner = "${var.owner}"
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id ="${aws_vpc.vpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dns_resolver.id}"
}
#############
## DNS
#############

resource "aws_route53_zone" "zone" {
  name   = "${var.domain}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name    = "${var.domain}-zone"
    owner   = "${var.owner}"
  }
}

########################################################################
## Routing
## Add an NAT gateway for allowaccess to internet from private instances
########################################################################

resource "aws_eip" "nat" {
  vpc   = true
}

resource "aws_nat_gateway" "gw" {
    allocation_id = "${aws_eip.nat.id}"
    subnet_id = "${element(aws_subnet.public.*.id,0)}"

}

resource "aws_route_table" "private_routing" {
    vpc_id = "${aws_vpc.vpc.id}"

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_nat_gateway.gw.id}"
    }

    tags {
      Name = "${var.name}-routing"
      Owner = "${var.owner}"
    }
}
#################
## VPC peering ##
#################

resource "aws_vpc_peering_connection" "peer_vpc" {
    peer_owner_id = "${var.peer_owner_id}"
    peer_vpc_id = "${var.peer_vpc_id}"
    vpc_id = "${aws_vpc.vpc.id}"
    auto_accept = true

    tags {
      Name = "VPC Peering between ${var.peer_vpc_id} and ${aws_vpc.vpc.id}"
    }
}

resource "aws_internet_gateway" "vpc" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_vpn_gateway" "vpn_gateway" {
    vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_customer_gateway" "customer_gateway" {
    bgp_asn = 65000
    ip_address = "172.0.0.2"
    type = "ipsec.1"
}

resource "aws_vpn_connection" "main" {
    vpn_gateway_id = "${aws_vpn_gateway.vpn_gateway.id}"
    customer_gateway_id = "${aws_customer_gateway.customer_gateway.id}"
    type = "ipsec.1"
    static_routes_only = false
}

resource "aws_route_table" "public" {
  vpc_id           = "${aws_vpc.vpc.id}"
  propagating_vgws = ["${var.public_propagating_vgws}"]

  tags {
    Name = "${var.name}-public"
    Environment    = "${upper(var.env)}"
    CostCenter     = "${var.vpc_tag_costcenter}"
    ProjectName    = "${var.vpc_tag_projectname}"
    LineOfBusiness = "${var.vpc_tag_lineofbusiness}"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.vpc.id}"
}

resource "aws_route_table" "private" {
  vpc_id           = "${aws_vpc.vpc.id}"
  propagating_vgws = ["${var.private_propagating_vgws}"]
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_nat_gateway.gw.id}"
    }
  route {
     cidr_block = "${var.peer_vpc_cidr}"
     gateway_id = "${aws_vpc_peering_connection.peer_vpc.id}"
    }
  tags {
    Name = "${var.name}-private"
    Environment    = "${upper(var.env)}"
    CostCenter     = "${var.vpc_tag_costcenter}"
    ProjectName    = "${var.vpc_tag_projectname}"
    LineOfBusiness = "${var.vpc_tag_lineofbusiness}"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${element(var.private_subnets, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"
  count             = "${length(var.private_subnets)}"

  tags {
    Name = "${var.name}-private"
    Environment    = "${upper(var.env)}"
    CostCenter     = "${var.vpc_tag_costcenter}"
    ProjectName    = "${var.vpc_tag_projectname}"
    LineOfBusiness = "${var.vpc_tag_lineofbusiness}"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${element(var.public_subnets, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"
  count             = "${length(var.public_subnets)}"

  tags {
    Name = "${var.name}-public"
    Environment    = "${upper(var.env)}"
    CostCenter     = "${var.vpc_tag_costcenter}"
    ProjectName    = "${var.vpc_tag_projectname}"
    LineOfBusiness = "${var.vpc_tag_lineofbusiness}"
  }

  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnets)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}