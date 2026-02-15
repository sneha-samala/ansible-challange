# variables.tf
variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "ami_id" {
  type    = string
  default = "ami-019715e0d74f695be"  # Replace with a valid AMI in your region
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
