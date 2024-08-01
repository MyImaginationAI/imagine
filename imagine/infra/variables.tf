variable "region" {
  description = "The AWS region where the instance will be created"
  default     = "us-east-1"
}

variable "ami" {
  description = "The AMI ID to use for the instance"
}

variable "instance_type" {
  description = "The instance type"
  default     = "t2.micro"
}
