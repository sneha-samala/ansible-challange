# variables.tf
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "ami_id" {
  type    = string
  default = "ami-0532be01f26a3de55"  # Replace with a valid AMI in your region
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
