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
    winget install -e --accept-source-agreements --accept-package-agreements JanDeDobbeleer.OhMyPosh
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
winget install --id=Neovim.Neovim -e

#install git 
try {
  # Check if Git is installed using a reliable method
  if (!(Test-Path (Get-Item "C:\Program Files\Git\bin\git.exe"))){
    winget install -e -h --accept-source-agreements --accept-package-agreements --id Git.Git -e --source winget
        Write-Host "Git Installed com plete."
  } else
       {
    Write-Host "Git  already  installed."
       }
} 
catch {
  Write-Error "Failed to install psreadline. Error: $_"
} 



Write-Host "Install nodejs"
Install NODE: WINGET INSTALL OPENJS.NODEJS.ltS

#install scoop 
Write-Host "Install scoop"
iwr -useb get.scoop.sh | iex

# Choco install
try {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}
catch {
    Write-Error "Failed to install Chocolatey. Error: $_"
}




#check porfile exist, if  not create 
if (!(Test-Path -Path $PROFILE -PathType Leaf)) {
    try {
        # Detect Version of PowerShell & Create Profile directories if they do not exist.
        $profilePath = ""
        if ($PSVersionTable.PSEdition -eq "Core") { 
            $profilePath = "$env:userprofile\Documents\Powershell"
        }
        elseif ($PSVersionTable.PSEdition -eq "Desktop") {
            $profilePath = "$env:userprofile\Documents\WindowsPowerShell"
        }

        if (!(Test-Path -Path $profilePath)) {
            New-Item -Path $profilePath -ItemType "directory"
        }
	echo "ok1"
        #Invoke-RestMethod https://github.com/ChrisTitusTech/powershell-profile/raw/main/Microsoft.PowerShell_profile.ps1 -OutFile $PROFILE
		Invoke-RestMethodhttps://raw.githubusercontent.com/chenchih/Env_Setup_Note/master/Terminal/ohmyposh/Microsoft.PowerShell_profile.ps1 -OutFile $PROFILE
        Write-Host "The profile @ [$PROFILE] has been created."
 
    }
    catch {
        Write-Error "Failed to create or update the profile. Error: $_"
    }
}
#if profile exist, backup, and create profile
else {
    try {
	#step1: backup file
	#method1 Set-Content
        #Get-Item -Path $PROFILE | Move-Item -Destination "oldprofile.ps1" -Force
	#method2 copy-item (backup current profile)
                 #copy old profile and backup the profile 
	Copy-Item -Path $PROFILE -Destination $PROFILE'.bk' -Force
        # Copy-Item -Path $PROFILE -Destination "oldprofile.ps1"

	#step2 create profile
	#create empty profile 
	#New-Item -Path $PROFILE -Type File ¡VForce 
	# create profile contain theme
	oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\iterm2.omp.json" | Invoke-Expression >> $profile

	#create profile  by  download files from URLs
        #$Inoke-RestMethod https://github.com/ChrisTitusTech/powershell-profile/raw/main/Microsoft.PowerShell_profile.ps1 -OutFile $PROFILE
        Write-Host "The profile @ [$PROFILE] has been created and old profile removed."
      
    }
    catch {
        Write-Error "Failed to backup and update the profile. Error: $_"
    }
}