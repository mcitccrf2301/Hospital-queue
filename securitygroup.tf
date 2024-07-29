#Create Security Group -SSH Traffic
resource "aws_security_group" "sg_ssh" {
    name="sg_ssh"
    description = "Dev VPC SSH"
    ingress{
        description="Allow port 22"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks=["0.0.0.0/0"]
    }
    egress{
        description = "Allow all ip and ports outbound"
        from_port=0
        to_port=0
        protocol="-1"
        cidr_blocks=["0.0.0.0/0"]
    }
    tags = {
      Name="sg_ssh"
    }
}

#Create Security Group - HTTP Traffic
resource "aws_security_group" "sg_web" {
    name="sg_web"
    description = "Dev VPC web"
    ingress{
        description="Allow port 80"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks=["0.0.0.0/0"]
    }
    ingress{
        description="Allow port 443"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks=["0.0.0.0/0"]
    }
    ingress{
        description="Allow port 3389"
        from_port = 3389
        to_port = 3389
        protocol = "tcp"
        cidr_blocks=["0.0.0.0/0"]
    }
    egress{
        description = "Allow all ip and ports outbound"
        from_port=0
        to_port=0
        protocol="-1"
        cidr_blocks=["0.0.0.0/0"]
    }
    tags = {
      Name="sg_web"
    }
}
