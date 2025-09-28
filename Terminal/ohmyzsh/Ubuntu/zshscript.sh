#!/bin/bash
#creating zsh terminal 
echo "installing zsh"
apt-get install zsh -y
echo "installing git"
apt-get install git -y

echo "check support shell :" 
cat /etc/shells

echo "check current shell:" 
echo $SHELL
echo "install oh-my-zsh"
#curl: 
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
#wget
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

echo "change shell to zsh"
chsh -s /bin/zsh

#setting theme
cd
#sudo mv Downloads/bullet-train.zsh-theme .oh-my-zsh/themes/
sudo cp -av bullet-train.zsh-theme .oh-my-zsh/themes/

sed -i -e 's/ZSH_THEME="robbyrussell"/#ZSH_THEME="robbyrussell"\nZSH_THEME="bullet-train"/g' .zshrc

#echo 'read -p "please enter your option'
#echo '1. setup pxe setting dhcp tftp '
#echo '========================'
#read -p "Your Options: " option