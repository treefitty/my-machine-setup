

cd ~/Downloads

sudo apt install curl -y
sudo apt install git -y
sudo apt install openssh-server -y
sudo apt install -y tree
sudo apt install -y jq
sudo apt install -y python-pygments
sudo apt install -y default-jdk 
sudo apt install -y nmap
sudo apt install -y net-tools
sudo apt install -y traceroute


# ----
# nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

sudo apt -y update
sudo apt -y upgrade

nvm install --lts

npm install -g jsonlint
npm install -g yo
npm install -g nyc
npm install -g typescript
npm install -g yarn
npm install -g eslint


# ----
# dotnet sdk
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

sudo add-apt-repository universe
sudo apt install -y apt-transport-https
sudo apt -y update
sudo apt install -y dotnet-sdk-2.2


# ----
# Micro editor
wget https://getmic.ro | bash

sudo mv micro /usr/local/bin/


# ----
# pyenv
curl https://pyenv.run | bash

echo "export PATH=\"/home/paul/.pyenv/bin:$PATH\"" >> ~/.bashrc
echo "eval \"$(pyenv init -)\"" >> ~/.bashrc
echo "eval \"$(pyenv virtualenv-init -)\"" >> ~/.bashrc

sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl

sudo pyenv install 3.7.2


# ----
# kubectl
sudo apt-get update -y
sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install -y kubectl


# ----
# install my bash extensions
curl http://bosh.paulc.me/install.sh | bash && source ~/.bashrc


# ----
# docker
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update -y
apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo systemctl status docker

sudo usermod -aG docker paul

su paul


# ----
pip install docker-compose



