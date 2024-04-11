resource "aws_instance" "instance-nazgul-1" {  
  ami           = "ami-0b8b44ec9a8f90422" 
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
}

resource "aws_instance" "instance-nazgul-2" {
  ami           = "ami-0900fe555666598a2"  
  instance_type = "t3.micro"
  availability_zone = "us-east-2a"
  associate_public_ip_address = "false"
}

resource "aws_instance" "instance-nazgul-3" {
  monitoring    = true  
  ami           = "ami-0b8b44ec9a8f90422" 
  instance_type = "t2.micro"
  associate_public_ip_address = "false"
