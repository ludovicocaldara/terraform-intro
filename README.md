# A gentle introduction to Terraform in OCI

## lab4: create an Autonomous Database



### New in this lab:



### Run the updated stack

The `terraform` validate will fail this time because we are using a new resource plugin (random).
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ terraform validate
╷
│ Error: Could not load plugin
│ 
│ 
│ Plugin reinitialization required. Please run "terraform init".
│ 
│ Plugins are external binaries that Terraform uses to access and manipulate
│ resources. The configuration provided requires plugins which can't be located,
│ don't satisfy the version constraints, or are otherwise incompatible.
│ 
│ Terraform automatically discovers provider requirements from your
│ configuration, including providers used in child modules. To see the
│ requirements and constraints, run "terraform providers".
│ 
│ failed to instantiate provider "registry.terraform.io/hashicorp/random" to obtain schema: unknown provider "registry.terraform.io/hashicorp/random"
│ 
╵
```

We have to run `terraform init` again:
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/random...
- Reusing previous version of hashicorp/oci from the dependency lock file
- Installing hashicorp/random v3.1.0...
- Installed hashicorp/random v3.1.0 (signed by HashiCorp)
- Using previously-installed hashicorp/oci v4.42.0

Terraform has made some changes to the provider dependency selections recorded
in the .terraform.lock.hcl file. Review those changes and commit them to your
version control system if they represent changes you intended to make.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

And then the validate will succeed:
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ terraform plan
oci_core_vcn.demovcn: Refreshing state... [id=ocid1.vcn.oc1.uk-london-1.amaaaaaaknuwtjiai6fi24b6daedzutlzfbyyw3w2dwhgzfun2imxxinsyka]
oci_core_network_security_group.demo-network-security-group: Refreshing state... [id=ocid1.networksecuritygroup.oc1.uk-london-1.aaaaaaaajsf5fcjpjltt6bk6227l5mnpdqzkbf4ehf2ndwv432r2e556pqaq]
oci_core_internet_gateway.demo-internet-gateway: Refreshing state... [id=ocid1.internetgateway.oc1.uk-london-1.aaaaaaaaysidzuvfcpr74sixajjpofogs2lnvtnzsjfbx6yxokzr6ugp5byq]
oci_core_security_list.demo-security-list: Refreshing state... [id=ocid1.securitylist.oc1.uk-london-1.aaaaaaaa25fzqeohhsix26bi44kpexn7cgdjchbhsftzow5nqv4ogzqd3dvq]
oci_core_route_table.demo-public-rt: Refreshing state... [id=ocid1.routetable.oc1.uk-london-1.aaaaaaaa2a5dacz323c6wuw7liogm4hcllsb7tkccqbs7ldsoirz4gi5mkca]
oci_core_subnet.demo-public-subnet: Refreshing state... [id=ocid1.subnet.oc1.uk-london-1.aaaaaaaae7rjnngehlnllrt4665b2logspezs2d6ubxy3bzdqvnj5xggutma]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # oci_database_autonomous_database.demo_adb will be created
  + resource "oci_database_autonomous_database" "demo_adb" {
      + admin_password                                 = (sensitive value)
      + apex_details                                   = (known after apply)
      + are_primary_whitelisted_ips_used               = (known after apply)
      + autonomous_container_database_id               = (known after apply)
      + autonomous_database_backup_id                  = (known after apply)
      + autonomous_database_id                         = (known after apply)
      + autonomous_maintenance_schedule_type           = (known after apply)
      + available_upgrade_versions                     = (known after apply)
      + backup_config                                  = (known after apply)
      + clone_type                                     = (known after apply)
      + compartment_id                                 = "ocid1.compartment.oc1..aaaaaaaa7d5txgtjrxbasote6czdn6vwpt2gn5tqhkbpyytqdmorr2jed6pa"
      + connection_strings                             = (known after apply)
      + connection_urls                                = (known after apply)
      + cpu_core_count                                 = (known after apply)
      + data_safe_status                               = (known after apply)
      + data_storage_size_in_gb                        = (known after apply)
      + data_storage_size_in_tbs                       = (known after apply)
      + db_name                                        = "demo_adb"
      + db_version                                     = (known after apply)
      + db_workload                                    = (known after apply)
      + defined_tags                                   = (known after apply)
      + display_name                                   = (known after apply)
      + failed_data_recovery_in_seconds                = (known after apply)
      + freeform_tags                                  = (known after apply)
      + id                                             = (known after apply)
      + infrastructure_type                            = (known after apply)
      + is_access_control_enabled                      = (known after apply)
      + is_auto_scaling_enabled                        = (known after apply)
      + is_data_guard_enabled                          = (known after apply)
      + is_dedicated                                   = (known after apply)
      + is_free_tier                                   = true
      + is_preview                                     = (known after apply)
      + is_preview_version_with_service_terms_accepted = (known after apply)
      + is_refreshable_clone                           = (known after apply)
      + key_history_entry                              = (known after apply)
      + key_store_id                                   = (known after apply)
      + key_store_wallet_name                          = (known after apply)
      + kms_key_id                                     = (known after apply)
      + kms_key_lifecycle_details                      = (known after apply)
      + license_model                                  = (known after apply)
      + lifecycle_details                              = (known after apply)
      + nsg_ids                                        = (known after apply)
      + ocpu_count                                     = (known after apply)
      + open_mode                                      = (known after apply)
      + operations_insights_status                     = (known after apply)
      + permission_level                               = (known after apply)
      + private_endpoint                               = (known after apply)
      + private_endpoint_ip                            = (known after apply)
      + private_endpoint_label                         = (known after apply)
      + refreshable_mode                               = (known after apply)
      + refreshable_status                             = (known after apply)
      + role                                           = (known after apply)
      + service_console_url                            = (known after apply)
      + source                                         = (known after apply)
      + source_id                                      = (known after apply)
      + standby_db                                     = (known after apply)
      + standby_whitelisted_ips                        = (known after apply)
      + state                                          = (known after apply)
      + subnet_id                                      = "ocid1.subnet.oc1.uk-london-1.aaaaaaaae7rjnngehlnllrt4665b2logspezs2d6ubxy3bzdqvnj5xggutma"
      + system_tags                                    = (known after apply)
      + time_created                                   = (known after apply)
      + time_deletion_of_free_autonomous_database      = (known after apply)
      + time_maintenance_begin                         = (known after apply)
      + time_maintenance_end                           = (known after apply)
      + time_of_last_failover                          = (known after apply)
      + time_of_last_refresh                           = (known after apply)
      + time_of_last_refresh_point                     = (known after apply)
      + time_of_last_switchover                        = (known after apply)
      + time_of_next_refresh                           = (known after apply)
      + time_reclamation_of_free_autonomous_database   = (known after apply)
      + timestamp                                      = (known after apply)
      + used_data_storage_size_in_tbs                  = (known after apply)
      + vault_id                                       = (known after apply)

      + customer_contacts {
          + email = (known after apply)
        }
    }

  # random_password.adb_password will be created
  + resource "random_password" "adb_password" {
      + id               = (known after apply)
      + length           = 20
      + lower            = true
      + min_lower        = 2
      + min_numeric      = 2
      + min_special      = 2
      + min_upper        = 2
      + number           = true
      + override_special = "_%@+!"
      + result           = (sensitive value)
      + special          = true
      + upper            = true
    }

Plan: 2 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

`terraform apply` will create the Autonomous Database.
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ terraform apply
random_password.adb_password: Refreshing state... [id=none]
oci_core_vcn.demovcn: Refreshing state... [id=ocid1.vcn.oc1.uk-london-1.amaaaaaaknuwtjiai6fi24b6daedzutlzfbyyw3w2dwhgzfun2imxxinsyka]
oci_core_internet_gateway.demo-internet-gateway: Refreshing state... [id=ocid1.internetgateway.oc1.uk-london-1.aaaaaaaaysidzuvfcpr74sixajjpofogs2lnvtnzsjfbx6yxokzr6ugp5byq]
oci_core_network_security_group.demo-network-security-group: Refreshing state... [id=ocid1.networksecuritygroup.oc1.uk-london-1.aaaaaaaajsf5fcjpjltt6bk6227l5mnpdqzkbf4ehf2ndwv432r2e556pqaq]
oci_core_security_list.demo-security-list: Refreshing state... [id=ocid1.securitylist.oc1.uk-london-1.aaaaaaaa25fzqeohhsix26bi44kpexn7cgdjchbhsftzow5nqv4ogzqd3dvq]
oci_core_route_table.demo-public-rt: Refreshing state... [id=ocid1.routetable.oc1.uk-london-1.aaaaaaaa2a5dacz323c6wuw7liogm4hcllsb7tkccqbs7ldsoirz4gi5mkca]
oci_core_subnet.demo-public-subnet: Refreshing state... [id=ocid1.subnet.oc1.uk-london-1.aaaaaaaae7rjnngehlnllrt4665b2logspezs2d6ubxy3bzdqvnj5xggutma]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # oci_database_autonomous_database.demo_adb will be created
  + resource "oci_database_autonomous_database" "demo_adb" {
      + admin_password                                 = (sensitive value)
      + apex_details                                   = (known after apply)
      + are_primary_whitelisted_ips_used               = (known after apply)
      + autonomous_container_database_id               = (known after apply)
      + autonomous_database_backup_id                  = (known after apply)
      + autonomous_database_id                         = (known after apply)
      + autonomous_maintenance_schedule_type           = (known after apply)
      + available_upgrade_versions                     = (known after apply)
      + backup_config                                  = (known after apply)
      + clone_type                                     = (known after apply)
      + compartment_id                                 = "ocid1.compartment.oc1..aaaaaaaa7d5txgtjrxbasote6czdn6vwpt2gn5tqhkbpyytqdmorr2jed6pa"
      + connection_strings                             = (known after apply)
      + connection_urls                                = (known after apply)
      + cpu_core_count                                 = 1
      + data_safe_status                               = (known after apply)
      + data_storage_size_in_gb                        = (known after apply)
      + data_storage_size_in_tbs                       = 1
      + db_name                                        = "demoadb"
      + db_version                                     = (known after apply)
      + db_workload                                    = (known after apply)
      + defined_tags                                   = (known after apply)
      + display_name                                   = (known after apply)
      + failed_data_recovery_in_seconds                = (known after apply)
      + freeform_tags                                  = (known after apply)
      + id                                             = (known after apply)
      + infrastructure_type                            = (known after apply)
      + is_access_control_enabled                      = (known after apply)
      + is_auto_scaling_enabled                        = (known after apply)
      + is_data_guard_enabled                          = (known after apply)
      + is_dedicated                                   = (known after apply)
      + is_free_tier                                   = false
      + is_preview                                     = (known after apply)
      + is_preview_version_with_service_terms_accepted = (known after apply)
      + is_refreshable_clone                           = (known after apply)
      + key_history_entry                              = (known after apply)
      + key_store_id                                   = (known after apply)
      + key_store_wallet_name                          = (known after apply)
      + kms_key_id                                     = (known after apply)
      + kms_key_lifecycle_details                      = (known after apply)
      + license_model                                  = (known after apply)
      + lifecycle_details                              = (known after apply)
      + nsg_ids                                        = (known after apply)
      + ocpu_count                                     = (known after apply)
      + open_mode                                      = (known after apply)
      + operations_insights_status                     = (known after apply)
      + permission_level                               = (known after apply)
      + private_endpoint                               = (known after apply)
      + private_endpoint_ip                            = (known after apply)
      + private_endpoint_label                         = (known after apply)
      + refreshable_mode                               = (known after apply)
      + refreshable_status                             = (known after apply)
      + role                                           = (known after apply)
      + service_console_url                            = (known after apply)
      + source                                         = (known after apply)
      + source_id                                      = (known after apply)
      + standby_db                                     = (known after apply)
      + standby_whitelisted_ips                        = (known after apply)
      + state                                          = (known after apply)
      + subnet_id                                      = (known after apply)
      + system_tags                                    = (known after apply)
      + time_created                                   = (known after apply)
      + time_deletion_of_free_autonomous_database      = (known after apply)
      + time_maintenance_begin                         = (known after apply)
      + time_maintenance_end                           = (known after apply)
      + time_of_last_failover                          = (known after apply)
      + time_of_last_refresh                           = (known after apply)
      + time_of_last_refresh_point                     = (known after apply)
      + time_of_last_switchover                        = (known after apply)
      + time_of_next_refresh                           = (known after apply)
      + time_reclamation_of_free_autonomous_database   = (known after apply)
      + timestamp                                      = (known after apply)
      + used_data_storage_size_in_tbs                  = (known after apply)
      + vault_id                                       = (known after apply)

      + customer_contacts {
          + email = (known after apply)
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

oci_database_autonomous_database.demo_adb: Creating...
oci_database_autonomous_database.demo_adb: Still creating... [10s elapsed]
oci_database_autonomous_database.demo_adb: Still creating... [20s elapsed]
oci_database_autonomous_database.demo_adb: Still creating... [30s elapsed]
oci_database_autonomous_database.demo_adb: Still creating... [40s elapsed]
oci_database_autonomous_database.demo_adb: Creation complete after 49s [id=ocid1.autonomousdatabase.oc1.uk-london-1.anwgiljtknuwtjiayr6glo3extd2atgvptop4qpzqdlpwn7krkcjhd5yzqja]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

### To continue, switch to the lab5 branch:
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ git checkout lab5
Branch lab5 set up to track remote branch lab5 from origin.
Switched to a new branch 'lab5'
