#oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\atomic.omp.json" | Invoke-Expression
#oh-my-posh init pwsh --config "C:\Users\test\AppData\Local\Programs\oh-my-posh\themes\atomic.omp.json" | Invoke-Expression

$omp_config = Join-Path $PSScriptRoot ".\shanselman_v3-v2.json"



oh-my-posh --init --shell pwsh --config $omp_config | Invoke-Expression

#alias
Set-Alias ip ipconfig


function hosts { notepad c:\windows\system32\drivers\etc\hosts }


# Alias
Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
Set-Alias ip ipconfig

# adding hosts shorcut 
function hosts { notepad c:\windows\system32\drivers\etc\hosts }

# Utilities
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# Env
$env:GIT_SSH = "C:\Windows\system32\OpenSSH\ssh.exe"
#plugin 
Import-Module -Name Terminal-Icons

# PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History


# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# hardward display 
Write-Host "installing fastfetch"
winget install fastfetch
fastfetch -c hardware