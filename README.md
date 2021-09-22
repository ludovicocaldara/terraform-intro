# A gentle introduction to Terraform in OCI

This repository is a small tutorial to get you up to speed with Terraform and Oracle Cloud Infrastructure.
Terraform is a tool to manage your Cloud Infrastructure as Code.
To setup this tutorial, you need an OCI tenancy with some credits (either Free Trial or other).
__Please understand that spinning up resources in the Cloud with Terraform will cost you real money! Unless you use Always Free resources or you have Free Trial__

### OCI provider variables
Terraform uses the OCI APIs to inspect, create, modify and delete Cloud resources. Resources might be network components, compute instances, databases, services, users... anything that you can also create using the console or the `oci` commands.

When setting up the connection to a Cloud provider in Terraform, you usually need to pass a few variables:
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

Clone this repository:

```
ludovico_c@cloudshell:tmp (uk-london-1)$ git clone https://github.com/ludovicocaldara/terraform-intro.git
Cloning into 'terraform-intro'...
remote: Enumerating objects: 27, done.
remote: Counting objects: 100% (27/27), done.
remote: Compressing objects: 100% (15/15), done.
remote: Total 27 (delta 7), reused 25 (delta 5), pack-reused 0
Unpacking objects: 100% (27/27), done.
```

Print the list of labs:
```
ludovico_c@cloudshell:tmp (uk-london-1)$ git branch --list  
  lab0
  lab1
  lab2
  lab3
  lab4
  lab5
* main
```

Checkout the first lab's branch, `lab0` and read its README, you can switch to that branch also within the github.com website, it will be easier to read. :-)
```
ludovico_c@cloudshell:tmp (uk-london-1)$ git checkout lab0  
Branch lab0 set up to track remote branch lab0 from origin.
Switched to a new branch 'lab0'
```
