resource "oci_core_instance" "demo_vm" {
  availability_domain = oci_identity_availability_domains.availability_domains[0].id {
  compartment_id      = var.compartment_id
  shape               = var.vm_shape
  display_name        = var.compute_name

  source_details {
    source_id               = data.oci_core_images.vm_images.images[0].id
    source_type             = "image"
    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs
  }

  create_vnic_details {
    assign_public_ip        = false
    subnet_id               = oci_core_subnet.demo-public-subnet.id
    display_name            = "${var.compute-name}-vnic"
    hostname_label          = var.compute-name
  }

  metadata = {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }

}
