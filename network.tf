# -----------------------------------------------
# Setup the VCN.
# -----------------------------------------------
resource "oci_core_vcn" "demovcn" {
  cidr_block     = var.vcn_cidr
  dns_label      = "demovcn"
  compartment_id = var.compartment_id
  display_name   = "demo-vcn"
}

