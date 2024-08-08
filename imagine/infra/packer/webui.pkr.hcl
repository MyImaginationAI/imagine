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
  instance_type = "m5.large"
  region        = "us-east-1"

  vpc_id        = "vpc-0d62210c6b4011c8f"
  subnet_id     = "subnet-0cd753ea81c8eea4d"

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

  provisioner "shell" {
    script = "scripts/000-update.sh"
    execute_command = "echo 'packer' | sudo -S -E bash '{{ .Path }}'"
  }
     
  provisioner "shell" {
    script = "scripts/001-install-python.sh"
    execute_command = "echo 'packer' | sudo -S -E bash '{{ .Path }}'"
  }
  
}