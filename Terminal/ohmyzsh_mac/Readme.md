# How to setup terminal Oh my zsh under MAC 

## 1. Homebrew

### install Homebrew

Homebrew 是 Mac OSX 上的的套件管理工具，是方便安裝管理 OSX 裡需要用到但預設沒安裝的套件。
```
$/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
    )"
```

### check brew version
```
brew --version
#Homebrew 4.6.13
```

### add brew path 
If you run the previous command not able find then you need to add homebre to your path. 
- check your path: `echo $PATH` 
> please check below exist:
>> intel: `/usr/local/bin`
>> Silicon: `/opt/homebrew/bin`

- create path 
If homebrew path not exist please edit `~/.zshrc` or `~/.bashrc` at the end of file add below either one:

```
#apple Silicon 
export PATH=/opt/homebrew/bin:$PATH 

#intel
export PATH=/usr/local/bin:$PATH 

#activate it
source ~/.zshrc
```

**Why do you need to add:**
When you install a tool using Homebrew (e.g., brew install git), Homebrew places the git executable in its own bin directory (/opt/homebrew/bin or /usr/local/bin).

##2. zsh

### Install zsh
- check zsh installed 
```
#check zsh installed
which zsh
``` 
- install zsh
```
# install zsh
brew install zsh
```

### Check default shell (debug)
- check current shell
Check if current default shell is `zsh`
```
echo $SHELL 
```
Default will be `/bin/bash`, you can also use to check support all shell

```
#check current default shell
cat /etc/shells
```
- add zsh path to shells 
if zsh not exist in shells, you need to add it
```
sudo sh -c "echo $(which zsh) >> /etc/shells"
```

### Add zsh as default shell
- switch to zsh shell default
```
chsh -s $(which zsh)
```
After setting, restart terminal or log out , check `echo $SHELL` zsh will be your default. 

```
echo $SHELL 
#/bin/zsh
```

## 3.oh my zsh
oh my zsh is a terminal prompt themes
- 🎨 Focus: just colors, prompt style, maybe git branch.
- ⚡ Simple, lightweight, but limited.

### Install oh my zsh
please use either method
- curl:
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
- wget
```
sh -c "$(wget -O-https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 
```

- git clone
```
git clone git://github.com/robbyrussell/oh-my-zsh.git 
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
source ~/.zshrc
```

[ohmyzsh install](img/ohmyzsh_install.PNG)

### change zsh theme  
When you install ohmyzsh, the theme is already download in this path  `~/.oh-my-zsh/themes/`

[ohmyzsh theme](img/ohmyzsh_theme.PNG)

