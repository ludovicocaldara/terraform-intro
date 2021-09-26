# lab8: Apply the stack with Resource Manager
1. [Description](#description)
2. [New in this lab](#new)
3. [Run the lab](#run)
4. [Checkout the next lab](#next)

## Description <a name="description"></a>
Now we have seen how to create and customize the resources, but getting the relevant information when the stack is applied is not handy.
The `output` blocks let you expose specific variables or expressions at the end of the apply so that all the relevant information is there.

At the end, we'll try to destroy and rebuild everything.

## New in this lab <a name="new"></a>
A new file contain the `output` blocks:
```
output "demo_vm" {
  value = format("Your demo VM is ready with public IP address %s", oci_core_instance.demo_vm.public_ip)
}

output "adb" {
  value = format("Your Autonomous Database is ready with sql_web address: %s", oci_database_autonomous_database.demo_adb.connection_urls[0].sql_dev_web_url)
}

output "adb-pwd" {
  value = format("Get your Autonomous Database password with: echo 'nonsensitive(random_password.adb_password.result' | terraform console")
}
```

## Run the lab <a name="run"></a>
Apply the stack:
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ terraform apply
random_password.adb_password: Refreshing state... [id=none]
oci_core_vcn.demovcn: Refreshing state... [id=ocid1.vcn.oc1.uk-london-1.amaaaaaaknuwtjiano6v5uj2afotp3ncddyyljiew4bwolcvcwph77whltqq]
oci_database_autonomous_database.demo_adb: Refreshing state... [id=ocid1.autonomousdatabase.oc1.uk-london-1.anwgiljtknuwtjiacpoqsg5a7wfk5qtxs5fnsi4e2udipu2uq4kbym634xha]
oci_core_internet_gateway.demo-internet-gateway: Refreshing state... [id=ocid1.internetgateway.oc1.uk-london-1.aaaaaaaa3za5j5f245qvnngxz2fe27e7ws2uwk6mspcexp64umgpxetb2tya]
oci_core_network_security_group.demo-network-security-group: Refreshing state... [id=ocid1.networksecuritygroup.oc1.uk-london-1.aaaaaaaaaku7m6jurchqwh3skgr37uqhemrya24fz5rbgplwiaijf7yle2tq]
oci_core_security_list.demo-security-list: Refreshing state... [id=ocid1.securitylist.oc1.uk-london-1.aaaaaaaawzkhszob5q5qosn2becvxao5pso5kzpjk3qrlyv6z4xantp5ixja]
oci_core_route_table.demo-public-rt: Refreshing state... [id=ocid1.routetable.oc1.uk-london-1.aaaaaaaa3ez6t4jf76jpmv3bmmj7naeihbg2am6ow3u4aa425neyuizmu4aq]
oci_core_subnet.demo-public-subnet: Refreshing state... [id=ocid1.subnet.oc1.uk-london-1.aaaaaaaanralbjcrmoeulvxpmktglvfqzchdmsrisgj6ejt45ulavub3dy4a]
oci_core_instance.demo_vm: Refreshing state... [id=ocid1.instance.oc1.uk-london-1.anwgiljrknuwtjicg6q47cycxqtfu6pmx4caeplnabpfgr27bec3tkxgepea]
null_resource.nginx_setup: Refreshing state... [id=225294201386725243]

Changes to Outputs:
  + adb     = "Your Autonomous Database is ready with sql_web address: https://DN2THOBKLNJOUFS-DEMOADB.adb.uk-london-1.oraclecloudapps.com/ords/sql-developer"
  + adb-pwd = "Get your Autonomous Database password with: echo \"nonsensitive(random_password.adb_password.result)\" | terraform console"
  + demo_vm = "Your demo VM is ready with public IP address 140.238.91.214"

You can apply this plan to save these new output values to the Terraform state, without changing any real infrastructure.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes


Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

adb = "Your Autonomous Database is ready with sql_web address: https://DN2THOBKLNJOUFS-DEMOADB.adb.uk-london-1.oraclecloudapps.com/ords/sql-developer"
adb-pwd = "Get your Autonomous Database password with: echo 'nonsensitive(random_password.adb_password.result)' | terraform console"
demo_vm = "Your demo VM is ready with public IP address 140.238.91.214"
```

You can see the relevant information at the end of the stack. You can recall it at any time with `terraform output`:
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ terraform output
adb = "Your Autonomous Database is ready with sql_web address: https://DN2THOBKLNJOUFS-DEMOADB.adb.uk-london-1.oraclecloudapps.com/ords/sql-developer"
adb-pwd = "Get your Autonomous Database password with: echo \"nonsensitive(random_password.adb_password.result)\" | terraform console"
demo_vm = "Your demo VM is ready with public IP address 140.238.91.214"
```

You can try to destroy and reapply the whole stack. You will see it will take ~2 minutes to destroy and ~2 minutes to create everything we've done so far.

`terraform destroy`
...
`terraform apply`

(omitting the output here, it's quite long).

Nice, huh?

## Checkout the next lab <a name="next"></a>
>>>>>>> lab7
