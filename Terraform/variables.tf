variable "region" {
  description = "The AWS region in which the resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "ami" {
  description = "The ID of the Amazon Machine Image (AMI) used to create the EC2 instance."
  type        = string
  default     = "ami-051f8a213df8bc089"
}

variable "instance_type" {
  description = "The type of EC2 instance used to create the instance."
  type        = string
  default     = "t2.micro"
}

variable "instance_ip" {
    description = "The public IP address of the EC2 instance."
    type        = string
    default     = "us-east-1"
}
