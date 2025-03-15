#!/bin/bash

# Define colors for output
green="\e[32m"
red="\e[31m"
reset="\e[0m"

# Function to install a tool
tool_install() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "${green}[+] Installing $1...${reset}"
        eval "$2"
    else
        echo -e "${red}[-] $1 is already installed.${reset}"
    fi
}

# Update and install dependencies
echo -e "${green}[+] Updating system and installing dependencies...${reset}"
apt update && apt upgrade -y
apt install -y git curl wget unzip build-essential python3 python3-pip

echo -e "${green}[+] Installing Go...${reset}"
wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
export PATH="$PATH:/usr/local/go/bin"
echo 'export PATH="$PATH:/usr/local/go/bin:$(go env GOPATH)/bin"' >> ~/.bashrc
source ~/.bashrc
rm go1.21.5.linux-amd64.tar.gz

echo -e "${green}[+] Installing Recon Tools...${reset}"
# Subdomain enumeration
tool_install amass "go install -v github.com/owasp-amass/amass/v4/...@latest"
tool_install assetfinder "go install github.com/tomnomnom/assetfinder@latest"
tool_install subfinder "go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
tool_install findomain "wget https://github.com/Findomain/Findomain/releases/latest/download/findomain-linux -O /usr/local/bin/findomain && chmod +x /usr/local/bin/findomain"

# DNS & Port Scanning
tool_install dnsx "go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest"
tool_install massdns "git clone https://github.com/blechschmidt/massdns.git && cd massdns && make && mv bin/massdns /usr/local/bin && cd .. && rm -rf massdns"
tool_install naabu "go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest"

# HTTP Probing & Crawling
tool_install httpx "go install github.com/projectdiscovery/httpx/cmd/httpx@latest"
tool_install gau "go install github.com/lc/gau/v2/cmd/gau@latest"
tool_install hakrawler "go install github.com/hakluke/hakrawler@latest"
tool_install waybackurls "go install github.com/tomnomnom/waybackurls@latest"
tool_install waymore "git clone https://github.com/xnl-h4ck3r/waymore.git && cd waymore && pip3 install -r requirements.txt && chmod +x waymore.py && mv waymore.py /usr/local/bin/waymore && cd .. && rm -rf waymore"
tool_install katana "go install github.com/projectdiscovery/katana/cmd/katana@latest"
tool_install nuclei "go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest"

echo -e "${green}[+] Installation complete! Don't forget to run 'source ~/.bashrc' to apply changes.${reset}"

