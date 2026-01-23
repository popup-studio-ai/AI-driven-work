# Claude Code Installer for Windows (Developer Edition with Docker)
# Usage: powershell -ep bypass -File install_dev.ps1

# Hide default progress bar
$ProgressPreference = 'SilentlyContinue'

# Get script path for admin re-launch
$ScriptPath = $MyInvocation.MyCommand.Path

# Check admin privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Administrator privileges required. Restarting as admin..." -ForegroundColor Yellow
    Start-Process PowerShell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File `"$ScriptPath`""
    exit
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Blue
Write-Host "   Claude Code Installer (Docker)" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue
Write-Host ""

$tempDir = "$env:TEMP\ClaudeCodeSetup"
if (-not (Test-Path $tempDir)) {
    New-Item -ItemType Directory -Path $tempDir | Out-Null
}

function Write-Status {
    param([string]$Message)
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-Downloading {
    param([string]$Message)
    Write-Host "[..] Downloading $Message..." -ForegroundColor Yellow
}

function Write-Installing {
    param([string]$Message)
    Write-Host "    Installing..." -ForegroundColor Gray
}

function Write-Skip {
    param([string]$Message)
    Write-Host "[OK] $Message (already installed)" -ForegroundColor Green
}

# Download with progress bar using BITS
function Download-WithProgress {
    param(
        [string]$Url,
        [string]$OutFile,
        [string]$Name
    )

    # Start async BITS transfer
    $job = Start-BitsTransfer -Source $Url -Destination $OutFile -DisplayName $Name -Asynchronous

    # Show progress
    while ($job.JobState -eq "Transferring" -or $job.JobState -eq "Connecting") {
        $percent = 0
        if ($job.BytesTotal -gt 0) {
            $percent = [math]::Round(($job.BytesTransferred / $job.BytesTotal) * 100)
        }
        $barLength = 30
        $filled = [math]::Floor($percent * $barLength / 100)
        $empty = $barLength - $filled
        $bar = "[" + ("=" * $filled) + (" " * $empty) + "]"
        Write-Host -NoNewline "`r    $bar $percent%  "
        Start-Sleep -Milliseconds 200
    }

    # Complete the transfer
    if ($job.JobState -eq "Transferred") {
        Complete-BitsTransfer -BitsJob $job
        Write-Host -NoNewline "`r    [==============================] 100%  "
        Write-Host ""
    } else {
        # Fallback if BITS fails
        Remove-BitsTransfer -BitsJob $job -ErrorAction SilentlyContinue
        Write-Host ""
        Write-Host "    Downloading (fallback)..." -ForegroundColor Gray
        Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing
    }
}

# Node.js install
function Install-NodeJS {
    $nodeCheck = Get-Command node -ErrorAction SilentlyContinue
    if ($nodeCheck) {
        $version = & node --version
        Write-Skip "Node.js ($version)"
    } else {
        Write-Downloading "Node.js"
        $nodeUrl = "https://nodejs.org/dist/v20.11.0/node-v20.11.0-x64.msi"
        $nodePath = "$tempDir\node-setup.msi"

        Download-WithProgress -Url $nodeUrl -OutFile $nodePath -Name "Node.js"

        Write-Installing "Node.js"
        Start-Process msiexec.exe -ArgumentList "/i `"$nodePath`" /qn" -Wait

        # Refresh PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

        Write-Status "Node.js installed"
    }
}

# Git install
function Install-Git {
    $gitCheck = Get-Command git -ErrorAction SilentlyContinue
    if ($gitCheck) {
        $version = & git --version
        Write-Skip "Git ($version)"
    } else {
        Write-Downloading "Git"
        $gitUrl = "https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe"
        $gitPath = "$tempDir\git-setup.exe"

        Download-WithProgress -Url $gitUrl -OutFile $gitPath -Name "Git"

        Write-Installing "Git"
        Start-Process $gitPath -ArgumentList "/VERYSILENT /NORESTART" -Wait

        # Refresh PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

        Write-Status "Git installed"
    }
}

# VS Code install
function Install-VSCode {
    $vscodePaths = @(
        "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe",
        "$env:ProgramFiles\Microsoft VS Code\Code.exe"
    )

    $installed = $false
    foreach ($path in $vscodePaths) {
        if (Test-Path $path) {
            $installed = $true
            break
        }
    }

    if ($installed) {
        Write-Skip "VS Code"
    } else {
        Write-Downloading "VS Code"
        $vscodeUrl = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64"
        $vscodePath = "$tempDir\vscode-setup.exe"

        Download-WithProgress -Url $vscodeUrl -OutFile $vscodePath -Name "VS Code"

        Write-Installing "VS Code"
        Start-Process $vscodePath -ArgumentList "/VERYSILENT /NORESTART /MERGETASKS=!runcode" -Wait

        # Refresh PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

        Write-Status "VS Code installed"
    }
}

# Add npm global path to PATH
function Add-NpmGlobalPath {
    $npmGlobalPath = "$env:APPDATA\npm"

    # Create npm directory if it doesn't exist
    if (-not (Test-Path $npmGlobalPath)) {
        New-Item -ItemType Directory -Path $npmGlobalPath -Force | Out-Null
    }

    # Check if already in User PATH
    $userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
    if ($userPath -notlike "*$npmGlobalPath*") {
        # Add to User PATH permanently
        [System.Environment]::SetEnvironmentVariable("Path", "$userPath;$npmGlobalPath", "User")
        Write-Host "[OK] npm global path added to PATH" -ForegroundColor Green
    }

    # Also add to current session
    if ($env:Path -notlike "*$npmGlobalPath*") {
        $env:Path = "$env:Path;$npmGlobalPath"
    }
}

# Claude Code CLI install
function Install-ClaudeCLI {
    Write-Host "[..] Installing Claude Code CLI..." -ForegroundColor Yellow

    # Add npm global path first
    Add-NpmGlobalPath

    $npmPath = Get-Command npm -ErrorAction SilentlyContinue
    if ($npmPath) {
        & npm install -g @anthropic-ai/claude-code 2>$null
        Write-Status "Claude Code CLI installed"
    } else {
        Write-Host "[!!] npm not found. Please restart terminal and try again." -ForegroundColor Red
    }
}

# VS Code extension install
function Install-VSCodeExtension {
    Write-Host "[..] Installing VS Code Claude Extension..." -ForegroundColor Yellow

    $codePaths = @(
        "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd",
        "$env:ProgramFiles\Microsoft VS Code\bin\code.cmd"
    )

    $codePath = $null
    foreach ($path in $codePaths) {
        if (Test-Path $path) {
            $codePath = $path
            break
        }
    }

    if ($codePath) {
        & $codePath --install-extension anthropic.claude-code 2>$null
        Write-Status "VS Code Claude Extension installed"
    } else {
        $codeCheck = Get-Command code -ErrorAction SilentlyContinue
        if ($codeCheck) {
            & code --install-extension anthropic.claude-code 2>$null
            Write-Status "VS Code Claude Extension installed"
        } else {
            Write-Host "[!!] VS Code not found." -ForegroundColor Red
        }
    }
}

# WSL install
function Install-WSL {
    # Check if WSL is already installed and working
    $wslCheck = Get-Command wsl -ErrorAction SilentlyContinue
    if ($wslCheck) {
        try {
            $wslList = wsl --list 2>$null
            if ($LASTEXITCODE -eq 0 -and $wslList) {
                Write-Skip "WSL"
                return $false  # No reboot needed
            }
        } catch {}
    }

    Write-Host "[..] Installing WSL..." -ForegroundColor Yellow

    # Enable WSL feature using DISM (more reliable, no popup)
    try {
        # Enable WSL feature
        dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart 2>$null | Out-Null

        # Enable Virtual Machine Platform
        dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart 2>$null | Out-Null

        Write-Status "WSL installed (reboot required)"
        return $true  # Reboot needed
    } catch {
        Write-Host "[!!] WSL installation failed. Please install manually: wsl --install" -ForegroundColor Red
        return $false
    }
}

# Docker Desktop install
function Install-Docker {
    # Check if Docker is already installed
    $dockerPaths = @(
        "$env:ProgramFiles\Docker\Docker\Docker Desktop.exe",
        "$env:LOCALAPPDATA\Docker\Docker Desktop.exe"
    )

    $installed = $false
    foreach ($path in $dockerPaths) {
        if (Test-Path $path) {
            $installed = $true
            break
        }
    }

    if ($installed) {
        Write-Skip "Docker Desktop"
        return
    }

    Write-Downloading "Docker Desktop"
    $dockerUrl = "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
    $dockerPath = "$tempDir\DockerDesktopInstaller.exe"

    Download-WithProgress -Url $dockerUrl -OutFile $dockerPath -Name "Docker Desktop"

    Write-Installing "Docker Desktop"
    Start-Process $dockerPath -ArgumentList "install --quiet --accept-license" -Wait

    Write-Status "Docker Desktop installed"
}

# ============================================
# Main install process
# ============================================
Write-Host "Starting installation..." -ForegroundColor White
Write-Host ""

# Basic tools
Install-NodeJS
Install-Git
Install-VSCode
Install-ClaudeCLI
Install-VSCodeExtension

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Installing Docker Environment" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# WSL and Docker
$needReboot = Install-WSL
Install-Docker

# Cleanup temp files
if (Test-Path $tempDir) {
    Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

if ($needReboot) {
    Write-Host "IMPORTANT: Reboot required!" -ForegroundColor Red
    Write-Host ""
    Write-Host "After reboot:" -ForegroundColor Yellow
    Write-Host "  1. Open Docker Desktop"
    Write-Host "  2. Accept the license agreement"
    Write-Host "  3. Wait for Docker to start"
    Write-Host "  4. Then run the MCP setup script"
    Write-Host ""

    $rebootNow = Read-Host "Reboot now? (Y/n)"
    if ($rebootNow -ne "n" -and $rebootNow -ne "N") {
        Write-Host ""
        Write-Host "Rebooting in 5 seconds..." -ForegroundColor Yellow
        Start-Sleep -Seconds 5
        Restart-Computer -Force
    } else {
        Write-Host ""
        Write-Host "Please reboot manually to complete WSL setup." -ForegroundColor Yellow
    }
} else {
    Write-Host "Next steps:" -ForegroundColor White
    Write-Host "  1. Open Docker Desktop and accept license"
    Write-Host "  2. Wait for Docker to start"
    Write-Host "  3. Open VS Code"
    Write-Host "  4. Click Claude icon in the left sidebar"
    Write-Host "  5. Login to Claude"
    Write-Host ""
    Write-Host "Or run 'claude' command in terminal."
    Write-Host ""

    # Open guide page
    $openGuide = Read-Host "Open setup guide page? (Y/n)"
    if ($openGuide -ne "n" -and $openGuide -ne "N") {
        Start-Process "https://bkamp.ai/ko/showcases/de04a7ec-50d7-4f8e-a741-f2cdb4753543"
    }

    # Open Docker Desktop
    $openDocker = Read-Host "Open Docker Desktop? (Y/n)"
    if ($openDocker -ne "n" -and $openDocker -ne "N") {
        $dockerPath = "$env:ProgramFiles\Docker\Docker\Docker Desktop.exe"
        if (Test-Path $dockerPath) {
            Start-Process $dockerPath
        }
    }
}

Write-Host ""
Write-Host "Setup complete. Press any key to close..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
