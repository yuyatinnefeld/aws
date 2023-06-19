# Gnerate AWS components
```bash
terraform init
terraform plan
terraform apply --auto-approve
```
# Use SSH to connect a EC2 instance server
```bash
chmod 400 ec2-keypair.pem
ssh -i ec2-keypair.pem ubuntu@3.77.166.58  #Public IPv4 address
ubuntu@ip-10-0-53-9:~$ 
```