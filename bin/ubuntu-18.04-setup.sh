

cd ~/Downloads

sudo apt install curl -y
sudo apt install glances -y
sudo apt install git -y
sudo apt install openssh-server -y
sudo apt install -y tree
sudo apt install -y jq
sudo apt install -y python-pygments
sudo apt install -y guake
sudo apt install -y gimp
sudo apt install -y xclip
sudo apt install -y icdiff
sudo apt install -y default-jdk

sudo snap install caprine


# ----
# nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

nvm install --lts

npm install -g jsonlint
npm install -g yo
npm install -g nyc
npm install -g typescript
npm install -g yarn


# ----
# Micro editor
curl https://getmic.ro | bash

sudo mv micro /usr/local/bin/


# ----
# pyenv
curl https://pyenv.run | bash

echo "export PATH=\"/home/paul/.pyenv/bin:$PATH\"" >> ~/.bashrc
echo "eval \"$(pyenv init -)\"" >> ~/.bashrc
echo "eval \"$(pyenv virtualenv-init -)\"" >> ~/.bashrc

sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev python-openssl

sudo pyenv install 3.7.2

# -----
# Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

sudo dpkg -i google-chrome-stable_current_amd64.deb

rm google-chrome-stable_current_amd64.deb


# ---- 
# vscode
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

sudo apt-get install apt-transport-https -y
sudo apt-get update
sudo apt-get install code -y


# ----
# kubectl
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl



# ----
# sublime
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

sudo apt-get install sublime-text -y


# ----
# Slack
sudo apt update
sudo apt install gdebi-core wget -y

wget -O ~/Downloads/slack.deb "https://downloads.slack-edge.com/linux_releases/slack-desktop-3.1.0-amd64.deb"

sudo gdebi slack.deb


# ----
# steam
sudo apt-get install -y curl wget python-apt -y

wget -E http://media.steampowered.com/client/installer/steam.deb

sudo dpkg -i steam.deb 
sudo apt-get install -yf


# ----
# transmission
sudo add-apt-repository ppa:caffeine-developers/ppa
sudo apt-get update
sudo apt install caffeine


# ----
# insync
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C

echo "deb http://apt.insynchq.com/ubuntu bionic non-free contrib" | sudo tee /etc/apt/sources.list.d/insync.list

sudo apt install insync -y


# ----
# clipgrab
sudo add-apt-repository ppa:clipgrab-team/ppa
sudo apt-get update
sudo apt-get install clipgrab


# ----
# sayonara
sudo apt-add-repository ppa:lucioc/sayonara
sudo apt-get update
sudo apt-get install sayonara -y



# ----
# nvidia
sudo ubuntu-drivers autoinstall



# ----
# docker
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo systemctl status docker

sudo usermod -aG docker paul

su paul

