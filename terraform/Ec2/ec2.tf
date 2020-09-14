provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

terraform {
  required_version = "< 0.12.0"
}
resource "aws_key_pair" "aws"{

    key_name = "aws"
    public_key = "~/aws.pem"
}
resource "aws_instance" "apache2" {
	ami = "ami-06b263d6ceff0b3dd"
	instance_type = "t2.micro"
	key_name       =  "var.key_name"
    tags {
      Name = "Ec2-Ubuntu"
  }

connection {
    user         =  "ubuntu"
	private_key  =  "${file(var.private_key_path)}"
	}

  provisioner "remote-exec" {
	  inline = [
	   "sudo apt-get install apache2 -y",
	   "sudo service apache2 start"
	   ]
	  }
    }
output  "aws_instance_public_dns" {
      value = "${aws_instance.apache2.public_dns}"
 }