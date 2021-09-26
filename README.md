# lab8: Apply the stack with Resource Manager
1. [Description](#description)
2. [New in this lab](#new)
3. [Run the lab](#run)

## Description <a name="description"></a>
Using the Terraform command line is convenient if you deploy out of any CI/CD pipelines. You can increase the automation level by using Oracle Resource Manager, a Terraform service in the cloud, which can automate the stack execution, but most important it secures the Terraform state in your compartment. It exposes APIs which can be run with `oci` or directly by pipelines such as __GitHub Actions__.

## New in this lab <a name="new"></a>
In all files, the variable `compartment_id` has been changed to `compartment_ocid`. This is the name that is exposed in Resource Manager. It does not need to be specified otherwise.
```
-  compartment_id      = var.compartment_id
+  compartment_id      = var.compartment_ocid
```

Instead of specifying public and private SSH key, in `compute.tf` we use a new resource type: `tls_private_key`, that will create a key pair for the provisioning. This way, we don't need to expose any of out private keys but use a temporary one.

```
resource "tls_private_key" "provisioner_keypair" {
  algorithm   = "RSA"
  rsa_bits = "4096"
}
```

We'll use it in the compute instance specification as:
``` 
    ssh_authorized_keys = "${tls_private_key.provisioner_keypair.public_key_openssh}"
    private_key = tls_private_key.provisioner_keypair.private_key_pem
```

A new file `schema.yaml` contains the definition of the stack for Resource Manager. This file specify some attributes and the variables that could be overwritten (or hidden) by the service.
```
title: Terraform Intro
description: Demo for the Oracle Resource Manager
stackDescription: "Deploy ADB, Compute and Networking resources"
schemaVersion: 1.1.0
version: "20210925"
locale: "en"

source:
  type: image

outputGroups:
  - title: Access Information for Compute and ADB
    outputs:
      - ${demo_vm}
      - ${adb}

variableGroups:
  - title: Tenancy Configuration
    visible: false
    variables:
    - tenancy_ocid
    - region
    - compartment_ocid

variables:
  compartment_ocid:
    type: oci:identity:compartment:id
    required: true
    title: Compartment
    description: "Compartment where you want to create the FPP target and server"

  region:
    type: oci:identity:region:name
    required: true
    title: Region
    description: Region where you want to deploy the resources defined by this stack

outputs:
  adb:
    type: string
    title: Autonomous Database access
    displayText: Autonomous Database link to Database Actions
    visible: true

  demo_vm:
    type: string
    title: Compute instance access
    displayText: Public IP of the compute instance
    visible: true
```

## Run the lab <a name="run"></a>
Close the Cloud Shell and go to __Menu__ - __Developer Services__ - __Resource Manager__.
In __Stack__, create a new stack, specify __My configuration__, upload this zip file: https://github.com/ludovicocaldara/terraform-intro/archive/refs/heads/lab8.zip .
You could connect Resource Manager directly to GitHub, but this requires a Personal Auth Token for the repository. Click next and validate the creation of the stack. Then, you can plan and apply the stack, see the logs, the variables, resources, output, all in a convenient OCI Console windows.

If you integrate with GitHub, you can also insert the stack execution in a GitHub workflow, as explained by Todd Sharp here: 
https://blogs.oracle.com/developers/post/iac-in-the-cloud-integrating-terraform-and-resource-manager-into-your-cicd-pipeline-building-with-the-oci-cli

This is the end of this Terraform workshop. I hope you find is useful!
