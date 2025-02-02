variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}
variable "amis" {
    description = "AMIs by region"
    default = {
        us-east-1 = "ami-09d069a04349dc3cb" # ubuntu 14.04 LTS
		us-east-2 = "ami-09d069a04349dc3cb" # ubuntu 14.04 LTS
		us-west-1 = "ami-09d069a04349dc3cb" # ubuntu 14.04 LTS
		us-west-2 = "ami-09d069a04349dc3cb" # ubuntu 14.04 LTS
    }
}
variable "vpc_cidr" {}
variable "vpc_name" {}
variable "IGW_name" {}
variable "key_name" {}
variable "public_subnet1_cidr" {}
variable "public_subnet2_cidr" {}
variable "public_subnet3_cidr" {}
variable "private_subnet_cidr" {}
variable "public_subnet1_name" {}
variable "public_subnet2_name" {}
variable "public_subnet3_name" {}
variable "private_subnet_name" {}
variable Main_Routing_Table {}
variable "azs" {
  description = "Run the EC2 Instances in these Availability Zones"
  type = "list"
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "cidrs" {
  description = "cidr block for the subnets"
  type = "list"
  default = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}
variable "env" {}
variable "instance_type" {
  type = "map"
  default = {
    dev = "t2.micro"
    test = "t2.micro"
    prod = "t2.micro"
    }
}



