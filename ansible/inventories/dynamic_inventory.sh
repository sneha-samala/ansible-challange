#!/bin/bash
# Read IPs from Terraform output
FRONTEND_IP=$(terraform -chdir=../terraform output -raw frontend_ip)
BACKEND_IP=$(terraform -chdir=../terraform output -raw backend_ip)

cat << EOF
[frontend]
c8.local ansible_host=$FRONTEND_IP ansible_user=ec2-user

[backend]
u21.local ansible_host=$BACKEND_IP ansible_user=ubuntu
EOF
