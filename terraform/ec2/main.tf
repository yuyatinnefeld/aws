//network
resource "aws_vpc" "my_mainnet" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}

//subnets
resource "aws_subnet" "my_subnet" {
  cidr_block = "${cidrsubnet(aws_vpc.my_mainnet.cidr_block, 3, 1)}"
  vpc_id = "${aws_vpc.my_mainnet.id}"
  availability_zone = "eu-central-1a"
}

//security
resource "aws_security_group" "my_sg" {
    name = "allow-all-sg"
    vpc_id = "${aws_vpc.my_mainnet.id}"
    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 22
        to_port = 22
        protocol = "tcp"
    }

    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 80
        to_port = 80
        protocol = "tcp"
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

//servers
resource "aws_instance" "my_ec2_instance" {
  ami = "${var.ami_id}"
  instance_type = "t2.micro"
  key_name = var.ami_key_pair_name
  security_groups = ["${aws_security_group.my_sg.id}"]
  subnet_id = "${aws_subnet.my_subnet.id}"
}

// ip address
resource "aws_eip" "my_ip" {
  instance = "${aws_instance.my_ec2_instance.id}"
  vpc      = true
}

//gateways
resource "aws_internet_gateway" "my_gateway" {
  vpc_id = "${aws_vpc.my_mainnet.id}"
}

//subnets
resource "aws_route_table" "my_route_table" {
  vpc_id = "${aws_vpc.my_mainnet.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.my_gateway.id}"
    }
}

resource "aws_route_table_association" "my_rt_association" {
  subnet_id      = "${aws_subnet.my_subnet.id}"
  route_table_id = "${aws_route_table.my_route_table.id}"
}
