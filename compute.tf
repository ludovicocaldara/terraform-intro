resource "oci_core_instance" "demo_vm" {
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
  compartment_id      = var.compartment_id
  shape               = var.vm_shape
  display_name        = var.compute_name

  source_details {
    source_id               = data.oci_core_images.vm_images.images[0].id
    source_type             = "image"
    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs
  }

  create_vnic_details {
    assign_public_ip        = true
    subnet_id               = oci_core_subnet.demo-public-subnet.id
    display_name            = "${var.compute_name}-vnic"
    hostname_label          = var.compute_name
  }

  metadata = {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }

}


resource "null_resource" "nginx_setup" {
  depends_on = [oci_core_instance.demo_vm]
  provisioner "remote-exec" {
    connection  {
      type        = "ssh"
      host        = oci_core_instance.demo_vm.public_ip
      agent       = false
      timeout     = "5m"
      user        = "opc"
      private_key = file(var.ssh_private_key_file)
    }
    inline = [ "sudo dnf install -y oracle-instantclient-release-el8 nginx" ]
  }
}

