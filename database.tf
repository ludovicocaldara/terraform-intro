

resource "random_password" "adb_password" {
  length           = 20
  special          = true
  number           = true
  upper            = true
  lower            = true
  override_special = "_%@+!"
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  min_upper        = 2
}

resource "oci_database_autonomous_database" "demo_adb" {
    #Required
    compartment_id = var.compartment_id
    db_name        = "demoadb"

    #Optional
    admin_password = random_password.adb_password.result
    is_free_tier   = true
    subnet_id      = oci_core_subnet.demo-public-subnet.id
}
