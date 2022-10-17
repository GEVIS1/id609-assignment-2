# Debug
Set-PSDebug -Trace 0

# Remove noise from terminal
Update-AzConfig -DisplayBreakingChangeWarning $false | Out-Null

# Ensure we are in the folder of the script
Set-Location $PSScriptRoot

$resetPolicy = $false

# Constants:
$Location = "australiaeast"
$VirtualNetworkName = "vnetgevis1"
$ResourceGroupName = "ID609OE1-gevis1"
$Subnet1Name = "subnet1"
$Subnet2Name = "subnet2"
$Subnet3Name = "subnet3"
$ServerAName = "ServerA"
$ServerBName = "ServerB"
$ServerCName = "ServerC"
$ServerAImage = "win2019Datacenter" 
$ServerBImage = "win2019Datacenter" 
$ServerCImage = "win2019Datacenter"  
$VMSize = "Standard_B2s"

# Confirm the Az tools are installed
if (!(Get-Command Connect-AzAccount -errorAction SilentlyContinue)) {
    $resetPolicy = $true
    $oldPolicy = Get-ExecutionPolicy
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
    Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force -AllowClobber
}

# Make sure we are connected to Azure
if (!(Get-AzAccessToken -ErrorAction SilentlyContinue)) {
    Connect-AzAccount
}

# ASG/NSG configs
$asg1Config = @{
    ResourceGroupName = $ResourceGroupName
    Name              = "AsgServers"
    Location          = $Location
}
$asg2Config = @{
    ResourceGroupName = $ResourceGroupName
    Name              = "AsgWork"
    Location          = $Location
}
$nsg1Config = @{
    ResourceGroupName = $ResourceGroupName
    Name              = "NSG-ABC"
    Location          = $Location
}

Write-Host "Creating Security Groups"
# Create the security groups
$asg1 = New-AzApplicationSecurityGroup @asg1Config
$asg2 = New-AzApplicationSecurityGroup @asg2Config
$nsg1 = New-AzNetworkSecurityGroup @nsg1Config



Write-Host "Creating Subnets"
# Create the subnets
$subnet1 = New-AzVirtualNetworkSubnetConfig -Name $Subnet1Name -AddressPrefix "192.168.1.0/24" -NetworkSecurityGroup $nsg1
$subnet2 = New-AzVirtualNetworkSubnetConfig -Name $Subnet2Name -AddressPrefix "192.168.2.0/24" -NetworkSecurityGroup $nsg1
$subnet3 = New-AzVirtualNetworkSubnetConfig -Name $Subnet3Name -AddressPrefix "192.168.3.0/24" -NetworkSecurityGroup $nsg1

Write-Host "Creating Virtual network"
# Create the virtual network
$virtualnetwork = New-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Location $Location -Name $VirtualNetworkName -AddressPrefix 192.168.0.0/16 -Subnet $subnet1,$subnet2,$subnet3


# Add/create rules: https://adamtheautomator.com/azure-nsg/#:~:text=To%20create%20an%20Azure%20NSG,NSG%20under%2C%20and%20the%20location.


Write-Host "Creating Virtual Machines"
# Get the login credentials for the VMs. Ideally this would be three separate credentials, but it is one here for convenience.
$cred = Get-Credential -Message "Input credentials for VMS"

# Server A config
# For some reason splatting stopped working properly, so no splatting.
Write-Host "`t$ServerAName"
$ServerAObject = New-AzVM -ResourceGroupName $ResourceGroupName -Location $Location -Name $ServerAName -Image $ServerAImage -Size $VMSize -VirtualNetworkName $VirtualNetworkName -SubnetName $subnet1.Name -Credential $cred -PublicIpAddressName "$ServerAName-public"
# Setup Subnet and ASG
$nic1 = Get-AzNetworkInterface -Name $ServerAObject.Name -ResourceGroupName $ResourceGroupName
$nic1 | Set-AzNetworkInterfaceIpConfig -Name $ServerAName -Subnet $subnet1 -ApplicationSecurityGroup $asg1 | Out-Null
$nic1 | Set-AzNetworkInterface | Out-Null
# Setup NSG
$nic1.NetworkSecurityGroup = $nsg1




# Server B config
Write-Host "`t$ServerBName"
$ServerAObject = New-AzVM -ResourceGroupName $ResourceGroupName -Location $Location -Name $ServerBName -Image $ServerBImage -Size $VMSize -VirtualNetworkName $VirtualNetworkName -SubnetName $subnet2.Name -Credential $cred
# Setup Subnet and ASG
$nic2 = Get-AzNetworkInterface -Name $ServerAObject.Name -ResourceGroupName $ResourceGroupName
$nic2 | Set-AzNetworkInterfaceIpConfig -Name $ServerAName -SubnetId $subnet2.Id -ApplicationSecurityGroup $asg1 | Out-Null
$nic2 | Set-AzNetworkInterface | Out-Null
# Setup NSG
$nic2.NetworkSecurityGroup = $nsg1



# Server C config
Write-Host "`t$ServerCName"
$ServerAObject = New-AzVM -ResourceGroupName $ResourceGroupName -Location $Location -Name $ServerCName -Image $ServerCImage -Size $VMSize -VirtualNetworkName $VirtualNetworkName -SubnetName $subnet3.Name -Credential $cred
# Setup Subnet and ASG
$nic3 = Get-AzNetworkInterface -Name $ServerAObject.Name -ResourceGroupName $ResourceGroupName
$nic3 | Set-AzNetworkInterfaceIpConfig -Name $ServerAName -SubnetId $subnet3.Id -ApplicationSecurityGroup $asg2 | Out-Null
$nic3 | Set-AzNetworkInterface | Out-Null
# Setup NSG
$nic3.NetworkSecurityGroup = $nsg1

Write-Host "Setting up routing appliance"
# Setup routing applicance in subnet1
$publicIp = Get-AzPublicIpAddress -Name "$ServerAName-public" -ResourceGroupName $ResourceGroupName

$routeServer = @{
    RouteServerName = 'routeServer'
    ResourceGroupName = $ResourceGroupName
    Location = $Location
    HostedSubnet = $subnet1.Id
    PublicIP = $publicIp
}
New-AzRouteServer @routeServer | Out-Null

# Get-AzRemoteDesktopFile -ResourceGroupName $ResourceGroupName -Name $ServerAName -Launch
# Get-AzRemoteDesktopFile -ResourceGroupName $ResourceGroupName -Name $ServerBName -Launch
# Get-AzRemoteDesktopFile -ResourceGroupName $ResourceGroupName -Name $ServerCName -Launch


# Write-Host "Creating Routes"
# Write-Host "Configuring Active Directory"
if ($resetPolicy) {
    Set-ExecutionPolicy -ExecutionPolicy $oldPolicy
}
