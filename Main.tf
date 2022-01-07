resource "aws_vpc" "Fire_my_vpc" {
  cidr_block       = var.cidr_block[0]
  enable_dns_hostnames = true

  tags = {
    Name = "Fire_my_vpc"
  }
}

resource "aws_subnet" "Pub_Subnet1" {
  vpc_id     = aws_vpc.Fire_my_vpc.id
  cidr_block = var.cidr_block[1]
  availability_zone = "us-east-1a"

  tags = {
    Name = "Pub_Subnet1"
  }
}

resource "aws_subnet" "Pub_Subnet2" {
  vpc_id     = aws_vpc.Fire_my_vpc.id
  cidr_block = var.cidr_block[2]
  availability_zone = "us-east-1b"

  tags = {
    Name = "Pub_Subnet2"
  }
}


# The Internet Gateway
resource "aws_internet_gateway" "fire_vpc_igw" {
  vpc_id = aws_vpc.Fire_my_vpc.id

  tags = {
    Name = "fire_vpc_igw"
  }
}

# The Public Route Table

resource "aws_route_table" "RT_vpc_public" {
    vpc_id = aws_vpc.Fire_my_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.fire_vpc_igw.id
    }

    tags = {
        Name = "fire_vpc_igw"
    }
}

resource "aws_route_table_association" "my_vpc_publicassociation1" {
    subnet_id = aws_subnet.Pub_Subnet1.id
    route_table_id = aws_route_table.RT_vpc_public.id
}

resource "aws_route_table_association" "my_vpc_publicassociation2" {
    subnet_id = aws_subnet.Pub_Subnet2.id
     route_table_id = aws_route_table.RT_vpc_public.id

}

# The SG
   
   resource "aws_security_group" "Mylab_SG" {
  name        = "Mylab_SG"
  description = "Allow inbound and outbound trafic"
  vpc_id      = aws_vpc.Fire_my_vpc.id

  

dynamic ingress {
  iterator = port
  for_each = var.ports
  content {
    from_port        = port.value
    to_port          = port.value
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }
}

 

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "Allow_Traffic"
  }
}

# Creating EC2 Instance

resource "aws_instance" "Projectfire_web" {
  ami           = var.ami_ec2
  instance_type = var.ec2
  key_name = "Destroy_EC2"
  vpc_security_group_ids = [aws_security_group.Mylab_SG.id]
  subnet_id = aws_subnet.Pub_Subnet1.id
  associate_public_ip_address = true
 

  tags = {
    Name = "Projectfire_web"
  }
}