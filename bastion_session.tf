resource "oci_bastion_session" "demo_session" {
    bastion_id = oci_bastion_bastion.demo_bastion.id
    key_details {
        public_key_content = var.ssh_public_key
    }
    target_resource_details {
        session_type       = "PORT_FORWARDING"
        target_resource_id = oci_core_instance.demo_vm.id

        target_resource_operating_system_user_name = "opc"
        target_resource_port = 22
        target_resource_private_ip_address = oci_core_instance.demo_vm.private_ip
    }

    display_name = "demo_session"
    key_type     = "PUB"
}
