

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
sudo apt install -y nmap
sudo apt install -y net-tools
sudo apt install -y conky-all
sudo apt install -y gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly
sudo apt install -y yamllint
sudo apt install -y traceroute

sudo snap install caprine


# ----
# Install Golang version manager and Go (latest)
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)

sudo apt install -y bison

gvm install go1.4 -B
gvm use go1.4
gvm install 1.11.5
gvm use go1.11.5


# ----
# LibreOffice (OpenOffice is Oracle, this is the fork)
sudo add-apt-repository ppa:libreoffice/ppa
sudo apt -y update
sudo apt install -y libreoffice


# ----
# VirtualBox
sudo add-apt-repository multiverse
sudo apt-get -y update
sudo apt install -y virtualbox


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
curl https://getmic.ro | bash

sudo mv micro /usr/local/bin/


# ----
# pyenv
curl https://pyenv.run | bash

echo "export PATH=\"/home/paul/.pyenv/bin:$PATH\"" >> ~/.bashrc
echo "eval \"$(pyenv init -)\"" >> ~/.bashrc
echo "eval \"$(pyenv virtualenv-init -)\"" >> ~/.bashrc

sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl

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

sudo apt install -y apt-transport-https
sudo apt update -y
sudo apt install -y code


# ----
# kubectl
sudo apt-get update -y
sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install -y kubectl



# ----
# sublime
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt install -y apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

sudo apt install -y sublime-text


# ----
# Slack
sudo apt update  -y
sudo apt install -y gdebi-core wget

wget -O ~/Downloads/slack.deb "https://downloads.slack-edge.com/linux_releases/slack-desktop-3.1.0-amd64.deb"

sudo gdebi slack.deb


# ----
# steam
sudo apt install -y curl wget python-apt

wget -E http://media.steampowered.com/client/installer/steam.deb

sudo dpkg -i steam.deb 
sudo apt install -yf


# ----
# transmission
sudo add-apt-repository ppa:caffeine-developers/ppa
sudo apt update -y
sudo apt install caffeine -y


# ----
# insync
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C

echo "deb http://apt.insynchq.com/ubuntu bionic non-free contrib" | sudo tee /etc/apt/sources.list.d/insync.list

sudo apt install -y insync


# ----
# clipgrab
sudo add-apt-repository ppa:clipgrab-team/ppa
sudo apt-get update -y
sudo apt-get install -y clipgrab


# ----
# sayonara
sudo apt-add-repository ppa:lucioc/sayonara
sudo apt-get update -y
sudo apt-get install -y sayonara



# ----
# nvidia
sudo ubuntu-drivers autoinstall


# ----
# dbeaver
wget https://dbeaver.io/files/dbeaver-ce-latest-linux.gtk.x86_64.tar.gz
tar zxvf dbeaver-ce-latest-linux.gtk.x86_64.tar.gz

sudo mv ./dbeaver /opt

sudo cat >/usr/share/applications/dbeaver.desktop <<EOL
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
Terminal=false
Exec=/opt/dbeaver/dbeaver
Name=DBeaver
Icon=/opt/dbeaver/dbeaver.png
EOL



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
# setup the launcher with favourite apps
# use this to read them when updating: dconf read /org/gnome/shell/favorite-apps
dconf write /org/gnome/shell/favorite-apps "['org.gnome.Nautilus.desktop', 'google-chrome.desktop', 'firefox.desktop', 'code.desktop', 'gitkraken_gitkraken.desktop', 'sublime_text.desktop', 'dbeaver.desktop', 'slack_slack.desktop', 'caprine_caprine.desktop', 'spotify_spotify.desktop', 'steam.desktop', 'synergy.desktop', 'gimp.desktop', 'transmission-gtk.desktop', 'sayonara.desktop', 'clipgrab.desktop', 'gnome-calculator_gnome-calculator.desktop', 'libreoffice-calc.desktop', 'libreoffice-draw.desktop', 'virtualbox.desktop']"


# ----
# setup the "start up" applications
cat >~/.config/autostart/caffeine-indicator.desktop <<EOL
[Desktop Entry]
Type=Application
Exec=caffeine-indicator
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_AU]=caffeine-indicator
Name=caffeine-indicator
Comment[en_AU]=
Comment=
EOL


cat >~/.config/autostart/guake.desktop <<EOL
[Desktop Entry]
Type=Application
Exec=guake
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_AU]=guake
Name=guake
Comment[en_AU]=
Comment=
EOL


cat >~/.config/autostart/insync.desktop <<EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=Insync
GenericName=Insync
Comment=Launch Insync
Icon=insync
Categories=Network;
Exec=insync start
TryExec=insync
Terminal=false
X-GNOME-Autostart-Delay=3
EOL



