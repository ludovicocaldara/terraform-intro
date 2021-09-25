data "oci_identity_compartment" "my_compartment" {
    id = var.compartment_id
}

data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = var.compartment_id
}

data "oci_core_images" "vm_images" {
  compartment_id             = var.compartment_id
  display_name               = "Oracle-Linux-8.4-2021.08.27-0"
}
