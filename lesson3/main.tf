resource "aws_vpc" "my_vpc1"{
    cidr_block = var.vpc_cidr_block
    tags = {
     "Name" =var.name
    }
}

resource "aws_vpc" "my_vpc2"{
    cidr_block = "172.31.0.0/16"
    provider = aws.oregon
    enable_dns_hostnames = true
    tags = {
     "Name" =var.name
    }
}

resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.my_vpc1.id
    cidr_block = var.subnet1_cidr_block
    map_public_ip_on_launch = true
    depends_on = [aws_internet_gateway.igw]
      tags = {
        "Name" = "public_subnet1"
    }
}

resource "aws_internet_gateway" "igw"{
    vpc_id = aws_vpc.my_vpc1.id
} 

resource "aws_subnet" "subnet2" {
    vpc_id  = aws_vpc.my_vpc1.id
    cidr_block = var.subnet2_cidr_block
    depends_on = [aws_vpc.my_vpc1]
      tags = {
        "Name" = "private_subnet2"
      }
}

resource "aws_subnet" "subnet_oregon" {
    provider = aws.oregon
    vpc_id = aws_vpc.my_vpc2.id
    cidr_block = "172.31.1.0/24"
    tags = {
        "Name" = var.name
    }
}

resource "aws_instance" "instance1" {
    ami = data.aws_ami.ami.id
    instance_type = var.instance_type 
    subnet_id = aws_subnet.subnet2.id
    user_data = var.userdata
    depends_on = [aws_subnet.subnet2]
      tags = {
        "Name" = "var.name"
      }
}
resource "aws_instance" "instance2" {
    provider = aws.oregon
    ami = data.aws_ami.ami_oregon.id
    instance_type = var.instance_type 
    depends_on = [aws_subnet.subnet_oregon]

      tags = {
        "Name" = "${var.name}"
      }
}

resource "aws_security_group" "pub_sg" {
    description = "Allow HTTP, HTTPS, SSH"
    vpc_id = aws_vpc.my_vpc1.id
    name = "pub_sg"
    tags = {
        "Name" = "pub_sg"
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.my_vpc1.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id 
    }
    tags = {
        "Name" = "public_rt"
        "Name" = "var.name"
    }
} 

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.my_vpc1.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.natgw.id 
    }
    tags = {
        "Name" = "private_rt"
        "Name" = "var.name"
    }
} 



resource "aws_nat_gateway" "natgw" {
    allocation_id = aws_eip.eipp.id
    subnet_id = aws_subnet.subnet1.id
    tags = {
        "Name" = "natgw_subnet2"
        "Name" = var.name
        
    }
}


resource "aws_eip" "eipp" {
    domain = "vpc"
    tags = {
        "Name" = "eipp_for_natgw"
        "Name" = var.name
    }
}

resource "aws_route_table_association" "public_association" {
    subnet_id = aws_subnet.subnet1.id
    route_table_id = aws_route_table.public_rt.id
} 

resource "aws_route_table_association" "private_association" {
    subnet_id = aws_subnet.subnet2.id
    route_table_id = aws_route_table.private_rt.id
}

