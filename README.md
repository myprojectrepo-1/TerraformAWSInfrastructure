# Terraform for AWS

The Project emphasis on creating AWS cloud infrastructure through code using Terraform. Features include:

- Creation of VPC
- Creating Internet Gateway
- Attaching Internet Gateway to VPC
- Creating Public and Private Subnets
- Creating NAT Gateway in public subnet
- Creating network Route Table
- Making changes to default and newly created Route Tables, so public subnet gets internet access and instances within private subnet can download require packages through NAT Gateway
- Creating Security Groups for ssh, web and db connections
- Creating EC2 instance within public subnet to run nginx webserver
- Passing script file to instance to run as bootstrap script
- Hosting MariaDB database in private subnet
- Outputting values at the end of stack creation

## Pre-requisites
1. Git (Install and configure git to clone repository) - optional
2. Terraform (Install Terraform)
3. AWS Account

## Compatibility
* terraform >= 0.12

## Configuration Steps

1. Clone git repository locally or download zip file
2. Create "mykey" keypair using keygen.
 - On Windows, use puttey.keygen
 - On macOS, use terminal with command: ssh-keygen -t mykey
 - Store mykey and mykey.pub files to locally downloaded repository
3. Create terraform.tfvars file with following credentials
 AWS_ACCESS_KEY = ""  
 AWS_SECRET_KEY = ""  
 RDS_USERNAME   = ""  
 RDS_PASSWORD   = ""  
4. Use Terraform commands to create AWS stacks
5. Use output ip credentials in browser to check if webserver functioning
6. Destroy terraform stack at the end of work session.

Refer Terraform Documentation for more details: [terraform.io](https://terraform.io)
