variable "name" {}
variable "env" {}
variable "domain"{}
variable "owner" {}
variable "cidr" {}
variable "peer_vpc_id"{}

variable "peer_owner_id" {}
variable "peer_vpc_cidr" {}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC."
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC."
  default     = []
}

variable "azs" {
  description = "A list of Availability zones in the region"
  default     = []
}

variable "enable_dns_hostnames" {
  description = "should be true if you want to use private DNS within the VPC"
  default     = true
}

variable "enable_dns_support" {
  description = "should be true if you want to use private DNS within the VPC"
  default     = true
}

variable "private_propagating_vgws" {
  description = "A list of VGWs the private route table should propagate."
  default     = []
}

variable "public_propagating_vgws" {
  description = "A list of VGWs the public route table should propagate."
  default     = []
}

#############################
#    Tags Configuration
#############################

variable "vpc_tag_costcenter" {
  default = "03742"
}
variable "vpc_tag_projectname" {
  default = "paas"
}

variable "vpc_tag_lineofbusiness" {
  default = "N/A"
}
