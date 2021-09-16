# A gentle introduction to Terraform in OCI

## lab1: set the compartment_id and collect some data
This lab introduce variables and data structures.

Terraform is meant to create resources in the Cloud, but it can also inspect the existing resources.
In this lab, we will use a data source (`data`) to get information about the compartment we want to work with.


### Switch to the lab1 branch:
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ git checkout lab1

### New in this lab:
The file data.tf contains a basic data source to gather information about the compartment:
```
data "oci_identity_compartment" "my_compartment" {
    id = var.compartment_id
    }
```
Data sources gather information about the environment, useful to create/maintain resources. This is somehow equivalent to gathering `facts` in other automation frameworks like `puppet` and `ansible`.


### Try to execute Terraform plan


## Get your compartment OCID
Access the Cloud Console, navigate to "Identity -> Compartment".

Create a Compartment from the console if you don't have one already, then select the compartment you want to work with and copy its OCID.



## Run validate, plan, apply

`terraform init` will download the required plugins:
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/oci...
- Installing hashicorp/oci v4.42.0...
- Installed hashicorp/oci v4.42.0 (unauthenticated)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

`terraform validate` performs a check of your Terraform file syntax:
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ terraform validate
Success! The configuration is valid.
```

`terraform plan` shows you what will be applied/modified if you run `terraform apply`:
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ terraform validate
Success! The configuration is valid.

ludovico_c@cloudshell:terraform-intro (uk-london-1)$ terraform plan

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.
```

Finally, `terraform apply` apply the changes. But for this first lab, we have no changes, this is just to ensure that everything is in place for that.
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ terraform apply

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```


