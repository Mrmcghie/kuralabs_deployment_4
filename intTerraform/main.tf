variable "aws_access_key" {}
variable "aws_secret_key" {}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = "us-east-1"
  
}

resource "aws_instance" "Hi_Kura" {
  ami = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  key_name = "kuradeploy"
  vpc_security_group_ids = [aws_security_group.web_ssh.id]

  user_data = "${file("deploy.sh")}"

  tags = {
    "Name" : "Webserver001"
  }
  
}

output "instance_ip" {
  value = aws_instance.Hi_Kura.public_ip
  
}
