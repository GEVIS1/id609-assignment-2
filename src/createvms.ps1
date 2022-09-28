# Get the login credentials for the two VMs
$cred = Get-Credential

# Make sure we are connected to Azure
Connect-AzAccount

# Create the virtual network
$virtualnetwork = New-AzVirtualNetwork -ResourceGroupName "ID609OE1-gevis1" -Location "australiaeast" -Name "steffen-vnet" -AddressPrefix 10.1.0.0/16

# Create the subnet
Add-AzVirtualNetworkSubnetConfig -VirtualNetwork $virtualnetwork -Name "steffen-subnet" -AddressPrefix 10.1.0.0/24

# VM1 config
$vm1config = @{
ResourceGroupName="ID609OE1-gevis1"
Location="australiaeast"
Name="steffenc911"
Image="win2019Datacenter" 
Size="Standard_B2s"
PublicIpAddressName="steffen-publicip1"
VirtualNetworkName="steffen-vnet"
SubnetName="steffen-subnet"
OpenPorts=3389,22
Credential=$cred
}

# VM2 config
$vm2config = @{
ResourceGroupName="ID609OE1-gevis1"
Location="australiaeast"
Name="steffenc912"
Image="win2019Datacenter" 
Size="Standard_B2s"
PublicIpAddressName="steffen-publicip2"
VirtualNetworkName="steffen-vnet"
SubnetName="steffen-subnet"
OpenPorts=3389,22
Credential=$cred
}

# Create the VMs
$vm1 = New-AzVM @vm1config
$vm2 = New-AzVM @vm2config

# Connect to the VMs with RDP
Get-AzRemoteDesktopFile -ResourceGroupName $vm1.ResourceGroupName -Name $vm1.Name -Launch
Get-AzRemoteDesktopFile -ResourceGroupName $vm2.ResourceGroupName -Name $vm2.Name -Launch
