variable "cidr_block" {
    type = list(string)
    default = ["10.0.0.0/16","10.0.1.0/24","10.0.2.0/24"]
  
}


variable "ports" {
    type = list(number)
    default = [22,80,443,8080,8081]
}

variable "ami_ec2" {
    type = string
    default = "ami-0ed9277fb7eb570c9"
  
}


variable "ec2" {
    type = string
    default = "t2.micro"
  
}

