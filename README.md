# A gentle introduction to Terraform in OCI

## lab0: setup the empty OCI provider
This lab is just to show you how to run a basic `terraform` command.

### New in this Lab
The file `provider.tf` contains a basic provider entry:
```
# -------------------------
# Setup the OCI provider...
# -------------------------
provider "oci" {
}
```

### OCI provider variables
When setting up a Cloud provider in Terraform, you usually need to pass a few variables:
* Your User's OCID
* Your PEM key to access the API endpoint
* The Fingerprint of your Auth API key
* Your Tenancy's OCID
* Your Region's identifier
* Your Compartment's ID

When using `terraform` from the OCI Cloud Shell, most of these informations are not needed, as they are pre-configured for you.

### Access the OCI Cloud Shell
Login to your OCI console and click on the __Cloud Shell__ icon  on the top-right of the console, next to the region selection.

The OCI Cloud Shell has `git` and `terraform` commands already installed:
```
ludovico_c@cloudshell:~ (uk-london-1)$ git version
git version 1.8.3.1
```
```
ludovico_c@cloudshell:~ (uk-london-1)$ terraform version
Terraform v1.0.6
on linux_amd64
```



