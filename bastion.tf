resource "oci_bastion_bastion" "demo_bastion" {
    bastion_type = "STANDARD"
    compartment_id = var.compartment_id
    target_subnet_id = oci_core_subnet.demo-public-subnet.id
    client_cidr_block_allow_list = ["0.0.0.0/0"]
    name = "demobastion"
}
