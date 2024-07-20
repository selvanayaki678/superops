# TASK1
# Building a Load-Balanced Web Server Environment

## Overview

This guide outlines the steps to deploy a load-balanced web server environment using Terraform on AWS. The setup includes creating a Virtual Private Cloud (VPC), subnets, an internet gateway, launching EC2 instances with Nginx installed, and configuring a Network Load Balancer (NLB) to distribute traffic among the instances.

## Prerequisites
    AWS account 
    Terraform installed on local machine

## Steps

### Create Terraform Configuration

- **VPC**: Define the networking environment for your resources.
- **Subnet**: Allocate subnet(s) within the VPC for your EC2 instances.
- **Internet Gateway**: Establish connectivity between your VPC and the internet.
- **EC2 Instances with Nginx**: Launch 2 Ec2 instances and install Nginx for serving web traffic.
- **Network Load Balancer**: Configure an NLB to evenly distribute incoming traffic across your EC2 instances.
- **Attach EC2 Instances**: Add EC2 instances to the NLB's target group for load balancing.

### Execute terraform 
- Login into AWS using aws configure oe set env variables for access key and value
- terraform init
- terraform validate
- terraform plan 
- terraform apply

### Testing 
 - Once deployed, access your web servers through the NLB's DNS name.

 ### Usecase

 Deleted the first web server: If you delete one of the web servers, you can still access the application through the second web server.

### CleanUp
- terraform destroy