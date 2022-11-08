variable "aws_access_key" {}
variable "aws_secret_key" {}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-east-1a"
}

 resource "aws_instance" "hi20850" {
   ami                    = "ami-09d3b3274b6c5d4aa"
   instance_type          = "t2.micro"
   key_name               = "kuradeploy"
   vpc_security_group_ids = [aws_security_group.web_ssh.id]

   user_data = "${file("deploy.sh")}"


  tags = {
    "Name" : "Webserver001"
  }
}

 output "instance_ip" {
   value = aws_instance.hi20850.public_ip

}

