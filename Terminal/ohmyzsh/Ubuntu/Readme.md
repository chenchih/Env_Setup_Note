# Ohmyzsh setup under Ubuntu

Below is manually setup ohmyzs under ubuntu, however I provide `zshscript.sh` which allow to automatic setup, just run `./zshscript.sh`. 

## Step1: update
```
sudo apt-get update
sudo apt-get upgrade
```
Sometimes ubuntu update will occur some strange error like `dpkg` , please run this command will fix: 
```
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/lib/dpkg/lock
sudo rm /var/cache/apt/archives/lock
sudo dpkg --configure -a
sudo apt update
```

## Step2 install ohmyzsh

```
sudo apt-get install zsh
sudo apt-get install git
```

## Step3 check default shell
- check `zsh` is been added into shells path. This is showing support shells:
```
cat /etc/shells
```
if `zsh` not exist in shells please manually add:
```
sudo sh -c "echo $(which zsh) >> /etc/shells"
```

- Check default shells, it should be `/bin/bash` default
```
echo $SHELL 
```

- Change default shell to `/bin/zsh`
```
chsh -s /bin/zsh
```
Restart your terminal and check again `echo $SHELL` it should be `zsh`

## Step4 install oh-my-zsh
please refer to [oh my zsh offical site](#https://ohmyz.sh/), or download theme in this [site](#https://github.com/ohmyzsh/ohmyzsh/wiki/Themes) which show many theme look like

- using curl
```
$sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

- using wget
```
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
```

## Step5 download theme

The theme located: `~/.oh-my-zsh/themes/`

```
#Download theme from git
cd download 
git clone https://github.com/caiogondim/bullet-train.zsh.git
# move file
$sudo mv Downloads/bullet-train.zsh-theme .oh-my-zsh/themes/
```

## Step6 edit theme
```
$sudo nano .zshrc
#change ZSH_THEME to bullet-train
ZSH_THEME="bullet-train.zsh-theme"
source ~/.zshrc #reload cfg
```

## Step7 install powerline font
```
sudo apt-get install powerline
sudo apt-get install fonts-powerline
```

## reference: 
- https://medium.com/@wifferlin0505/%E5%9C%A8-ubuntu-16-04-lts-%E4%B8%AD%E5%AE%89%E8%A3%9D%E4%BD%BF%E7%94%A8-oh-my-zsh-cf92203ca8a2
- mac setting: search : oh-my-zsh iterm2 MAC
	- https://juejin.cn/post/6844904178075058189
	- https://medium.com/%E6%95%B8%E6%93%9A%E4%B8%8D%E6%AD%A2-not-only-data/macos-%E7%9A%84-terminal-%E5%A4%A7%E6%94%B9%E9%80%A0-iterms-oh-my-zsh-%E5%85%A8%E6%94%BB%E7%95%A5-77d5aae87b10
	- https://www.onejar99.com/terminal-iterm2-zsh-powerlevel10k/
	- https://www.jinnsblog.com/2021/06/iterm2-oh-my-zsh-powerlevel10k-setting.html