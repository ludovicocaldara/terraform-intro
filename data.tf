data "oci_identity_compartment" "my_compartment" {
  id = var.compartment_id
}

data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = var.compartment_id
}

data "oci_core_images" "vm_images" {
  compartment_id             = var.compartment_id
  operating_system           = "Oracle Linux"
  operating_system_version   = "8"
  sort_by                    = "TIMECREATED"
  sort_order                 = "DESC"
}

