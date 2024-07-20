variable "region" {
  type = string
}
variable "key_name" {
  description = "Name of the SSH key pair"
}

variable "vpc_name" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
variable "internet_gw_name" {
  type = string
}
variable "subnet1" {
  type = object({
    name = string
    cidr_block = string
    availability_zone = string
  })
}
# variable "subnet2" {
#   type = object({
#     name = string
#     cidr_block = string
#     availability_zone = string
#   })
# }
# variable "eip" {
#   type = string
# }
# variable "nat_gw_name" {
#   type = string
# }
variable "rt1_name" {
  type = string
}
# variable "rt2_name" {
#   type = string
# }
variable "ec2_name" {
  type = list(string)
}