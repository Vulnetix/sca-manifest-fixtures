provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"

  tags = {
    Name = "web-server"
  }
}

resource "aws_s3_bucket" "assets" {
  bucket = "myapp-assets"

  tags = {
    Environment = "production"
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}
