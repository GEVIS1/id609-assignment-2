# Get the login credentials for the VMs. Ideally this would be three separate credentials, but it is one here for convenience.
$cred = Get-Credential -Message "Input credentials for VMS"

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

