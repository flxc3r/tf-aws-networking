variable "project_name" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "az_names" {
  type    = list(string)
  default = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "home_ip_cidr" {
  type = string
}

