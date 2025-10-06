# Terminal Related Folder 
On this page, I will record or note the setup of different terminals or editor
- Terminal Setup
	- [ ] ohmyzsh (MaC/Linux)
		- [X] zsh+ohmyzsh+P10K (Ubuntu)
		- [X] zsh+ohmyzsh+P10K+iTerm2 (MAC)
		- []  zsh+starship+Wrap (MAC)
	- [X] Window-OhmyPosh Setup
		- [X] PowerShell
		- [X] WSL Linux
		- [X] Fish Shell
- Text Editor or other tool
  - [ ] Neovim Related Setting
  

## Description
I have been trying to play around with the fancy terminal but never have time to write a note on it, so i will keep related seting. 


### Understand each compoment 

| Component | What it is | What it does | Can it be replaced? |
| :--- | :--- | :--- | :--- |
| **Terminal** (iTerm2, Warp, Windows Terminal) | The actual window/application. | Renders the text and handles keypresses. | Yes, use any terminal app you like. |
| **Shell** (Zsh, Bash, Fish) | The command-line interpreter. | Executes commands and handles auto-completion, history, and scripts. | No, this is essential. |
| **Framework** (Oh My Zsh) | A collection of scripts. | Provides a large library of aliases, functions, sane defaults, and a plugin manager for Zsh. | Yes, Starship does NOT replace this (see below). |
| **Prompt/Theme** (Starship, Powerlevel10k) | A program/script that calculates the text/icons shown on the command line. | Displays the current Git branch, language version, path, etc. | Yes, Starship and p10k are alternatives to each other. |


- You can use these combination

| Setup | Description | Pros | Cons |
| :--- | :--- | :--- | :--- |
| **1. Zsh + Starship** (Recommended Minimal) | Starship is installed directly in your Zsh config. | Blazing fast startup, cross-shell consistency (if you use Starship everywhere). | You must manually add Zsh plugins (like autosuggestions/syntax highlighting). |
| **2. Zsh + OMZ + Starship** | You use OMZ for plugins and Starship for the prompt. | Easy access to OMZ plugins/aliases, uses Starship's fast, universal prompt. | You still take on the initial overhead of OMZ loading. |
| **3. Zsh + OMZ + p10k** (The Classic Setup) | You use OMZ for plugins and Powerlevel10k for the prompt. | Easiest way to get a fully-featured Zsh setup. P10k is highly optimized for Zsh. | Only works on Zsh, and still has the OMZ bloat/sluggishness. |
| **4. Fish + Starship** | Use the Fish shell (which is feature-rich by default) with Starship. | Extremely fast, very user-friendly, and simple configuration. | Fish is not POSIX compliant, so some scripts may not run. |

