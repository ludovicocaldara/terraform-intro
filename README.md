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


## Run the full terraform cycle: init, validate, plan, apply

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


