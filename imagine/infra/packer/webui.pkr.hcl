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
    inline = [
      "sudo apt update",
      "sudo apt upgrade -y",
      "sudo apt install -y unattended-upgrades python3.10-venv npm git python3-pip build-essential nginx software-properties-common libsqlite3-dev libssl-dev libffi-dev apt-build",
      "sudo dpkg-reconfigure --priority=low unattended-upgrades",
      "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash",
      "mkdir -p /home/ubuntu/workspaces",
      "git clone https://github.com/open-webui/open-webui.git /home/ubuntu/workspaces/webui",
      "cd /home/ubuntu/workspaces/webui",
      "python3 -m venv webui",
      "source webui/bin/activate",
      "cp -RPp .env.example .env",
      "sed -i \"s/^OLLAMA_BASE_URL='http:\\/\\/localhost:11434'/#&/\" .env",
      "sed -i \"s/^OPENAI_API_BASE_URL=''/export OPENAI_BASE_URL=http:\\/\\/Bedroc-Proxy-ZrSLnLSONx8B-1607610884.us-east-1.elb.amazonaws.com\\/api\\/v1/\" .env",
      "sed -i \"s/^OPENAI_API_KEY=''/export OPENAI_API_KEY=banana1/\" .env",
      "nvm install --lts",

      "source ~/.bashrc",
      "nvm install --lts",
      "node --version",
      "nvm --version",
      "wget https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh",
      "bash Anaconda3-2024.06-1-Linux-x86_64.sh",
      "conda create --name open-webui-env python=3.11",
      "conda activate open-webui-env",
      "pip install -r requirements.txt -U",
      "bash start.sh",
      "sudo add-apt-repository ppa:deadsnakes/ppa",
      "sudo apt update",
      "sudo apt install -y python3.11",
      "sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1",
      "sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 2",
      "sudo update-alternatives --config python3",
      "sudo systemctl restart nginx",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable webui",
      "sudo systemctl start webui",
      "sudo systemctl status webui"
    ]
  }
}