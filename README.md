# Terraform modules to create Ec2, S3, ELB, and Subnets
```- Create an s3 bucket - test_bucket
 - Assume that given a VPC ID - create 2 subnets - subnet_1 and subnet_2 - choose any cidr
 - Create a policy which gives EC2 write access to test_bucket - test_policy
 - Create a role to which test_policy is attached - test_role
 - Create a security group which allows all incoming 443 and all outgoing internet traffic - test_sg_1
 - Create an ELB with health check - /health on port 443 of the instances behind it - test_elb
 - Create an EC2 instance with - subnet_1, test_role and test_sg_1 and add it to test_elb - choose any EC2 instance type. Think of what best practices you would use to create this instance.
 - Tag all of the above infra with key "product_id" value "test_product"
 - Save state in S3 - use a bucket name that you think would make sense.

 - Abstract the above code in a Terraform module
 - Write and version your module in such a way that the same module can be used to deploy to 3 environments - dev, stage and prod by just changing the variables.
```
>Terraform version = v0.12.18

To achieve the goal, two solutions have been provided in this repository.
1. terraform-solution-1
2. terraform-solution-2

## Difference between both the solution:
1. **terraform-solution-1**
- Separate **main.tf** & **modules** for each service(ec2, elb, s3, subnets). All the modules are in the common-mods directory and the service directory has the main.tf and environment-specific tf.vars and backend.tf file.

 i.e:
```
/terraform-solution-1(test)$ ls -l
common-mods
services

/terraform-solution-1(test)$ ls -l common-mods/
alb
ec2
envconfig.sh
network
s3

/terraform-solution-1(test)$ ls -l services/
alb
ec2
network
s3
```

Run each module separately from solution-1 in the following sequence - network > s3 > ec2 > alb.
To create an infra for the dev environment, there is a script provided under the common-mods directory to set up config for the dev environment.

This script creates a symlink between your environment-specific **terraform.tfvars.dev** with default **terraform.tfvars** also **backend.tf.dev** with **backend.tf**

e.g: To create an s3 bucket for the dev environment:-
```
-$ cd terraform-solution-1/services/s3/
-$ ../../common-mods/envconfig.sh dev
-$ ls -la
-$ lrwxrwxrwx 1 bhushan bhushan   14 May 30 00:46 backend.tf -> backend.tf.dev
-$ rw-rw-r-- 1 bhushan bhushan  128 May 30 00:04 backend.tf.dev
-$ rw-rw-r-- 1 bhushan bhushan  130 May 30 00:04 backend.tf.prod
-$ rw-rw-r-- 1 bhushan bhushan  132 May 29 21:45 backend.tf.stage
-$ rw-rw-r-- 1 bhushan bhushan  204 May 29 21:45 main.tf
-$ rwxrwxrwx 1 bhushan bhushan   20 May 30 00:46 terraform.tfvars -> terraform.tfvars.dev
-$ rw-rw-r-- 1 bhushan bhushan  185 May 30 00:05 terraform.tfvars.dev
-$ rw-rw-r-- 1 bhushan bhushan  186 May 30 00:05 terraform.tfvars.prod
-$ rw-rw-r-- 1 bhushan bhushan  187 May 29 21:45 terraform.tfvars.stage
-$ rw-rw-r-- 1 bhushan bhushan  290 May 29 21:45 variables.tf
```

Next, run the commands **terraform init** and then **terraform plan**

------------------------------------------------------------------------------

2. **terraform-solution-2**
- In this solution, all services(ec2,s3,elb) are kept combined and the network(subnets) is separated. This will run terraform for all services at the same time from just one main.tf

 i.e:
```
/terraform-solution-2(test)$ ls -l
common-mods
services

/terraform-solution-2(test)$ ls -l common-mods/
envconfig.sh
network
ec2-elb-s3

/terraform-solution-2(test)$ ls -l services/
ec2-elb-s3
network
```

There is a script given under the common-mods directory to set up config for the prod environment.

This script creates a symlink between the environment-specific **terraform.tfvars.prod** and default **terraform.tfvars** as well as **backend.tf.prod** and **backend.tf**

e.g: To create infra for the prod environment:-
```
-$ cd terraform-solution-2/services/ec2-elb-s3/
-$ ../../common-mods/envconfig.sh prod
-$ ls -la
-$ lrwxrwxrwx 1 bhushan bhushan   14 May 30 00:46 backend.tf -> backend.tf.prod
-$ rw-rw-r-- 1 bhushan bhushan  128 May 30 00:04 backend.tf.dev
-$ rw-rw-r-- 1 bhushan bhushan  130 May 30 00:04 backend.tf.prod
-$ rw-rw-r-- 1 bhushan bhushan  132 May 29 21:45 backend.tf.stage
-$ rw-rw-r-- 1 bhushan bhushan  204 May 29 21:45 main.tf
-$ rwxrwxrwx 1 bhushan bhushan   20 May 30 00:46 terraform.tfvars -> terraform.tfvars.prod
-$ rw-rw-r-- 1 bhushan bhushan  185 May 30 00:05 terraform.tfvars.dev
-$ rw-rw-r-- 1 bhushan bhushan  186 May 30 00:05 terraform.tfvars.prod
-$ rw-rw-r-- 1 bhushan bhushan  187 May 29 21:45 terraform.tfvars.stage
-$ rw-rw-r-- 1 bhushan bhushan  290 May 29 21:45 variables.tf
```

Next, run the commands **terraform init** and then **terraform plan**

## Note: Please update VPC ID in all tf.vars files before executing terraform plan.

>In this assignment, Classic elb is used as the instruction was given to Create an ELB with health check - /health on port 443 of the instances behind it. (Not mentioned to create Target group)

> This can be achieved by the application load balancer as well, but this requires creating a Target group between ELB and instance.
