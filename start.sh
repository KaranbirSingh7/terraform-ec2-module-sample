#!/bin/bash

terraform init;

terraform fmt; 

terraform validate;

if [ $? -eq 0 ]
then
    terraform plan;
    echo 'Terraform plan is complete, run => `terraform apply -auto-approve` to start provisioning'
fi