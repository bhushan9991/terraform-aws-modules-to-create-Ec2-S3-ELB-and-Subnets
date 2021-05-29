#!/bin/bash

ENVIRONMENT=$1
file1="backend.tf"
file2="terraform.tfvars"

if [[ -L "$file1" ]] && [[ -L  "$file2" ]]
then
    unlink "$file1"
    unlink "$file2"
    if [[ -L "additional-redirect.tf" ]]; then
        unlink additional-redirect.tf
    fi
fi

ln -s backend.tf.${ENVIRONMENT} backend.tf
ln -s terraform.tfvars.${ENVIRONMENT} terraform.tfvars

if [[ "$ENVIRONMENT" == "prod" ]];
then
	if [[ -f additional-redirect.tf.prod ]];
	then
		ln -s additional-redirect.tf.prod additional-redirect.tf
	fi
fi
