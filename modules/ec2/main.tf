data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}


resource "aws_security_group" "allow_8080" {
  name        = "allow_8080"
  description = "Allow 8080 inbound traffic"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "8080 from VPC"
    from_port   = 8080
    protocol    = "tcp"
    self        = false
    to_port     = 8080
  }

}


resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.allow_8080.id]
  user_data              = <<-EOF
                #!/bin/bash
                echo "I made a terraform module" > index.html
                nohup busybox httpd -f -p 8080 &              
                EOF
}
