
variable "ociCompartmentOcid" {
  default = "ocid1.compartment.oc1..aaaaaaaa7p4obbaeopdf2vlaqd45pydn73yrwdhu6m7ed2b6ujoukyslfzoq"
}

variable "ociTenancyOcid" {
  default = "ocid1.tenancy.oc1..aaaaaaaaj4ccqe763dizkrcdbs5x7ufvmmojd24mb6utvkymyo4xwxyv3gfa"
}

variable "ociRegionIdentifier" {
  default = "uk-london-1"
}

variable "availability_domain_name" {
  default = "OUGC:UK-LONDON-1-AD-1"
}

variable "ociUserOcid" {
  default = "ocid1.user.oc1..aaaaaaaa3i6le5uvikofyaituf25kmnsfq3mgmenigvcxwygbas2gxlvxywq"
}

variable "private_key_path" {
  description = "The OCI API keys for your user"
  default = "C:\\Users\\LCALDARA\\.ssh\\oci.pem"
}

variable "fingerprint" {
  description = "The OCI API fingerprint for your user"
  default = "ef:19:f3:ae:ca:09:e3:65:00:15:c3:54:23:05:89:47"
}

terraform {
  backend "http" {
    address       = "https://objectstorage.uk-london-1.oraclecloud.com/p/FE8E_Jp9KKV13LkyndUcUtaqKvbRpKekk716Upvi8Fz9UTjrFxoUK5XIwylR1R07/n/oradbclouducm/b/terraform-demo.tfstate/o/terraform-demo.tfstate"
    update_method = "PUT"
  }
}
