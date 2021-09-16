variable "compartment_id" {
  description = "The OCID of the compartment you want to work with."
}

variable "vcn_cidr" {
  description = "CIDR block for the VCN. Security rules are created after this."
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet."
  default = "10.0.0.0/24"
}
