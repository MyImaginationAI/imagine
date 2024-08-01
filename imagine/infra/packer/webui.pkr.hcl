packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "proserve-ue1-webui"
  instance_type = "t2.micro"
  region        = "us-east-1"

  vpc_id        = "vpc-099940443fbe6b12c"
  subnet_id     = "subnet-0b757577209988916"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name    = "proserve-ue1-webui"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
}


