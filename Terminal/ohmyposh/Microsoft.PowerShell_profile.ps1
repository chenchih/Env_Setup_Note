# Alias
#Set-Alias ll ls
#Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
Set-Alias grep findstr #findstr <string search> <filename>
Set-Alias ip ipconfig
# Enhanced Listing
function la { Get-ChildItem -Path . -Force | Format-Table -AutoSize }
function ll { Get-ChildItem -Path . -Force -Hidden | Format-Table -AutoSize }

function head {
  param($Path, $n = 10)
  Get-Content $Path -Head $n
}

function tail {
  param($Path, $n = 10)
  Get-Content $Path -Tail $n
}

function grep($regex, $dir) {
    if ( $dir ) {
        Get-ChildItem $dir | select-string $regex
        return
    }
    $input | select-string $regex
}

function df {
    get-volume
}
#get $env variable
function getenv {ChildItem env:}

# Git Shortcuts
function gs { git status }
function ga { git add . }
function gc { param($m) git commit -m "$m" }
function gp { git push }
function g { z Github }
function gcom {
    git add .
    git commit -m "$args"
}
function lazyg {
    git add .
    git commit -m "$args"
    git push
}

# adding hosts shorcut 
function hosts { notepad c:\windows\system32\drivers\etc\hosts }

# Utilities
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# Env
$env:GIT_SSH = "C:\Windows\system32\OpenSSH\ssh.exe"

# Clipboard Utilities select word will automatic copy and paste
# (using mouse) 
function cpy { Set-Clipboard $args[0] }
function pst { Get-Clipboard }


################plugin 
if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadLine
}

# Enhanced PowerShell Experience
Set-PSReadLineOption -Colors @{
    Command = 'Yellow'
    Parameter = 'Green'
    String = 'DarkCyan'
}
#Terminal-Icons
Import-Module -Name Terminal-Icons

#zoxide
Import-Module z

# PSReadLine
#Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

# exit shell 
Set-PSReadlineKeyHandler -Chord ctrl+x -Function ViExit
#CapitalizeWord
Set-PSReadLineKeyHandler -Chord 'Alt+Shift+C' -Function CapitalizeWord
Set-PSReadLineOption -BellStyle None
# move back cursor, will alt+d will delete previous character
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
#  Ctrl+e move to end
Set-PSReadlineKeyHandler -Chord ctrl+e -Function EndOfLine
# Ctrl+a move to home or begin
Set-PSReadlineKeyHandler -Chord ctrl+a -Function BeginningOfLine

# select word backward 
Set-PSReadLineKeyHandler -Key Alt+B -Function SelectShellBackwardWord

# select word afterward
Set-PSReadLineKeyHandler -Key Alt+F -Function SelectShellForwardWord

#display related keyword in history 
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# key bindings
Set-PSReadLineKeyHandler -Key Alt+d -Function ShellKillWord
Set-PSReadLineKeyHandler -Key Alt+Backspace -Function ShellBackwardKillWord
Set-PSReadLineKeyHandler -Key Alt+b -Function ShellBackwardWord
Set-PSReadLineKeyHandler -Key Alt+f -Function ShellForwardWord
Set-PSReadLineKeyHandler -Key Alt+B -Function SelectShellBackwardWord
Set-PSReadLineKeyHandler -Key Alt+F -Function SelectShellForwardWord
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlineKeyHandler -Chord ctrl+x -Function ViExit
# delete character
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar	
# Ctrl+w backward delete word
Set-PSReadlineKeyHandler -Chord ctrl+w -Function BackwardDeleteWord

# Ctrl+e move to end of line
Set-PSReadlineKeyHandler -Chord ctrl+e -Function EndOfLine

# Ctrl+a move to beginning of line
Set-PSReadlineKeyHandler -Chord ctrl+a -Function BeginningOfLine

# (using key) CaptureScreen is good for blog posts or email showing a transaction
# of what you did when asking for help or demonstrating a technique.
#ctrl+c and ctrl+d  to copy terminal , ctrl+v to paste
Set-PSReadLineKeyHandler -Chord 'Ctrl+d,Ctrl+c' -Function CaptureScreen


#ohmyposh default theme 

#oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\atomic.omp.json" | Invoke-Expression
#oh-my-posh init pwsh --config "C:\Users\test\AppData\Local\Programs\oh-my-posh\themes\atomic.omp.json" | Invoke-Expression

#same directory as profile
$omp_config = Join-Path $PSScriptRoot ".\shanselman_v3-v2.json"
oh-my-posh --init --shell pwsh --config $omp_config | Invoke-Expression

# url
#oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/jandedobbeleer.omp.json' | Invoke-Expression