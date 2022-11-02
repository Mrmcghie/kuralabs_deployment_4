variable "aws_access_key" {AKIAW34TF7FCFRJSVB6C}
variable "aws_secret_key" {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}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = "us-east-1"
  
}

resource "aws_instance" "web_server01" {
  ami = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  key_name = "kuradeploy.pem"
  vpc_security_group_ids = [aws_security_group.web_ssh.id]

  user_data = "${file("deploy.sh")}"

  tags = {
    "Name" : "Webserver001"
  }
  
}

output "instance_ip" {
  value = aws_instance.web_server01.public_ip
  
}
