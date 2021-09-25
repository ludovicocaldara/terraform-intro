## lab6: Customize the Compute Instance
1. [Description](#description)
2. [New in this lab](#new)
3. [Run the lab](#run)
4. [Checkout the next lab](#next)

## Description <a name="description"></a>
Privisioning new compute instances is cool, but what if we want to customize them? The `remote-exec` provisioner allows to execute remote commands on the target compute instance. For that, you have to specify the private key corresponding to one of the public keys that have been added at instance creation.

In this lab we will install `oracle-instantclient` and `nginx`.


## New in this lab <a name="new"></a>
There is a new resource of type `null_resource` in `compute.tf` which will require a new `terraform init`:
```
resource "null_resource" "nginx_setup" {
  depends_on = [oci_core_instance.demo_vm]
  provisioner "remote-exec" {
    connection  {
      type        = "ssh"
      host        = oci_core_instance.demo_vm.public_ip
      agent       = false
      timeout     = "5m"
      user        = "opc"
      private_key = file(var.ssh_private_key_file)
    }
    inline = [ "sudo dnf install -y oracle-instantclient-release-el8 nginx" ]
  }
}
```
Null resources are used to execute provisioners and constructs which don't fall under any specific resource type.
There is a new variable, `ssh_private_key_file` which we have to declare in `variables.tf`:
```
variable "ssh_private_key_file" {
  description = "public ssh key to connect to the compute instance"
}
```
We don't want to put the private key in our environment, so we read it from the specified path.
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ echo export TF_VAR_ssh_private_key_file=$HOME/.ssh/id_rsa' >> ~/.bashrc
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ . ~/.bashrc
```


## Run the lab <a name="run"></a>
Run `terraform init`, then the plan and the apply (you start getting used to it :-)). If everything is set properly, that should work:
```
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ terraform apply
random_password.adb_password: Refreshing state... [id=none]
oci_core_vcn.demovcn: Refreshing state... [id=ocid1.vcn.oc1.uk-london-1.amaaaaaaknuwtjiano6v5uj2afotp3ncddyyljiew4bwolcvcwph77whltqq]
oci_database_autonomous_database.demo_adb: Refreshing state... [id=ocid1.autonomousdatabase.oc1.uk-london-1.anwgiljtknuwtjiacpoqsg5a7wfk5qtxs5fnsi4e2udipu2uq4kbym634xha]
oci_core_network_security_group.demo-network-security-group: Refreshing state... [id=ocid1.networksecuritygroup.oc1.uk-london-1.aaaaaaaaaku7m6jurchqwh3skgr37uqhemrya24fz5rbgplwiaijf7yle2tq]
oci_core_internet_gateway.demo-internet-gateway: Refreshing state... [id=ocid1.internetgateway.oc1.uk-london-1.aaaaaaaa3za5j5f245qvnngxz2fe27e7ws2uwk6mspcexp64umgpxetb2tya]
oci_core_security_list.demo-security-list: Refreshing state... [id=ocid1.securitylist.oc1.uk-london-1.aaaaaaaawzkhszob5q5qosn2becvxao5pso5kzpjk3qrlyv6z4xantp5ixja]
oci_core_route_table.demo-public-rt: Refreshing state... [id=ocid1.routetable.oc1.uk-london-1.aaaaaaaa3ez6t4jf76jpmv3bmmj7naeihbg2am6ow3u4aa425neyuizmu4aq]
oci_core_subnet.demo-public-subnet: Refreshing state... [id=ocid1.subnet.oc1.uk-london-1.aaaaaaaanralbjcrmoeulvxpmktglvfqzchdmsrisgj6ejt45ulavub3dy4a]
oci_core_instance.demo_vm: Refreshing state... [id=ocid1.instance.oc1.uk-london-1.anwgiljrknuwtjicg6q47cycxqtfu6pmx4caeplnabpfgr27bec3tkxgepea]
null_resource.nginx_setup: Refreshing state... [id=7077534161748189185]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # null_resource.nginx_setup is tainted, so must be replaced
-/+ resource "null_resource" "nginx_setup" {
      ~ id = "7077534161748189185" -> (known after apply)
    }

Plan: 1 to add, 0 to change, 1 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

null_resource.nginx_setup: Destroying... [id=7077534161748189185]
null_resource.nginx_setup: Destruction complete after 0s
null_resource.nginx_setup: Creating...
null_resource.nginx_setup: Provisioning with 'remote-exec'...
null_resource.nginx_setup (remote-exec): Connecting to remote host via SSH...
null_resource.nginx_setup (remote-exec):   Host: 140.238.91.214
null_resource.nginx_setup (remote-exec):   User: opc
null_resource.nginx_setup (remote-exec):   Password: false
null_resource.nginx_setup (remote-exec):   Private key: true
null_resource.nginx_setup (remote-exec):   Certificate: false
null_resource.nginx_setup (remote-exec):   SSH Agent: false
null_resource.nginx_setup (remote-exec):   Checking Host Key: false
null_resource.nginx_setup (remote-exec):   Target Platform: unix
null_resource.nginx_setup (remote-exec): Connected!
null_resource.nginx_setup (remote-exec): Last metadata expiration check: 0:40:02 ago on Sat 25 Sep 2021 01:12:03 PM GMT.
null_resource.nginx_setup (remote-exec): Dependencies resolved.
null_resource.nginx_setup (remote-exec): ========================================
null_resource.nginx_setup (remote-exec):  Package Arch   Version
null_resource.nginx_setup (remote-exec):                     Repository     Size
null_resource.nginx_setup (remote-exec): ========================================
null_resource.nginx_setup (remote-exec): Installing:
null_resource.nginx_setup (remote-exec):  nginx   x86_64 1:1.14.1-9.0.1.module+el8.0.0+5347+9282027e
null_resource.nginx_setup (remote-exec):                     ol8_appstream 569 k
null_resource.nginx_setup (remote-exec):  oracle-instantclient-release-el8
null_resource.nginx_setup (remote-exec):          x86_64 1.0-1.el8
null_resource.nginx_setup (remote-exec):                     ol8_baseos_latest
null_resource.nginx_setup (remote-exec):                                    16 k
null_resource.nginx_setup (remote-exec): Installing dependencies:
null_resource.nginx_setup (remote-exec):  fontconfig
null_resource.nginx_setup (remote-exec):          x86_64 2.13.1-3.el8
null_resource.nginx_setup (remote-exec):                     ol8_baseos_latest
null_resource.nginx_setup (remote-exec):                                   274 k
null_resource.nginx_setup (remote-exec):  gd      x86_64 2.2.5-7.el8
null_resource.nginx_setup (remote-exec):                     ol8_appstream 144 k
null_resource.nginx_setup (remote-exec):  jbigkit-libs
null_resource.nginx_setup (remote-exec):          x86_64 2.1-14.el8
null_resource.nginx_setup (remote-exec):                     ol8_appstream  55 k
null_resource.nginx_setup (remote-exec):  libX11  x86_64 1.6.8-4.el8
null_resource.nginx_setup (remote-exec):                     ol8_appstream 611 k
null_resource.nginx_setup (remote-exec):  libX11-common
null_resource.nginx_setup (remote-exec):          noarch 1.6.8-4.el8
null_resource.nginx_setup (remote-exec):                     ol8_appstream 158 k
null_resource.nginx_setup (remote-exec):  libXau  x86_64 1.0.9-3.el8
null_resource.nginx_setup (remote-exec):                     ol8_appstream  37 k
null_resource.nginx_setup (remote-exec):  libXpm  x86_64 3.5.12-8.el8
null_resource.nginx_setup (remote-exec):                     ol8_appstream  58 k
null_resource.nginx_setup (remote-exec):  libjpeg-turbo
null_resource.nginx_setup (remote-exec):          x86_64 1.5.3-10.el8
null_resource.nginx_setup (remote-exec):                     ol8_appstream 155 k
null_resource.nginx_setup (remote-exec):  libtiff x86_64 4.0.9-18.el8
null_resource.nginx_setup (remote-exec):                     ol8_appstream 188 k
null_resource.nginx_setup (remote-exec):  libwebp x86_64 1.0.0-3.el8_4
null_resource.nginx_setup (remote-exec):                     ol8_appstream 272 k
null_resource.nginx_setup (remote-exec):  libxcb  x86_64 1.13.1-1.el8
null_resource.nginx_setup (remote-exec):                     ol8_appstream 231 k
null_resource.nginx_setup (remote-exec):  libxslt x86_64 1.1.32-6.0.1.el8
null_resource.nginx_setup (remote-exec):                     ol8_baseos_latest
null_resource.nginx_setup (remote-exec):                                   250 k
null_resource.nginx_setup (remote-exec):  nginx-all-modules
null_resource.nginx_setup (remote-exec):          noarch 1:1.14.1-9.0.1.module+el8.0.0+5347+9282027e
null_resource.nginx_setup (remote-exec):                     ol8_appstream  24 k
null_resource.nginx_setup (remote-exec):  nginx-filesystem
null_resource.nginx_setup (remote-exec):          noarch 1:1.14.1-9.0.1.module+el8.0.0+5347+9282027e
null_resource.nginx_setup (remote-exec):                     ol8_appstream  25 k
null_resource.nginx_setup (remote-exec):  nginx-mod-http-image-filter
null_resource.nginx_setup (remote-exec):          x86_64 1:1.14.1-9.0.1.module+el8.0.0+5347+9282027e
null_resource.nginx_setup (remote-exec):                     ol8_appstream  35 k
null_resource.nginx_setup (remote-exec):  nginx-mod-http-perl
null_resource.nginx_setup (remote-exec):          x86_64 1:1.14.1-9.0.1.module+el8.0.0+5347+9282027e
null_resource.nginx_setup (remote-exec):                     ol8_appstream  46 k
null_resource.nginx_setup (remote-exec):  nginx-mod-http-xslt-filter
null_resource.nginx_setup (remote-exec):          x86_64 1:1.14.1-9.0.1.module+el8.0.0+5347+9282027e
null_resource.nginx_setup (remote-exec):                     ol8_appstream  34 k
null_resource.nginx_setup (remote-exec):  nginx-mod-mail
null_resource.nginx_setup (remote-exec):          x86_64 1:1.14.1-9.0.1.module+el8.0.0+5347+9282027e
null_resource.nginx_setup (remote-exec):                     ol8_appstream  64 k
null_resource.nginx_setup (remote-exec):  nginx-mod-stream
null_resource.nginx_setup (remote-exec):          x86_64 1:1.14.1-9.0.1.module+el8.0.0+5347+9282027e
null_resource.nginx_setup (remote-exec):                     ol8_appstream  86 k
null_resource.nginx_setup (remote-exec): Enabling module streams:
null_resource.nginx_setup (remote-exec):  nginx          1.14


null_resource.nginx_setup (remote-exec): Transaction Summary
null_resource.nginx_setup (remote-exec): ========================================
null_resource.nginx_setup (remote-exec): Install  21 Packages

null_resource.nginx_setup (remote-exec): Total download size: 3.3 M
null_resource.nginx_setup (remote-exec): Installed size: 9.8 M
null_resource.nginx_setup (remote-exec): Downloading Packages:
null_resource.nginx_setup (remote-exec): (1/21): ---  B/s |   0  B     --:-- ETA
null_resource.nginx_setup (remote-exec): (1/21): 4.0 MB/s | 274 kB     00:00
null_resource.nginx_setup (remote-exec): (2-3/21 4.0 MB/s | 274 kB     00:00 ETA
null_resource.nginx_setup (remote-exec): (2/21): 196 kB/s |  16 kB     00:00
null_resource.nginx_setup (remote-exec): (3-4/21 4.0 MB/s | 290 kB     00:00 ETA
null_resource.nginx_setup (remote-exec): (3/21): 1.8 MB/s | 144 kB     00:00
null_resource.nginx_setup (remote-exec): (4-5/21 4.0 MB/s | 434 kB     00:00 ETA
null_resource.nginx_setup (remote-exec): (4/21): 735 kB/s |  55 kB     00:00
null_resource.nginx_setup (remote-exec): (5-6/21 4.0 MB/s | 489 kB     00:00 ETA
null_resource.nginx_setup (remote-exec): (5/21): 1.3 MB/s | 250 kB     00:00
null_resource.nginx_setup (remote-exec): (6-7/21 4.0 MB/s | 738 kB     00:00 ETA
null_resource.nginx_setup (remote-exec): (6/21): 1.4 MB/s |  37 kB     00:00
null_resource.nginx_setup (remote-exec): (7-8/21 4.0 MB/s | 776 kB     00:00 ETA
null_resource.nginx_setup (remote-exec): (7/21): 2.2 MB/s | 158 kB     00:00
null_resource.nginx_setup (remote-exec): (8-9/21 4.0 MB/s | 934 kB     00:00 ETA
null_resource.nginx_setup (remote-exec): (8/21): 991 kB/s |  58 kB     00:00
null_resource.nginx_setup (remote-exec): (9-10/2 4.0 MB/s | 992 kB     00:00 ETA
null_resource.nginx_setup (remote-exec): (9/21): 4.2 MB/s | 611 kB     00:00
null_resource.nginx_setup (remote-exec): (10-11/ 4.1 MB/s | 1.6 MB     00:00 ETA
null_resource.nginx_setup (remote-exec): (10/21) 2.2 MB/s | 155 kB     00:00
null_resource.nginx_setup (remote-exec): (11-12/ 4.1 MB/s | 1.7 MB     00:00 ETA
null_resource.nginx_setup (remote-exec): (11/21) 2.7 MB/s | 188 kB     00:00
null_resource.nginx_setup (remote-exec): (12-13/ 4.1 MB/s | 1.9 MB     00:00 ETA
null_resource.nginx_setup (remote-exec): (12/21) 4.8 MB/s | 272 kB     00:00
null_resource.nginx_setup (remote-exec): (13-14/ 4.2 MB/s | 2.2 MB     00:00 ETA
null_resource.nginx_setup (remote-exec): (13/21) 3.5 MB/s | 231 kB     00:00
null_resource.nginx_setup (remote-exec): (14-15/ 4.2 MB/s | 2.4 MB     00:00 ETA
null_resource.nginx_setup (remote-exec): (14/21) 784 kB/s |  24 kB     00:00
null_resource.nginx_setup (remote-exec): (15-16/ 4.2 MB/s | 2.4 MB     00:00 ETA
null_resource.nginx_setup (remote-exec): (15/21) 8.6 MB/s | 569 kB     00:00
null_resource.nginx_setup (remote-exec): (16-17/ 4.3 MB/s | 3.0 MB     00:00 ETA
null_resource.nginx_setup (remote-exec): (16/21) 401 kB/s |  25 kB     00:00
null_resource.nginx_setup (remote-exec): (17-18/ 4.3 MB/s | 3.0 MB     00:00 ETA
null_resource.nginx_setup (remote-exec): (17/21) 448 kB/s |  35 kB     00:00
null_resource.nginx_setup (remote-exec): (18-19/ 4.3 MB/s | 3.0 MB     00:00 ETA
null_resource.nginx_setup (remote-exec): (18/21) 769 kB/s |  46 kB     00:00
null_resource.nginx_setup (remote-exec): (19-20/ 4.3 MB/s | 3.1 MB     00:00 ETA
null_resource.nginx_setup (remote-exec): (19/21) 738 kB/s |  34 kB     00:00
null_resource.nginx_setup (remote-exec): (20-21/ 4.3 MB/s | 3.1 MB     00:00 ETA
null_resource.nginx_setup (remote-exec): (20/21) 750 kB/s |  64 kB     00:00
null_resource.nginx_setup (remote-exec): (21/21) 4.2 MB/s | 3.2 MB     00:00 ETA
null_resource.nginx_setup (remote-exec): (21/21) 1.0 MB/s |  86 kB     00:00
null_resource.nginx_setup (remote-exec): ----------------------------------------
null_resource.nginx_setup (remote-exec): Total   5.9 MB/s | 3.3 MB     00:00
null_resource.nginx_setup (remote-exec): Running transaction check
null_resource.nginx_setup (remote-exec): Transaction check succeeded.
null_resource.nginx_setup (remote-exec): Running transaction test
null_resource.nginx_setup (remote-exec): Transaction test succeeded.
null_resource.nginx_setup (remote-exec): Running transaction
null_resource.nginx_setup (remote-exec):   Preparing        :  [           ] 1/1
null_resource.nginx_setup (remote-exec):   Preparing        :  [=          ] 1/1
null_resource.nginx_setup (remote-exec):   Preparing        :  [==         ] 1/1
null_resource.nginx_setup (remote-exec):   Preparing        :  [===        ] 1/1
null_resource.nginx_setup (remote-exec):   Preparing        :  [====       ] 1/1
null_resource.nginx_setup (remote-exec):   Preparing        :  [=====      ] 1/1
null_resource.nginx_setup (remote-exec):   Preparing        :  [======     ] 1/1
null_resource.nginx_setup (remote-exec):   Preparing        :  [=======    ] 1/1
null_resource.nginx_setup (remote-exec):   Preparing        :  [========   ] 1/1
null_resource.nginx_setup (remote-exec):   Preparing        :  [=========  ] 1/1
null_resource.nginx_setup (remote-exec):   Preparing        :  [========== ] 1/1
null_resource.nginx_setup (remote-exec):   Preparing        :                1/1
null_resource.nginx_setup (remote-exec):   Installing       : libj   1/21
null_resource.nginx_setup (remote-exec):   Installing       : libjpeg-tu    1/21
null_resource.nginx_setup (remote-exec):   Running scriptlet: nginx-file    2/21
null_resource.nginx_setup (remote-exec):   Installing       : ngin   2/21
null_resource.nginx_setup (remote-exec):   Installing       : nginx-file    2/21
null_resource.nginx_setup (remote-exec):   Installing       : libw   3/21
null_resource.nginx_setup (remote-exec):   Installing       : libwebp-1.    3/21
null_resource.nginx_setup (remote-exec):   Installing       : libX   4/21
null_resource.nginx_setup (remote-exec):   Installing       : libXau-1.0    4/21
null_resource.nginx_setup (remote-exec):   Installing       : libx   5/21
null_resource.nginx_setup (remote-exec):   Installing       : libxcb-1.1    5/21
null_resource.nginx_setup (remote-exec):   Installing       : libX   6/21
null_resource.nginx_setup (remote-exec):   Installing       : libX11-com    6/21
null_resource.nginx_setup (remote-exec):   Installing       : libX   7/21
null_resource.nginx_setup (remote-exec):   Installing       : libX11-1.6    7/21
null_resource.nginx_setup (remote-exec):   Installing       : libX   8/21
null_resource.nginx_setup (remote-exec):   Installing       : libXpm-3.5    8/21
null_resource.nginx_setup (remote-exec):   Installing       : jbig   9/21
null_resource.nginx_setup (remote-exec):   Installing       : jbigkit-li    9/21
null_resource.nginx_setup (remote-exec):   Running scriptlet: jbigkit-li    9/21
null_resource.nginx_setup (remote-exec):   Installing       : libt  10/21
null_resource.nginx_setup (remote-exec):   Installing       : libtiff-4.   10/21
null_resource.nginx_setup (remote-exec):   Installing       : libx  11/21
null_resource.nginx_setup (remote-exec):   Installing       : libxslt-1.   11/21
null_resource.nginx_setup (remote-exec):   Installing       : font  12/21
null_resource.nginx_setup (remote-exec):   Installing       : fontconfig   12/21
null_resource.nginx_setup (remote-exec):   Running scriptlet: fontconfig   12/21
null_resource.nginx_setup (remote-exec):   Installing       : gd-2  13/21
null_resource.nginx_setup (remote-exec):   Installing       : gd-2.2.5-7   13/21
null_resource.nginx_setup (remote-exec):   Running scriptlet: gd-2.2.5-7   13/21
null_resource.nginx_setup (remote-exec):   Installing       : ngin  14/21
null_resource.nginx_setup (remote-exec):   Installing       : nginx-mod-   14/21
null_resource.nginx_setup (remote-exec):   Running scriptlet: nginx-mod-   14/21
null_resource.nginx_setup (remote-exec):   Installing       : ngin  15/21
null_resource.nginx_setup (remote-exec):   Installing       : nginx-mod-   15/21
null_resource.nginx_setup (remote-exec):   Running scriptlet: nginx-mod-   15/21
null_resource.nginx_setup (remote-exec):   Installing       : ngin  16/21
null_resource.nginx_setup (remote-exec):   Installing       : nginx-mod-   16/21
null_resource.nginx_setup (remote-exec):   Running scriptlet: nginx-mod-   16/21
null_resource.nginx_setup (remote-exec):   Installing       : ngin  17/21
null_resource.nginx_setup (remote-exec):   Installing       : nginx-mod-   17/21
null_resource.nginx_setup (remote-exec):   Running scriptlet: nginx-mod-   17/21
null_resource.nginx_setup (remote-exec):   Installing       : ngin  18/21
null_resource.nginx_setup (remote-exec):   Installing       : nginx-1:1.   18/21
null_resource.nginx_setup (remote-exec):   Running scriptlet: nginx-1:1.   18/21
null_resource.nginx_setup (remote-exec):   Installing       : ngin  19/21
null_resource.nginx_setup (remote-exec):   Installing       : nginx-mod-   19/21
null_resource.nginx_setup (remote-exec):   Running scriptlet: nginx-mod-   19/21
null_resource.nginx_setup (remote-exec):   Installing       : ngin  20/21
null_resource.nginx_setup (remote-exec):   Installing       : nginx-all-   20/21
null_resource.nginx_setup (remote-exec):   Installing       : orac  21/21
null_resource.nginx_setup (remote-exec):   Installing       : oracle-ins   21/21
null_resource.nginx_setup (remote-exec):   Running scriptlet: oracle-ins   21/21
null_resource.nginx_setup: Still creating... [10s elapsed]
null_resource.nginx_setup (remote-exec):   Running scriptlet: fontconfig   21/21
null_resource.nginx_setup (remote-exec):   Verifying        : fontconfig    1/21
null_resource.nginx_setup (remote-exec):   Verifying        : libxslt-1.    2/21
null_resource.nginx_setup (remote-exec):   Verifying        : oracle-ins    3/21
null_resource.nginx_setup (remote-exec):   Verifying        : gd-2.2.5-7    4/21
null_resource.nginx_setup (remote-exec):   Verifying        : jbigkit-li    5/21
null_resource.nginx_setup (remote-exec):   Verifying        : libX11-1.6    6/21
null_resource.nginx_setup (remote-exec):   Verifying        : libX11-com    7/21
null_resource.nginx_setup (remote-exec):   Verifying        : libXau-1.0    8/21
null_resource.nginx_setup (remote-exec):   Verifying        : libXpm-3.5    9/21
null_resource.nginx_setup (remote-exec):   Verifying        : libjpeg-tu   10/21
null_resource.nginx_setup (remote-exec):   Verifying        : libtiff-4.   11/21
null_resource.nginx_setup (remote-exec):   Verifying        : libwebp-1.   12/21
null_resource.nginx_setup (remote-exec):   Verifying        : libxcb-1.1   13/21
null_resource.nginx_setup (remote-exec):   Verifying        : nginx-1:1.   14/21
null_resource.nginx_setup (remote-exec):   Verifying        : nginx-all-   15/21
null_resource.nginx_setup (remote-exec):   Verifying        : nginx-file   16/21
null_resource.nginx_setup (remote-exec):   Verifying        : nginx-mod-   17/21
null_resource.nginx_setup (remote-exec):   Verifying        : nginx-mod-   18/21
null_resource.nginx_setup (remote-exec):   Verifying        : nginx-mod-   19/21
null_resource.nginx_setup (remote-exec):   Verifying        : nginx-mod-   20/21
null_resource.nginx_setup (remote-exec):   Verifying        : nginx-mod-   21/21

null_resource.nginx_setup (remote-exec): Installed:
null_resource.nginx_setup (remote-exec):   fontconfig-2.13.1-3.el8.x86_64
null_resource.nginx_setup (remote-exec):   gd-2.2.5-7.el8.x86_64
null_resource.nginx_setup (remote-exec):   jbigkit-libs-2.1-14.el8.x86_64
null_resource.nginx_setup (remote-exec):   libX11-1.6.8-4.el8.x86_64
null_resource.nginx_setup (remote-exec):   libX11-common-1.6.8-4.el8.noarch
null_resource.nginx_setup (remote-exec):   libXau-1.0.9-3.el8.x86_64
null_resource.nginx_setup (remote-exec):   libXpm-3.5.12-8.el8.x86_64
null_resource.nginx_setup (remote-exec):   libjpeg-turbo-1.5.3-10.el8.x86_64
null_resource.nginx_setup (remote-exec):   libtiff-4.0.9-18.el8.x86_64
null_resource.nginx_setup (remote-exec):   libwebp-1.0.0-3.el8_4.x86_64
null_resource.nginx_setup (remote-exec):   libxcb-1.13.1-1.el8.x86_64
null_resource.nginx_setup (remote-exec):   libxslt-1.1.32-6.0.1.el8.x86_64
null_resource.nginx_setup (remote-exec):   nginx-1:1.14.1-9.0.1.module+el8.0.0+5347+9282027e.x86_64
null_resource.nginx_setup (remote-exec):   nginx-all-modules-1:1.14.1-9.0.1.module+el8.0.0+5347+9282027e.noarch
null_resource.nginx_setup (remote-exec):   nginx-filesystem-1:1.14.1-9.0.1.module+el8.0.0+5347+9282027e.noarch
null_resource.nginx_setup (remote-exec):   nginx-mod-http-image-filter-1:1.14.1-9.0.1.module+el8.0.0+5347+9282027e.x86_64
null_resource.nginx_setup (remote-exec):   nginx-mod-http-perl-1:1.14.1-9.0.1.module+el8.0.0+5347+9282027e.x86_64
null_resource.nginx_setup (remote-exec):   nginx-mod-http-xslt-filter-1:1.14.1-9.0.1.module+el8.0.0+5347+9282027e.x86_64
null_resource.nginx_setup (remote-exec):   nginx-mod-mail-1:1.14.1-9.0.1.module+el8.0.0+5347+9282027e.x86_64
null_resource.nginx_setup (remote-exec):   nginx-mod-stream-1:1.14.1-9.0.1.module+el8.0.0+5347+9282027e.x86_64
null_resource.nginx_setup (remote-exec):   oracle-instantclient-release-el8-1.0-1.el8.x86_64

null_resource.nginx_setup (remote-exec): Complete!
null_resource.nginx_setup: Creation complete after 11s [id=225294201386725243]

Apply complete! Resources: 1 added, 0 changed, 1 destroyed.
```
... and we have now our compute instance with the required packages!

## Checkout the next lab <a name="next"></a>
ludovico_c@cloudshell:terraform-intro (uk-london-1)$ git checkout lab7
Branch lab7 set up to track remote branch lab7 from origin.
Switched to a new branch 'lab7'
