# Get the login credentials for the VMs. Ideally this would be three separate credentials, but it is one here for convenience.
#$cred = Get-Credential -Message "Input credentials for VMS"

# Get the vnet
$vnet = $(Get-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Name $VirtualNetworkName)
Write-Host "Writing subnet names from `$vnet"
Write-Host $vnet.Subnets[0].Name
Write-Host $vnet.Subnets[1].Name
Write-Host $vnet.Subnets[2].Name
Write-Host $vnet.Subnets[3].Name
Write-Host "Writing subnet names from `$subnet#"
Write-Host $subnet1
Write-Host $subnet2
Write-Host $subnet3

# Server A config
#$nic1 = New-AzNetworkInterface -Name ServerANIC -ResourceGroupName $ResourceGroupName -Location $Location -SubnetId $vnet.Subnets[0].Id

# $vm1config = @{
# ResourceGroupName=$ResourceGroupName
# Location=$Location
# Name="steffenc911"
# Image="win2019Datacenter" 
# Size="Standard_B2s"
# VirtualNetworkName="steffen-vnet"
# SubnetName="steffen-subnet"
# OpenPorts=3389,22
# Credential=$cred
# }

# # Create the VMs
# $vm1 = New-AzVM @vm1config
# $vm2 = New-AzVM @vm2config

# # Connect to the VMs with RDP
# Get-AzRemoteDesktopFile -ResourceGroupName $ResourceGroupName -Name $vm1.Name -Launch
# Get-AzRemoteDesktopFile -ResourceGroupName $ResourceGroupName -Name $vm2.Name -Launch

