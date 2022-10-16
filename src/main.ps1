$resetPolicy = $false

# Constants:
$Location = "australiaeast"
$VirtualNetworkName = "vnetgevis1"
$ResourceGroupName = "ID609OE1-gevis1"

# Ensure we are in the folder of the script
Set-Location $PSScriptRoot

# Confirm the Az tools are installed
if (!(Get-Command Connect-AzAccount -errorAction SilentlyContinue)) {
    $resetPolicy = $true
    $oldPolicy = Get-ExecutionPolicy
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force -AllowClobber
}

# Make sure we are connected to Azure
if (!(Get-AzAccessToken -ErrorAction SilentlyContinue)) {
    Connect-AzAccount
}

# Run the separate scripts
Write-Host "Creating Network"
& .\createnetwork.ps1
Write-Host "Creating Application Security Groups"
& .\createasg.ps1
Write-Host "Creating Virtual Machines"
#.\createvms.ps1
Write-Host "Creating Routes"
Write-Host "Configuring Active Directory"
if ($resetPolicy) {
    Set-ExecutionPolicy -ExecutionPolicy $oldPolicy
}