- theme description or other theme 
Please download theme [theme description](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)
For example change to agnoster theme [link](https://github.com/agnoster/agnoster-zsh-theme)   

- edit theme
please edit theme: `vim ~/.zshrc` and change to different theme name
```
ZSH_THEME='agnoster' # default use robbyrussell change to agnoster
exec $SHELL
```
[change theme](img/ohmyzsh_zshrc.PNG)

now when you activate the theme it will look like below really ugly, we need to change to iterms2 and install font to fix this problem. 
This only happen if you use macbook, becuse mac therminal lack of font setting 
[agnoster theme](img/changetheme.PNG)



## Font
You can use 
- Nerd font: developers today use Nerd Fonts
- Powerline fonts:  are older


### nerd font
- install nerd font
```
brew install --cask font-meslo-lg-nerd-font
```

If you like other nerd font you can search with this command that perfer you:
```
brew search nerd
```

why choose `font-meslo-lg-nerd-font`: 
> - It’s recommended + tested with Powerlevel10k.
> - It has all needed icons.
> - It’s clean, readable, and safe (no weird spacing issues).



## iterm2 terminal
You will have realize the font look ugly, so we need to install iterm2 therminal to fix this problem


### install iterm2
you can [download](https://iterm2.com/downloads.html) iterms manual, or with below command:
```
brew install --cask iterm2    
```
#### font 
Set this font in iTerm2 → Preferences → Profiles → Text → Change Font -> select MesloLGS Nerd Font Mono

Now after chnage it, ther iterm2 terminal look perfect right
[item2 change font ](img/iterm2_text.PNG)

You can also change terminal app to this font, else it will look ugly.  If you don't need it in future then you can ignore this 
[terminal text](img/terminal_textsetting.PNG)



#### Terminal Type
Default I think is xterm-256color if not change it: 
Preferences → Profiles → Terminal → Report Terminal Type → xterm-256color

#### Color setting
The color recommend **iTerm 2 + Solarized Dark**, but I will show how to change color theme. 

You can download iterm2 color or copy the code with below link:
> - iterm2 color plugin [download](https://github.com/mbadolato/iTerm2-Color-Schemes)
> - iterm2 [color format](https://iterm2colorschemes.com/)

You can use two method, one download file, or copy the code and create file

[color method](img/color_method.PNG)


- (method1)import color
Step1: Navigate to below path 
Path: iterm →  preference →  profiles →  colors →  Color Presets → import
Step2: import you download color plugin 
Step3: choose the color you import just now
[iterm setting](img/itern2.PNG)


- (method2) create file by copy url code and paste into file
```
go to https://iterm2colorschemes.com/ and select your best color format and copy or download
touch Ryuuko.itermcolors
vi Ryuuko.itermcolors1
paste in
item import the file you create
```

I Now after set the color let see the comparsion of the iterm2 color
[color method](img/color_compare.PNG)

Note: When you download a color scheme from a site and import to use it, however you are not limited to that scheme's default settings. This mean if you use it and realize the color is great, then you want to change specfic color you aren't able to change it. 
 

## powerlevel 10k
Let install another powerful prompt theme if you think ohmyzsh is ok you can ignore it

You can see ohmyzsh theme doesn't look great enough let change to a more powerful one:
- 🚀 Focus: advanced features — icons, git status, Python/Node version, transient prompt, instant prompt, highly configurable.
- 🌟 Much more powerful, modern, and customizable.

### install powerlevel10k
```
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k 
```


### configure setting

It will ask you question do this:
```
after set theme `.zshrc` it will ask you question, press 
n
n
y
which style you want?
1unicode or 2ascii? 1
show time 
flat or blurred at end?
same line as heading?
compact or space
instant prompt mode? 1
apply?
```

### edit zshrc theme
 
- method 1 edit `.zshrc`

> `vi ~.zshrc`
```
ZSH_THEME="powerlevel10k/powerlevel10k"
```

- method 2  dump powerlevel10k to zshrc
```
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
exec $SHELL
```

- activate it
when you set the setting you can activate it with below command else you have to reboot. 
```
source ~/.zshrc
```

- summary theme: 
```
ZSH_THEME="agnoster"
ZSH_THEME="random" #randome theme  
ZSH_THEME="powerlevel10k/powerlevel10k" 

```

## plugin 
Everything have been setup, let add some great plugin which will make you more productive while using the terminal. 

### ohmyzsh plugin
[All ohmyzsh plugin ](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins)
- modify `~.zshrc` file 
copy the plugin you want from above web and paste into `plugins()` 
```
plugins= (osx #type tab will new terminal tab
websearch 
vscode #vscode) 
```
- activate it 
```
source ~.zshrc
```


### Auto Suggestions Plugin

- download
```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```
- add plugin to `~/.zshrc`
```
plugins=(git zsh-autosuggestions)
```
- activate it 
```
source ~/.zshrc
```

### Syntax Highlighting
-  download and install 
```
brew install zsh-syntax-highlighting
```
- modify and add plugin `~/.zshrc`
please edit `~/.zshrc` using `vi` or `open` for mac. Skip to the end of ~/.zshrc and add below:
```
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zshrc
```
press `cd` will list all directory 

### Change the username@hostname

- modify and add plugin `~/.zshrc`
add below bottom of `ZSH_THEME` 
```
DEFAULT_USER = \`whoami`
```


## reference
