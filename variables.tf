variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type = string
  default = "1.0.0.0"
}

variable "public_subnet_cidr" {
  description = "A list of public subnets inside the VPC"
  type = list(string)
  default = []
}

variable "db_subnet_cidr" {
  description = "A list of private subnets inside the VPC"
  type = list(string)
  default = []
}

variable "az" {
  type = list
  default = ["ap-south-1a","ap-south-1b"]
}


variable "name" {
  description = "name"
  type = string
  
}
  
