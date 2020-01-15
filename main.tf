#This Terraform Code Deploys Basic VPC Infra.
provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}

resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags = {
        Name = "${var.vpc_name}"
    }
}

locals {
     name = "${var.aws_region}-${var.vpc_name}"
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
	tags = {
        Name = "${var.IGW_name}"
    }
}

resource "aws_subnet" "subnets" {
    count = "${length(var.cidrs)}"
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "${element(var.cidrs, count.index)}"
    availability_zone = "${element(var.azs, count.index)}"

    tags = {
        Name = "Terraform-Subnet-${local.name}-${count.index}"
    }
}


resource "aws_route_table" "terraform-public" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags = {
        Name = "${var.Main_Routing_Table}"
    }
}

resource "aws_route_table_association" "terraform-public" {
    count = "${length(var.cidrs)}"
    subnet_id = "${element(aws_subnet.subnets.*.id, count.index)}"
    route_table_id = "${aws_route_table.terraform-public.id}"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    }
}

#ata "aws_ami" "my_ami" {
#    most_recent      = true
#    #name_regex       = "^mavrick"
#    owners           = ["721834156908"]
#
resource "aws_instance" "web-1" {
    count = "${var.env == "prod" ? 3:1}"
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "${element(var.azs , count.index)}"
    instance_type = "t2.micro"
    key_name = "laptop-key-pair"
    subnet_id = "${element(aws_subnet.subnets.*.id, count.index)}"
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
    associate_public_ip_address = true	
    tags = {
       Name = "Server-${local.name}-${count.index}"
       Env ="prod${local.name}"
       Owner ="prabhu${local.name}"
   }
}

