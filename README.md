# lab3: create the additional network components
1. [Description](#description)
2. [New in this lab](#new)
3. [Run the lab](#run)
4. [Checkout the next lab](#next)

## Description <a name="description"></a>
Now that we have created our first resource, we can complete the network setup with subnet, internet gateway, routing table, security group, security list.

## New in this lab <a name="new"></a>
The file `network.tf` contains a new resources:
```
# -----------------------------------------------
# Setup the Internet Gateway
# -----------------------------------------------
resource "oci_core_internet_gateway" "demo-internet-gateway" {
  display_name   = "demo-igw"

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.demovcn.id
  enabled        = "true"
}

# -----------------------------------------------
# Setup the Route Table
# -----------------------------------------------
resource "oci_core_route_table" "demo-public-rt" {
  display_name   = "demo-routetable"

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.demovcn.id

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.demo-internet-gateway.id
  }
}

# ---------------------------------------------
# Setup the Security Group
# ---------------------------------------------
resource "oci_core_network_security_group" "demo-network-security-group" {
  display_name   = "demo-nsg"

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.demovcn.id
}

# ---------------------------------------------
# Setup the subnet
# ---------------------------------------------
resource "oci_core_subnet" "demo-public-subnet" {
  display_name      = "demo-pubsubnet"
  dns_label         = "pub"

  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.demovcn.id
  cidr_block        = var.subnet_cidr
  route_table_id    = oci_core_route_table.demo-public-rt.id
  security_list_ids = [oci_core_security_list.demo-security-list.id]
}
```

The security list allows ingress and egress traffic for the protocols and ports that we need.
* egress: no filters
* ingress: allow SSH from everywhere, SQL*Net ports from the VCN and ICMP from everywhere
```
# -----------------------------------------------
# Setup the Security List
# -----------------------------------------------
resource "oci_core_security_list" "demo-security-list" {
  display_name   = "demo-seclist"

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.demovcn.id

  # -------------------------------------------
  # Egress: Allow everything
  # -------------------------------------------
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }


  # -------------------------------------------
  # Ingress protocol 6: TCP
  # -------------------------------------------
  # Allow SSH from everywhere
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
  }

  # Allow SQL*Net communication within the VCN only
  ingress_security_rules {
    protocol = "6"
    source   = var.vcn_cidr
    tcp_options {
      min = 1521
      max = 1531
    }
  }

  # ------------------------------------------
  # protocol 1: ICMP: allow explicitly from subnet and everywhere
  # ------------------------------------------
  ingress_security_rules {
    protocol = 1
    source   = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = 1
    source   = var.subnet_cidr
  }
}

```

The new variable `subnet_cidr` has been added to `variables.tf`:
```
variable "subnet_cidr" {
  description = "CIDR block for the subnet."
  default = "10.0.0.0/24"
}
```

## Run the lab <a name="run"></a>
Apply the stack (run `plan` as well, not in this example):
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ terraform apply
oci_core_vcn.demovcn: Refreshing state... [id=ocid1.vcn.oc1.uk-london-1.amaaaaaaknuwtjiai6fi24b6daedzutlzfbyyw3w2dwhgzfun2imxxinsyka]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # oci_core_internet_gateway.demo-internet-gateway will be created
  + resource "oci_core_internet_gateway" "demo-internet-gateway" {
      + compartment_id = "ocid1.compartment.oc1..aaaaaaaa7d5txgtjrxbasote6czdn6vwpt2gn5tqhkbpyytqdmorr2jed6pa"
      + defined_tags   = (known after apply)
      + display_name   = "demo-igw"
      + enabled        = true
      + freeform_tags  = (known after apply)
      + id             = (known after apply)
      + state          = (known after apply)
      + time_created   = (known after apply)
      + vcn_id         = "ocid1.vcn.oc1.uk-london-1.amaaaaaaknuwtjiai6fi24b6daedzutlzfbyyw3w2dwhgzfun2imxxinsyka"
    }

  # oci_core_network_security_group.demo-network-security-group will be created
  + resource "oci_core_network_security_group" "demo-network-security-group" {
      + compartment_id = "ocid1.compartment.oc1..aaaaaaaa7d5txgtjrxbasote6czdn6vwpt2gn5tqhkbpyytqdmorr2jed6pa"
      + defined_tags   = (known after apply)
      + display_name   = "demo-nsg"
      + freeform_tags  = (known after apply)
      + id             = (known after apply)
      + state          = (known after apply)
      + time_created   = (known after apply)
      + vcn_id         = "ocid1.vcn.oc1.uk-london-1.amaaaaaaknuwtjiai6fi24b6daedzutlzfbyyw3w2dwhgzfun2imxxinsyka"
    }

  # oci_core_route_table.demo-public-rt will be created
  + resource "oci_core_route_table" "demo-public-rt" {
      + compartment_id = "ocid1.compartment.oc1..aaaaaaaa7d5txgtjrxbasote6czdn6vwpt2gn5tqhkbpyytqdmorr2jed6pa"
      + defined_tags   = (known after apply)
      + display_name   = "demo-routetable"
      + freeform_tags  = (known after apply)
      + id             = (known after apply)
      + state          = (known after apply)
      + time_created   = (known after apply)
      + vcn_id         = "ocid1.vcn.oc1.uk-london-1.amaaaaaaknuwtjiai6fi24b6daedzutlzfbyyw3w2dwhgzfun2imxxinsyka"

      + route_rules {
          + cidr_block        = (known after apply)
          + description       = (known after apply)
          + destination       = "0.0.0.0/0"
          + destination_type  = "CIDR_BLOCK"
          + network_entity_id = (known after apply)
        }
    }

  # oci_core_security_list.demo-security-list will be created
  + resource "oci_core_security_list" "demo-security-list" {
      + compartment_id = "ocid1.compartment.oc1..aaaaaaaa7d5txgtjrxbasote6czdn6vwpt2gn5tqhkbpyytqdmorr2jed6pa"
      + defined_tags   = (known after apply)
      + display_name   = "demo-seclist"
      + freeform_tags  = (known after apply)
      + id             = (known after apply)
      + state          = (known after apply)
      + time_created   = (known after apply)
      + vcn_id         = "ocid1.vcn.oc1.uk-london-1.amaaaaaaknuwtjiai6fi24b6daedzutlzfbyyw3w2dwhgzfun2imxxinsyka"

      + egress_security_rules {
          + description      = (known after apply)
          + destination      = "0.0.0.0/0"
          + destination_type = (known after apply)
          + protocol         = "all"
          + stateless        = (known after apply)
        }

      + ingress_security_rules {
          + description = (known after apply)
          + protocol    = "1"
          + source      = "0.0.0.0/0"
          + source_type = (known after apply)
          + stateless   = false
        }
      + ingress_security_rules {
          + description = (known after apply)
          + protocol    = "1"
          + source      = "10.0.0.0/24"
          + source_type = (known after apply)
          + stateless   = false
        }
      + ingress_security_rules {
          + description = (known after apply)
          + protocol    = "6"
          + source      = "0.0.0.0/0"
          + source_type = (known after apply)
          + stateless   = false

          + tcp_options {
              + max = 22
              + min = 22
            }
        }
      + ingress_security_rules {
          + description = (known after apply)
          + protocol    = "6"
          + source      = "10.0.0.0/16"
          + source_type = (known after apply)
          + stateless   = false

          + tcp_options {
              + max = 1531
              + min = 1521
            }
        }
    }

  # oci_core_subnet.demo-public-subnet will be created
  + resource "oci_core_subnet" "demo-public-subnet" {
      + availability_domain        = (known after apply)
      + cidr_block                 = "10.0.0.0/24"
      + compartment_id             = "ocid1.compartment.oc1..aaaaaaaa7d5txgtjrxbasote6czdn6vwpt2gn5tqhkbpyytqdmorr2jed6pa"
      + defined_tags               = (known after apply)
      + dhcp_options_id            = (known after apply)
      + display_name               = "demo-pubsubnet"
      + dns_label                  = "pub"
      + freeform_tags              = (known after apply)
      + id                         = (known after apply)
      + ipv6cidr_block             = (known after apply)
      + ipv6virtual_router_ip      = (known after apply)
      + prohibit_internet_ingress  = (known after apply)
      + prohibit_public_ip_on_vnic = (known after apply)
      + route_table_id             = (known after apply)
      + security_list_ids          = (known after apply)
      + state                      = (known after apply)
      + subnet_domain_name         = (known after apply)
      + time_created               = (known after apply)
      + vcn_id                     = "ocid1.vcn.oc1.uk-london-1.amaaaaaaknuwtjiai6fi24b6daedzutlzfbyyw3w2dwhgzfun2imxxinsyka"
      + virtual_router_ip          = (known after apply)
      + virtual_router_mac         = (known after apply)
    }

Plan: 5 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

oci_core_internet_gateway.demo-internet-gateway: Creating...
oci_core_network_security_group.demo-network-security-group: Creating...
oci_core_security_list.demo-security-list: Creating...
oci_core_internet_gateway.demo-internet-gateway: Creation complete after 1s [id=ocid1.internetgateway.oc1.uk-london-1.aaaaaaaaysidzuvfcpr74sixajjpofogs2lnvtnzsjfbx6yxokzr6ugp5byq]
oci_core_route_table.demo-public-rt: Creating...
oci_core_security_list.demo-security-list: Creation complete after 0s [id=ocid1.securitylist.oc1.uk-london-1.aaaaaaaa25fzqeohhsix26bi44kpexn7cgdjchbhsftzow5nqv4ogzqd3dvq]
oci_core_network_security_group.demo-network-security-group: Creation complete after 1s [id=ocid1.networksecuritygroup.oc1.uk-london-1.aaaaaaaajsf5fcjpjltt6bk6227l5mnpdqzkbf4ehf2ndwv432r2e556pqaq]
oci_core_route_table.demo-public-rt: Creation complete after 1s [id=ocid1.routetable.oc1.uk-london-1.aaaaaaaa2a5dacz323c6wuw7liogm4hcllsb7tkccqbs7ldsoirz4gi5mkca]
oci_core_subnet.demo-public-subnet: Creating...
oci_core_subnet.demo-public-subnet: Creation complete after 3s [id=ocid1.subnet.oc1.uk-london-1.aaaaaaaae7rjnngehlnllrt4665b2logspezs2d6ubxy3bzdqvnj5xggutma]

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.
```
All the network components have been created.

## Checkout the next lab <a name="next"></a>
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ git checkout lab4
Branch lab4 set up to track remote branch lab4 from origin.
Switched to a new branch 'lab4'
```
