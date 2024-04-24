variable "vpc_cidr_block" {
    description = "cidr_block for vpc"
    type = string 
} 

variable "subnet1_cidr_block" {
    description = "cidr_block for subnet1"
    type = string 
}

variable "subnet2_cidr_block" {
    description = "cidr_block for subnet2"
    type = string 
}

variable "instance_type" {
    default = "t2.micro" 
    type = string 
} 

variable "userdata" {
    default = null 
}

variable "name" {
    type = string
    default = "less3"
}
