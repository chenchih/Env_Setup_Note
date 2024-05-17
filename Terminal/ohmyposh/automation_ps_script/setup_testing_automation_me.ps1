#CHECK WINGET AND INSTALL

$progressPreference = 'silentlyContinue'
# Check for Winget installation
if ((Test-Path "%LOCALAPPDATA%\Microsoft\WindowsApps\winget.exe")) {
  # Download Winget installer (modify URL if needed)

    Write-Information "Downloading WinGet and its dependencies..."
    Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle


     # Install Winget silently (modify arguments if needed)
    Write-Host "Installing Winget..."
  Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
  

  Write-Host "Winget installation successful."
} else {
  Write-Host "Winget is already installed."
}



#window terminal

if (!(Test-Path "%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe.xml")) {
  Write-Host "Install Window terminal"
  winget install Microsoft.WindowsTerminal
  Write-Host "Windows Terminal installed completed"
}
else {

Write-Host "Windows Terminal is installed."
}

# install and check powercore shell
if (Test-Path "%ProgramFiles%\PowerShell\7\powershell.exe") {
  Write-Host "PowerShell Core is likely installed (version 7)."
} else {
  Write-Host "PowerShell Core might not be installed, prepare to installing "
  winget install Microsoft.Powershell
  Write-Host "PowerShell Core complete install "
}

# Install and Check Oh My Posh module
if (Get-Module -ListAvailable -Name Oh-My-Posh) {
    Write-Host "Oh My Posh is installed."
    Write-Host "Oh My Posh upgrade"
    winget upgrade JanDeDobbeleer.OhMyPosh -s winget

    
} 
else {
    Write-Host "installing Oh My Posh ...."
    winget install JanDeDobbeleer.OhMyPosh    
    Write-Host "Oh My Posh completed...."
    Write-Host "Oh My Posh upgrade"
    winget upgrade JanDeDobbeleer.OhMyPosh -s winget
}



# Terminal Icons Install
try {
    Install-Module -Name Terminal-Icons -Repository PSGallery -Force
}
catch {
    Write-Error "Failed to install Terminal Icons module. Error: $_"
}

# zoxide Install
try {
    winget install -e --id ajeetdsouza.zoxide
    Write-Host "zoxide installed successfully."
}
catch {
    Write-Error "Failed to install zoxide. Error: $_"
}

#psreadline
try {
    Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck
}
catch {
    Write-Error "Failed to install psreadline. Error: $_"
}


# install other tool
Write-Host "Install VSCODE...."
winget install vscode
Write-Host "Install neovim"
winget install --id=Neovim.Neovim ¡Ve
Write-Host "Install git"
winget install --id Git.Git -e --source winget
Write-Host "Install nodejs"
Install NODE: WINGET INSTALL OPENJS.NODEJS.ltS
Write-Host "Install scoop"
iwr -useb get.scoop.sh | iex