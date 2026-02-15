provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "frontend" {
  ami           = "ami-0317b0f0a0144b137" # Amazon Linux 2 AMI
  instance_type = "t3.micro"
  tags = {
    Name = "c8.local"
  }
}

resource "aws_instance" "backend" {
  ami           = "ami-019715e0d74f695be" # Ubuntu 21.04 AMI
  instance_type = "t3.micro"
  tags = {
    Name = "u21.local"
  }
}

output "frontend_ip" {
  value = aws_instance.frontend.public_ip
}

output "backend_ip" {
  value = aws_instance.backend.public_ip
}
