# A gentle introduction to Terraform in OCI

## lab1: set the compartment_id and collect some data
This lab introduce variables and data structures.

Terraform is meant to create resources in the Cloud, but it can also inspect the existing resources.
In this lab, we will use a data source (`data`) to get information about the compartment we want to work with.


### Switch to the lab1 branch:
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ git checkout lab1

### New in this lab:
The file `data.tf` contains a basic data source to gather information about the compartment:
```
data "oci_identity_compartment" "my_compartment" {
    id = var.compartment_id
    }
```
Data sources gather information about the environment, useful to create/maintain resources. This is somehow equivalent to gathering `facts` in other automation frameworks like `puppet` and `ansible`.

Because the data source requires an `id`, we will use a variable for that (we don't want to put our OCID in git, do we?), so we start keeping track of the variables, in this case we'll use a separate file for that. Please note that all the terraform configuration could be put in a single file, but it's better to keep them separated for readability.
`variables.tf` contains the declaration of the variable:
```
variable "compartment_id" {
  description = "The OCID of the compartment you want to work with."
}
```

### Try to execute terraform validate and plan
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ terraform validate
Success! The configuration is valid.
```

The validation of the code is OK, but the plan asks for a variable:
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ terraform plan
var.compartment_id
  The OCID of the compartment you want to work with.

  Enter a value: 
```
You can hit `^C` and stop the execution at this point.
We could copy&paste the OCID here, but we would have to repeat this for every execution. So there are two neater solutions:
1. Use an `override.tf` file that contains our values. This `override.tf` is ignored by `.gitignore`, so that it won't be stored in the `git` repository.
2. Use an environment variable. When Terraform looks for a variable value and cannot find it, it looks for an environment variables named `TF_VAR_name`.

Both methods are valid. For simplicity, we'll just use the second.

Access the Cloud Console, navigate to "Identity -> Compartment".
Create a Compartment from the console if you don't have one already, then select the compartment you want to work with and copy its OCID.

```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ echo "export TF_VAR_compartment_id=<YOUR_COMPARTMENT_OCID>" >> ~/.bashrc
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ . ~/.bashrc
```

The next execution of `terraform plan` will succeed:
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ terraform plan

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.
```
Now the apply:
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ terraform apply

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

### Get the data source information
Use `terraform show` for this.
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ terraform show
# data.oci_identity_compartment.my_compartment:
data "oci_identity_compartment" "my_compartment" {
    compartment_id = "ocid1.compartment.oc1..aaaaaaaasrhvy32rogjwlnf77vwwb7hetdt7vng7lt7cr3cat26h7ffovuoa"
    defined_tags   = {
        "Administration.Creator" = "ludovico.caldara@oracle.com"
    }
    description    = "Terraform demo for SPOUG"
    freeform_tags  = {}
    id             = "ocid1.compartment.oc1..aaaaaaaa7d5txgtjrxbasote6czdn6vwpt2gn5tqhkbpyytqdmorr2jed6pa"
    is_accessible  = true
    name           = "terraform-demo"
    state          = "ACTIVE"
    time_created   = "2021-09-14 10:09:05.245 +0000 UTC"
}
```
The status of the resources and data sources is stored in the file `terraform.tfstate`.
