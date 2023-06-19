variable "access_key" {
        description = "Access key to AWS console"
}
variable "secret_key" {
        description = "Secret key to AWS console"
}

variable "ami_name" {
    default = "ubuntu"
}

variable "ami_id" {
    default = "ami-04e601abe3e1a910f" # Ubuntu Server 22.04 LTS (HVM), SSD Volume Type + Frankfurt

}
variable "ami_key_pair_name" {
    default = "ec2-keypair" # create before you run terraform plan/apply
}