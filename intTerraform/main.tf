variable "aws_access_key" {}
variable "aws_secret_key" {}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-east-1"
}
  resource "aws_vpc" "prod-vpc" {
    cidr_block            = "10.0.0.0/16"
    enable_dns_support    = "true" #gives you an internal domain name
    enable_dns_hostnames  = "true" #gives you an internal host name
    enable_classiclink    = "false"
    instance_tenancy      = "default"
    
    tags = {
        "Name" : "prod-vpc"
 }
}

  resource "aws_subnet" "prod-subnet-public-1" {
    vpc_id                  = "${aws_vpc.prod-vpc.id}"
    cidr_block              = "10.0.1.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone       = "us-east-1a"
      
      tags = {
      "Name" : "prod-subnet-public-1"
      }
}

    resource "aws_internet_gateway" "prod-igw" {
      vpc_id = "${aws_vpc.prod-vpc.id}"
      tags = {
        "Name" : "prod-igw"
    }
}

resource "aws_route_table" "prod-public-crt" {
    vpc_id = "${aws_vpc.main-vpc.id}"
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0"
                //CRT uses this IGW to reach internet
        gateway_id = "${aws_internet_gateway.prod-igw.id}" 
    }
    
    tags {
        "Name": "prod-public-crt"
    }
}

resource "aws_route_table_association" "prod-crta-public-subnet-1"{
   subnet_id = "${aws_subnet.prod-subnet-public-1.id}"
    route_table_id = "${aws_route_table.prod-public-crt.id}"
}
 resource "aws_instance" "Webserver001" { 
   ami                    = "ami-09d3b3274b6c5d4aa"
   instance_type          = "t2.micro"
   key_name               = "kuradeploy"
   vpc_security_group_ids = [aws_security_group.web_ssh.id]
   subnet_id              = "${aws_subnet.prod-subnet-public-1.id}"

   user_data = "${file("deploy.sh")}"

      tags = {
    "Name" : "Webserver001"
  }
}

 output "instance_ip" {
   value = aws_instance.Webserver001.public_ip

 }
