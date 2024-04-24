output "instance_ids" {
    value = [aws_instance.instance1.id , aws_instance.instance2.id]
} 

output "subnet_ids" {
    value = [aws_subnet.subnet1.id , aws_subnet.subnet2.id]
} 

output "vpc_ids" {
    value = [aws_vpc.my_vpc1.id , aws_vpc.my_vpc2.id]
} 

output "vpc_cidr_block" {
    value = aws_vpc.my_vpc1.cidr_block 

}





