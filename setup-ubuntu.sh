#!/bin/bash

# Make sure the script is run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Update and upgrade system
echo "Updating package lists and upgrading system..."
apt-get update -y && apt-get upgrade -y

# Install essential packages
echo "Installing essential packages..."

apt-get install -y build-essential \
   curl \
   git \
   vim \
   net-tools \
   unzip \
   wget

echo "Installing development tools..."

apt-get install -y python3 \
   python3-pip \
   python3-venv \
   python3-dev \
   python3-setuptools \
   python3-dnspython \
   python-is-python3

apt-get install -y nodejs
apt-get install -y npm
#apt-get install -y docker.io
#apt-get install -y docker-compose

echo "Installing docker"
curl -fsSL https://get.docker.com -o ~/get-docker.sh
sudo sh ~/get-docker.sh
sudo adduser -aG docker $USER

# Install additional packages
echo "Installing addtional packages..."

apt-get install -y software-properties-common \
   dnsutils \
   tmux \
   jq \
   htop \
   tcpdump \
   nmap \
   iptables \
   netcat \
   openssl

apt-get install -y zsh
apt-get install -y httpie
apt-get install -y snmpget snmpwalk snmpset
apt-get install -y telnet
#apt-get install swaks mailutils
apt-get install -y scp rsync lftp mosh
apt-get install -y ldapsearch
apt-get install -y sqlite3
#apt-get install -y mysql psql

echo "Setup shell..."

cat <<EOF > ~/shell_common
export EDITOR=vim

alias sz='source ~/.zshrc'

alias py='python3'

alias g='git'
alias ga='git add -A'
alias gc='git commit'

alias d='docker'
EOF

COMMON_COMMANDS=(
   "source ~/shell_common"
)

# Append the command to the specified file if it's not already there
append_if_not_exists() {
    local file=$1
    if [ -f "$file" ]; then
        for cmd in "${COMMON_COMMANDS[@]}"; do
            grep -qxF "$cmd" "$file" || echo "$cmd" >> "$file"
        done
    fi
}

append_if_not_exists ~/.bashrc
append_if_not_exists ~/.zshrc


sudo apt autoremove -y

echo "\n"
echo "Setup complete!"
