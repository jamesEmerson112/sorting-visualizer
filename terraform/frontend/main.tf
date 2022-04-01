
Skip to content
Pulls
Issues
Marketplace
Explore
@jamesEmerson112
jamesEmerson112 /
sorting-visualizer
Private

Code
Issues
Pull requests
Actions
Projects
Security
Insights

More
sorting-visualizer/sorting-visualization.tf
@jamesEmerson112
jamesEmerson112 Create sorting-visualization.tf
Latest commit 7893ac1 3 days ago
History
1 contributor
207 lines (171 sloc) 4.69 KB
# Configure the AWS Provider
provider "aws"  {
  region = AWS_DEFAULT_REGION
  access_key = AWS_ACCESS_KEY_ID
  secret_key = AWS_SECRET_ACCESS_KEY
}

# 1. Create vpc
# 2. Create Internet Gateway
# 3. Create Custom Route Table
# 4. Create a subnet 
# 5. Associate subnet with Route Table
# 6. Create Security Group to allow port 22,80,443
# 7. Create a network interface with an ip in the subnet that was created in step 4
# 8. Assign an elastic IP to the network interface created in step 7
# 9. Create Ubuntu server and install/enable apache2

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

variable "subnet_prefix" {
  description = "cidr block for the subnet"
  # default
  type = any
}

# 1. Create vpc
resource "aws_vpc" "terraform-prod-vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "terraform production"
  }
}

# 2. Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.terraform-prod-vpc.id

  tags = {
    Name = "terraform internet gateway"
  }
}

# 3. Create Custom Route Table
resource "aws_route_table" "terraform-prod-route-table" {
  vpc_id = aws_vpc.terraform-prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "example"
  }
}


# 4. Create a subnet 
resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.terraform-prod-vpc.id

  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "prod-subnet"
  }
}

# 5. Associate subnet with Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.terraform-prod-route-table.id
}

# 6. Create Security Group to allow port 22,80,443
resource "aws_security_group" "allow_tls" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id = aws_vpc.terraform-prod-vpc.id


  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]         # or our own IP address
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]         # or our own IP address
  }

  ingress {
  description      = "SSH"
  from_port        = 20
  to_port          = 20
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]         # or our own IP address
}

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

# 7. Create a network interface with an ip in the subnet that was created in step 4
resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_tls.id]

  # attachment {
  #   instance     = aws_instance.test.id
  #   device_index = 1
  # }
}

# 8. Assign an elastic IP to the network interface created in step 7
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [
    aws_internet_gateway.gw
  ]
}

# 9. Create Ubuntu server and install/enable apache2 
resource "aws_instance" "web-server-instance" {
  ami           = "ami-0e472ba40eb589f49"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "main-key-terraform"

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt-get install curl
              curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
              sudo nvm install node
              npm install -g npx
              sudo apt-get install git
              sudo bash -c 'echo your very first web server > /var/www/html/index.html'
              EOF

  tags = {
    Name = "Sorting visualization"
  }
}

output "server_public_ip" {
  value = aws_eip.one.public_ip
}

output "server_private_up" {
  value = aws_instance.web-server-instance.private_ip
}

output "server_id" {
  value = aws_instance.web-server-instance.id
}


# # Deploy syntax
# resource "<provider>_<resource_type>" "name" {
#     config options... 
#     key = "value"
#     key2 = "another value"
# }

# Create a VPC
# resource "aws_vpc" "example" {
#   cidr_block = "10.0.0.0/16"
# }

    © 2022 GitHub, Inc.

    Terms
    Privacy
    Security
    Status
    Docs
    Contact GitHub
    Pricing
    API
    Training
    Blog
    About

Loading complete