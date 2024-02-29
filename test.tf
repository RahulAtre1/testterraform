# Misconfigured Terraform file

provider "aws" {
  region = "us-west-99" # Invalid region
  access_key = "ACCESS_KEY" # Placeholder access key
  secret_key = "SECRET_KEY" # Placeholder secret key
}

variable "instance_count" {
  default = "one" # Invalid value for instance_count
}

resource "aws_instance" "example" {
  ami           = "ami-12345678" # Invalid AMI ID
  instance_type = "t2.micro"     # Typo in instance type
  key_name      = "my_key"       # Key doesn't exist
  subnet_id     = "subnet-12345" # Invalid subnet ID

  tags = {
    Name = "MisconfiguredInstance"
    Environment = "Dev"
  }

  provisioner "local-exec" {
    command = "echo Instance created" # Insecure local-exec provisioner
  }

  connection {
    type        = "ssh"
    user        = "ec2-user" # Incorrect SSH user
    private_key = file("~/.ssh/id_rsa") # Incorrect private key path
  }

  lifecycle {
    ignore_changes = "all" # Invalid value for ignore_changes
  }
}

resource "aws_security_group" "example" {
  name        = "misconfigured-security-group" # Duplicate security group name
  description = "Misconfigured security group"

  # Incorrect egress rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Incorrect ingress rule
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "instance_ip" {
  value = aws_instance.example.private_ip # Output referencing incorrect attribute
}
