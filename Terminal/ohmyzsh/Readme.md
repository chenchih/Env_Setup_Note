# Setup OhmyZsh Productive Terminal 

## Note: include these item
Ohmyzsh allows to set up under Ubuntu and mac, however, in mac we need to use iTerm2. I made some setup notes: 
- [x] Ubuntu setup `ohmyzsh` 
- [x] Mac setup `ohmyzsh` + `P10K` with `iterm2` terminal
- [X] Mac starship + warp terminal (continue from ohmyzsh)


## Description

I have been using a lot of CLI Linux commands quite often on both Windows, Linux, and Mac, and the most often used tool is the terminal. You can setup our terminal to be more productive with a fancy prompt theme and some plug-ins. You might see many developer show their command line on terminal is so fancy, these are the things they set. I made a description or the term in case you might not know as below: 

### Understand each component 

| Component | What it is | What it does | Can it be replaced? |
| :--- | :--- | :--- | :--- |
| **Terminal** (iTerm2, Warp, Windows Terminal) | The actual window/application. | Renders the text and handles keypresses. | Yes, use any terminal app you like. |
| **Shell** (Zsh, Bash, Fish) | The command-line interpreter. | Executes commands and handles auto-completion, history, and scripts. | No, this is essential. |
| **Framework** (Oh My Zsh) | A collection of scripts. | Provides a large library of aliases, functions, sane defaults, and a plugin manager for Zsh. | Yes, Starship does NOT replace this (see below). |
| **Prompt/Theme** (Starship, Powerlevel10k) | A program/script that calculates the text/icons shown on the command line. | Displays the current Git branch, language version, path, etc. | Yes, Starship and p10k are alternatives to each other. |


### You can use this combination

| Setup | Description | Pros | Cons |
| :--- | :--- | :--- | :--- |
| **1. Zsh + Starship** (Recommended Minimal) | Starship is installed directly in your Zsh config. | Blazing fast startup, cross-shell consistency (if you use Starship everywhere). | You must manually add Zsh plugins (like autosuggestions/syntax highlighting). |
| **2. Zsh + OMZ + Starship** | You use OMZ for plugins and Starship for the prompt. | Easy access to OMZ plugins/aliases, uses Starship's fast, universal prompt. | You still take on the initial overhead of OMZ loading. |
| **3. Zsh + OMZ + p10k** (The Classic Setup) | You use OMZ for plugins and Powerlevel10k for the prompt. | Easiest way to get a fully-featured Zsh setup. P10k is highly optimized for Zsh. | Only works on Zsh, and still has the OMZ bloat/sluggishness. |
| **4. Fish + Starship** | Use the Fish shell (which is feature-rich by default) with Starship. | Extremely fast, very user-friendly, and simple configuration. | Fish is not POSIX compliant, so some scripts may not run. |



## Link

- nerd font: 
	- https://www.nerdfonts.com/
- iterm2
	- https://iterm2.com/
	- https://iterm2colorschemes.com/
- OhmyZsh:
	- https://ohmyz.sh/
	- https://github.com/ohmyzsh
	- https://github.com/ohmyzsh/ohmyzsh/wiki/plugins
- ohmyposh: 
	- https://ohmyposh.dev/
	- https://github.com/jandedobbeleer/oh-my-posh
- Starship: 
	- https://github.com/starship/starship
	- https://starship.rs/config/
- p10k
	- https://github.com/romkatv/powerlevel10k
- warp
	- https://github.com/warpdotdev/themes.git
	- https://docs.warp.dev/terminal/appearance/custom-themes	