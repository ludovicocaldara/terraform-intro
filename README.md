# A gentle introduction to Terraform in OCI

## lab4: create an Autonomous Database



### New in this lab:



### Run the updated stack

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

Run `terraform init`
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

```
a
```


### To continue, switch to the lab5 branch:
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ git checkout lab5
Branch lab5 set up to track remote branch lab5 from origin.
Switched to a new branch 'lab5'
