# lab2: create your first resource: the VCN
1. [Description](#description)
2. [New in this lab](#new)
3. [Run the lab](#run)
4. [Checkout the next lab](#next)

## Description <a name="description"></a>
We have seen how to query a data source, now let's create our first resource: the Virtual Cloud Network (VCN).
This is done by using the resource `oci_core_vcn`: https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_vcn

## New in this lab <a name="new"></a>
The file `network.tf` contains a new resource for the VCN:
```
# -----------------------------------------------
# Setup the VCN.
# -----------------------------------------------
resource "oci_core_vcn" "demovcn" {
  cidr_block     = var.vcn_cidr
  dns_label      = "demovcn"
  compartment_id = var.compartment_id
  display_name   = "demo-vcn"
}
```

The new variable `vcn_cidr` has been added to `variables.tf`:
```
variable "vcn_cidr" {
  description = "CIDR block for the VCN. Security rules are created after this."
  default = "10.0.0.0/16"
}
```

## Run the lab <a name="run"></a>
Plan and apply the stack
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # oci_core_vcn.demovcn will be created
  + resource "oci_core_vcn" "demovcn" {
      + cidr_block               = "10.0.0.0/16"
      + cidr_blocks              = (known after apply)
      + compartment_id           = "ocid1.compartment.oc1..aaaaaaaa7d5txgtjrxbasote6czdn6vwpt2gn5tqhkbpyytqdmorr2jed6pa"
      + default_dhcp_options_id  = (known after apply)
      + default_route_table_id   = (known after apply)
      + default_security_list_id = (known after apply)
      + defined_tags             = (known after apply)
      + display_name             = "demo-vcn"
      + dns_label                = "demovcn"
      + freeform_tags            = (known after apply)
      + id                       = (known after apply)
      + ipv6cidr_blocks          = (known after apply)
      + is_ipv6enabled           = (known after apply)
      + state                    = (known after apply)
      + time_created             = (known after apply)
      + vcn_domain_name          = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

As the apply changes the infrastructure, you have to confirm the modification by entering `yes`:
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # oci_core_vcn.demovcn will be created
  + resource "oci_core_vcn" "demovcn" {
      + cidr_block               = "10.0.0.0/16"
      + cidr_blocks              = (known after apply)
      + compartment_id           = "ocid1.compartment.oc1..aaaaaaaa7d5txgtjrxbasote6czdn6vwpt2gn5tqhkbpyytqdmorr2jed6pa"
      + default_dhcp_options_id  = (known after apply)
      + default_route_table_id   = (known after apply)
      + default_security_list_id = (known after apply)
      + defined_tags             = (known after apply)
      + display_name             = "demo-vcn"
      + dns_label                = "demovcn"
      + freeform_tags            = (known after apply)
      + id                       = (known after apply)
      + ipv6cidr_blocks          = (known after apply)
      + is_ipv6enabled           = (known after apply)
      + state                    = (known after apply)
      + time_created             = (known after apply)
      + vcn_domain_name          = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

oci_core_vcn.demovcn: Creating...
oci_core_vcn.demovcn: Creation complete after 1s [id=ocid1.vcn.oc1.uk-london-1.amaaaaaaknuwtjiai6fi24b6daedzutlzfbyyw3w2dwhgzfun2imxxinsyka]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

You can confirm with `terraform show` or with the console that the VCN has been created.

## Checkout the next lab <a name="next"></a>
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ git checkout lab3
Branch lab3 set up to track remote branch lab3 from origin.
Switched to a new branch 'lab3'
```
