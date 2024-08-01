.PHONY: imagine/devcontainer/create
imagine/devcontainer/create:
	@sudo apt update && sudo apt install -y \
        bash-completion \
        build-essential \
        curl \
        git \
        jq \
        vim \
        python3-pip \
        make \
        unzip \
        htop \
        net-tools

.PHONY: imagine/devcontainer/start
imagine/devcontainer/start:
	@sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt clean && sudo rm -rf /var/lib/apt/lists/*