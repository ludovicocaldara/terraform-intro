# lab5: create a Compute Instance
1. [Description](#description)
2. [New in this lab](#new)
3. [Run the lab](#run)
4. [Checkout the next lab](#next)

## Description <a name="description"></a>
In this Lab we will create a compute instance, with a specific shape and dynamic image.

## New in this lab <a name="new"></a>


A new `oci_core_instance` resource in `compute.tf`:
```
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
    assign_public_ip        = true
    subnet_id               = oci_core_subnet.demo-public-subnet.id
    display_name            = "${var.compute-name}-vnic"
    hostname_label          = var.compute-name
  }

  metadata = {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }

}
```

Notice that some of the parameters come from new `data` blocks:
```
    [...]
    availability_domain = oci_identity_availability_domains.availability_domains[0].id {
    [...]
      source_id               = data.oci_core_images.vm_images.images[0].id
    [...]
```
Those are defined as new data sources in `data.tf`:
```
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
```

We use `availability_domains` to get the OCID of the first availability domain in the region (for simplicity we use always the first one and won't try to disperse instances on different domains).
`vm_images` search for the latest OL8 image, the compute instance will use this one.


There are also some new variables in `variables.tf`.
```
variable "vm_shape" {
  description = "OCI Compute VM shape. Flex is the new default and it's pretty nice :-). Beware of your quotas, credits and limits if you plan to change it."
  default = "VM.Standard2.2"
}

variable "compute_name" {
  description = "display name for the compute instance"
  default = "demo-vm"
}

variable "ssh_public_key" {
  description = "public ssh key to connect to the compute instance"
}
```

Here, notice that `ssh_public_key` does not have a default value. We'll need to take it as an external variable, as we don't want to save it in the git repository.


## Run the lab <a name="run"></a>
The validate should succeed:
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ terraform validate
Success! The configuration is valid.
```

But the plan, as we have seen in previous labs, asks for the value of the `ssh_public_key` variable:
```
var.ssh_public_key
  public ssh key to connect to the compute instance

  Enter a value: ^C
Interrupt received.
Please wait for Terraform to exit or data loss may occur.
Gracefully shutting down...


╷
│ Error: No value for required variable
│ 
│   on variables.tf line 25:
│   25: variable "ssh_public_key" {
│ 
│ The root module input variable "ssh_public_key" is not set, and has no default value. Use a -var or -var-file command line argument to provide a value for this
│ variable.
╵
```

Let's create a key pair in our cloud shell and put the public key in our .barhrc:
```
ludovico_c@cloudshell:~ (uk-london-1)$ ssh-keygen 
Generating public/private rsa key pair.
Enter file in which to save the key (/home/ludovico_c/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/ludovico_c/.ssh/id_rsa.
Your public key has been saved in /home/ludovico_c/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:+Dx4dphdeqYMxhJT9vZ0eX1sbZx5iT6RXDJOa2jOESY ludovico_c@508bf4fdd566
The key's randomart image is:
+---[RSA 2048]----+
|                 |
|                 |
|        oE o + . |
|       + .o * B+*|
|      + S o+oOo+@|
|       B =+=+..+o|
|      o % +o+o   |
|       = = +  .  |
|          o      |
+----[SHA256]-----+
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ echo 'export TF_VAR_ssh_public_key=$(cat ~/.ssh/id_rsa.pub)' >> ~/.bashrc
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ . ~/.bashrc
```
The variable `TF_VAR_ssh_public_key` should be set and the plan should succeed:
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ terraform plan
random_password.adb_password: Refreshing state... [id=none]
oci_core_vcn.demovcn: Refreshing state... [id=ocid1.vcn.oc1.uk-london-1.amaaaaaaknuwtjiai6fi24b6daedzutlzfbyyw3w2dwhgzfun2imxxinsyka]
oci_database_autonomous_database.demo_adb: Refreshing state... [id=ocid1.autonomousdatabase.oc1.uk-london-1.anwgiljtknuwtjiayr6glo3extd2atgvptop4qpzqdlpwn7krkcjhd5yzqja]
oci_core_network_security_group.demo-network-security-group: Refreshing state... [id=ocid1.networksecuritygroup.oc1.uk-london-1.aaaaaaaajsf5fcjpjltt6bk6227l5mnpdqzkbf4ehf2ndwv432r2e556pqaq]
oci_core_internet_gateway.demo-internet-gateway: Refreshing state... [id=ocid1.internetgateway.oc1.uk-london-1.aaaaaaaaysidzuvfcpr74sixajjpofogs2lnvtnzsjfbx6yxokzr6ugp5byq]
oci_core_security_list.demo-security-list: Refreshing state... [id=ocid1.securitylist.oc1.uk-london-1.aaaaaaaa25fzqeohhsix26bi44kpexn7cgdjchbhsftzow5nqv4ogzqd3dvq]
oci_core_route_table.demo-public-rt: Refreshing state... [id=ocid1.routetable.oc1.uk-london-1.aaaaaaaa2a5dacz323c6wuw7liogm4hcllsb7tkccqbs7ldsoirz4gi5mkca]
oci_core_subnet.demo-public-subnet: Refreshing state... [id=ocid1.subnet.oc1.uk-london-1.aaaaaaaae7rjnngehlnllrt4665b2logspezs2d6ubxy3bzdqvnj5xggutma]

Note: Objects have changed outside of Terraform

Terraform detected the following changes made outside of Terraform since the last "terraform apply":

  # oci_database_autonomous_database.demo_adb has been changed
  ~ resource "oci_database_autonomous_database" "demo_adb" {
      ~ apex_details                         = [
          ~ {
              ~ ords_version = "21.2.3.217.1009" -> "21.2.4.243.1032"
                # (1 unchanged element hidden)
            },
        ]
        id                                   = "ocid1.autonomousdatabase.oc1.uk-london-1.anwgiljtknuwtjiayr6glo3extd2atgvptop4qpzqdlpwn7krkcjhd5yzqja"
      ~ time_maintenance_begin               = "2021-09-18 14:00:00 +0000 UTC" -> "2021-09-25 14:00:00 +0000 UTC"
      ~ time_maintenance_end                 = "2021-09-18 16:00:00 +0000 UTC" -> "2021-09-25 16:00:00 +0000 UTC"
      + used_data_storage_size_in_tbs        = 1
      + whitelisted_ips                      = []
        # (38 unchanged attributes hidden)
    }

Unless you have made equivalent changes to your configuration, or ignored the relevant attributes using ignore_changes, the following plan may include actions to undo or
respond to these changes.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # oci_core_instance.demo_vm will be created
  + resource "oci_core_instance" "demo_vm" {
      + availability_domain                 = "ocid1.availabilitydomain.oc1..aaaaaaaaw2i3i53quioaywmhx56ss5plwk7bmmeg2266lo7inilhbizeroua"
      + boot_volume_id                      = (known after apply)
      + capacity_reservation_id             = (known after apply)
      + compartment_id                      = "ocid1.compartment.oc1..aaaaaaaa7d5txgtjrxbasote6czdn6vwpt2gn5tqhkbpyytqdmorr2jed6pa"
      + dedicated_vm_host_id                = (known after apply)
      + defined_tags                        = (known after apply)
      + display_name                        = "demo-vm"
      + fault_domain                        = (known after apply)
      + freeform_tags                       = (known after apply)
      + hostname_label                      = (known after apply)
      + id                                  = (known after apply)
      + image                               = (known after apply)
      + ipxe_script                         = (known after apply)
      + is_pv_encryption_in_transit_enabled = (known after apply)
      + launch_mode                         = (known after apply)
      + metadata                            = {
          + "ssh_authorized_keys" = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDP3tr6pr7lu2O/gIEzJDb4sHZZqo2HqzYJYLgozmoR/jxBGtz5hWbrT72edNNIezOKy78uv83+5WNmudQPZdbRyBNPP7B/B0faMk0M/fo5tZB/4nCE102jhM5XSzK4JLc+PIfKp5idPJGKRvad/v3AXKFDSei6hW26h/Qml9xDKCqoi9ICM1L0q5hL77Rp6CLB5ephSdBqCUZQwj2ClaKuNMWSE8FIS1w+X9+vTDs1iBP7mFej6jaf1MKw74OQhXPdnPZaNOMKygA0m5rnxEFvLEnzltTdm5n7XMe2vYBlsbkRaNtUsmMqIeiV38CBbKdRM2YXClwHsI62ekHg8VZj ludovico_c@508bf4fdd566"
        }
      + private_ip                          = (known after apply)
      + public_ip                           = (known after apply)
      + region                              = (known after apply)
      + shape                               = "VM.Standard2.2"
      + state                               = (known after apply)
      + subnet_id                           = (known after apply)
      + system_tags                         = (known after apply)
      + time_created                        = (known after apply)
      + time_maintenance_reboot_due         = (known after apply)

      + agent_config {
          + are_all_plugins_disabled = (known after apply)
          + is_management_disabled   = (known after apply)
          + is_monitoring_disabled   = (known after apply)

          + plugins_config {
              + desired_state = (known after apply)
              + name          = (known after apply)
            }
        }

      + availability_config {
          + is_live_migration_preferred = (known after apply)
          + recovery_action             = (known after apply)
        }

      + create_vnic_details {
          + assign_public_ip       = "false"
          + defined_tags           = (known after apply)
          + display_name           = "demo-vm-vnic"
          + freeform_tags          = (known after apply)
          + hostname_label         = "demo-vm"
          + private_ip             = (known after apply)
          + skip_source_dest_check = (known after apply)
          + subnet_id              = "ocid1.subnet.oc1.uk-london-1.aaaaaaaae7rjnngehlnllrt4665b2logspezs2d6ubxy3bzdqvnj5xggutma"
          + vlan_id                = (known after apply)
        }

      + instance_options {
          + are_legacy_imds_endpoints_disabled = (known after apply)
        }

      + launch_options {
          + boot_volume_type                    = (known after apply)
          + firmware                            = (known after apply)
          + is_consistent_volume_naming_enabled = (known after apply)
          + is_pv_encryption_in_transit_enabled = (known after apply)
          + network_type                        = (known after apply)
          + remote_data_volume_type             = (known after apply)
        }

      + platform_config {
          + numa_nodes_per_socket = (known after apply)
          + type                  = (known after apply)
        }

      + preemptible_instance_config {
          + preemption_action {
              + preserve_boot_volume = (known after apply)
              + type                 = (known after apply)
            }
        }

      + shape_config {
          + baseline_ocpu_utilization     = (known after apply)
          + gpu_description               = (known after apply)
          + gpus                          = (known after apply)
          + local_disk_description        = (known after apply)
          + local_disks                   = (known after apply)
          + local_disks_total_size_in_gbs = (known after apply)
          + max_vnic_attachments          = (known after apply)
          + memory_in_gbs                 = (known after apply)
          + networking_bandwidth_in_gbps  = (known after apply)
          + ocpus                         = (known after apply)
          + processor_description         = (known after apply)
        }

      + source_details {
          + boot_volume_size_in_gbs = "128"
          + kms_key_id              = (known after apply)
          + source_id               = "ocid1.image.oc1.uk-london-1.aaaaaaaanpmhufh235fw3c54pxp7lgsqww6krdjpb46xg4y5f54osecrev2a"
          + source_type             = "image"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────��───────────────────────────────���──────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

So we can apply it:
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ terraform apply
random_password.adb_password: Refreshing state... [id=none]
oci_core_vcn.demovcn: Refreshing state... [id=ocid1.vcn.oc1.uk-london-1.amaaaaaaknuwtjiano6v5uj2afotp3ncddyyljiew4bwolcvcwph77whltqq]
oci_database_autonomous_database.demo_adb: Refreshing state... [id=ocid1.autonomousdatabase.oc1.uk-london-1.anwgiljtknuwtjiacpoqsg5a7wfk5qtxs5fnsi4e2udipu2uq4kbym634xha]
oci_core_network_security_group.demo-network-security-group: Refreshing state... [id=ocid1.networksecuritygroup.oc1.uk-london-1.aaaaaaaaaku7m6jurchqwh3skgr37uqhemrya24fz5rbgplwiaijf7yle2tq]
oci_core_security_list.demo-security-list: Refreshing state... [id=ocid1.securitylist.oc1.uk-london-1.aaaaaaaawzkhszob5q5qosn2becvxao5pso5kzpjk3qrlyv6z4xantp5ixja]
oci_core_internet_gateway.demo-internet-gateway: Refreshing state... [id=ocid1.internetgateway.oc1.uk-london-1.aaaaaaaa3za5j5f245qvnngxz2fe27e7ws2uwk6mspcexp64umgpxetb2tya]
oci_core_route_table.demo-public-rt: Refreshing state... [id=ocid1.routetable.oc1.uk-london-1.aaaaaaaa3ez6t4jf76jpmv3bmmj7naeihbg2am6ow3u4aa425neyuizmu4aq]
oci_core_subnet.demo-public-subnet: Refreshing state... [id=ocid1.subnet.oc1.uk-london-1.aaaaaaaanralbjcrmoeulvxpmktglvfqzchdmsrisgj6ejt45ulavub3dy4a]

Note: Objects have changed outside of Terraform

Terraform detected the following changes made outside of Terraform since the last "terraform apply":

  # oci_database_autonomous_database.demo_adb has been changed
  ~ resource "oci_database_autonomous_database" "demo_adb" {
        id                                   = "ocid1.autonomousdatabase.oc1.uk-london-1.anwgiljtknuwtjiacpoqsg5a7wfk5qtxs5fnsi4e2udipu2uq4kbym634xha"
      + used_data_storage_size_in_tbs        = 1
      + whitelisted_ips                      = []
        # (41 unchanged attributes hidden)
    }

Unless you have made equivalent changes to your configuration, or ignored the relevant attributes using ignore_changes, the following plan may include actions to undo or
respond to these changes.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # oci_core_instance.demo_vm will be created
  + resource "oci_core_instance" "demo_vm" {
      + availability_domain                 = "OUGC:UK-LONDON-1-AD-1"
      + boot_volume_id                      = (known after apply)
      + capacity_reservation_id             = (known after apply)
      + compartment_id                      = "ocid1.compartment.oc1..aaaaaaaa7d5txgtjrxbasote6czdn6vwpt2gn5tqhkbpyytqdmorr2jed6pa"
      + dedicated_vm_host_id                = (known after apply)
      + defined_tags                        = (known after apply)
      + display_name                        = "demo-vm"
      + fault_domain                        = (known after apply)
      + freeform_tags                       = (known after apply)
      + hostname_label                      = (known after apply)
      + id                                  = (known after apply)
      + image                               = (known after apply)
      + ipxe_script                         = (known after apply)
      + is_pv_encryption_in_transit_enabled = (known after apply)
      + launch_mode                         = (known after apply)
      + metadata                            = {
          + "ssh_authorized_keys" = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDP3tr6pr7lu2O/gIEzJDb4sHZZqo2HqzYJYLgozmoR/jxBGtz5hWbrT72edNNIezOKy78uv83+5WNmudQPZdbRyBNPP7B/B0faMk0M/fo5tZB/4nCE102jhM5XSzK4JLc+PIfKp5idPJGKRvad/v3AXKFDSei6hW26h/Qml9xDKCqoi9ICM1L0q5hL77Rp6CLB5ephSdBqCUZQwj2ClaKuNMWSE8FIS1w+X9+vTDs1iBP7mFej6jaf1MKw74OQhXPdnPZaNOMKygA0m5rnxEFvLEnzltTdm5n7XMe2vYBlsbkRaNtUsmMqIeiV38CBbKdRM2YXClwHsI62ekHg8VZj ludovico_c@508bf4fdd566"
        }
      + private_ip                          = (known after apply)
      + public_ip                           = (known after apply)
      + region                              = (known after apply)
      + shape                               = "VM.Standard2.2"
      + state                               = (known after apply)
      + subnet_id                           = (known after apply)
      + system_tags                         = (known after apply)
      + time_created                        = (known after apply)
      + time_maintenance_reboot_due         = (known after apply)

      + agent_config {
          + are_all_plugins_disabled = (known after apply)
          + is_management_disabled   = (known after apply)
          + is_monitoring_disabled   = (known after apply)

          + plugins_config {
              + desired_state = (known after apply)
              + name          = (known after apply)
            }
        }

      + availability_config {
          + is_live_migration_preferred = (known after apply)
          + recovery_action             = (known after apply)
        }

      + create_vnic_details {
          + assign_public_ip       = "true"
          + defined_tags           = (known after apply)
          + display_name           = "demo-vm-vnic"
          + freeform_tags          = (known after apply)
          + hostname_label         = "demo-vm"
          + private_ip             = (known after apply)
          + skip_source_dest_check = (known after apply)
          + subnet_id              = "ocid1.subnet.oc1.uk-london-1.aaaaaaaanralbjcrmoeulvxpmktglvfqzchdmsrisgj6ejt45ulavub3dy4a"
          + vlan_id                = (known after apply)
        }

      + instance_options {
          + are_legacy_imds_endpoints_disabled = (known after apply)
        }

      + launch_options {
          + boot_volume_type                    = (known after apply)
          + firmware                            = (known after apply)
          + is_consistent_volume_naming_enabled = (known after apply)
          + is_pv_encryption_in_transit_enabled = (known after apply)
          + network_type                        = (known after apply)
          + remote_data_volume_type             = (known after apply)
        }

      + platform_config {
          + is_measured_boot_enabled           = (known after apply)
          + is_secure_boot_enabled             = (known after apply)
          + is_trusted_platform_module_enabled = (known after apply)
          + numa_nodes_per_socket              = (known after apply)
          + type                               = (known after apply)
        }

      + preemptible_instance_config {
          + preemption_action {
              + preserve_boot_volume = (known after apply)
              + type                 = (known after apply)
            }
        }

      + shape_config {
          + baseline_ocpu_utilization     = (known after apply)
          + gpu_description               = (known after apply)
          + gpus                          = (known after apply)
          + local_disk_description        = (known after apply)
          + local_disks                   = (known after apply)
          + local_disks_total_size_in_gbs = (known after apply)
          + max_vnic_attachments          = (known after apply)
          + memory_in_gbs                 = (known after apply)
          + networking_bandwidth_in_gbps  = (known after apply)
          + ocpus                         = (known after apply)
          + processor_description         = (known after apply)
        }

      + source_details {
          + boot_volume_size_in_gbs = "128"
          + kms_key_id              = (known after apply)
          + source_id               = "ocid1.image.oc1.uk-london-1.aaaaaaaaepro26rad7iuh6wfqyhro447vx34bd2f4ytqathabc3lytgnassq"
          + source_type             = "image"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

oci_core_instance.demo_vm: Creating...
oci_core_instance.demo_vm: Still creating... [10s elapsed]
oci_core_instance.demo_vm: Still creating... [20s elapsed]
oci_core_instance.demo_vm: Still creating... [30s elapsed]
oci_core_instance.demo_vm: Creation complete after 37s [id=ocid1.instance.oc1.uk-london-1.anwgiljrknuwtjicg6q47cycxqtfu6pmx4caeplnabpfgr27bec3tkxgepea]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

## Checkout the next lab <a name="next"></a>
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ git checkout lab6
Branch lab6 set up to track remote branch lab6 from origin.
Switched to a new branch 'lab6'
```
