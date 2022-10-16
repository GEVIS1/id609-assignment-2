# Create the virtual network
$virtualnetwork = New-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Location $Location -Name $VirtualNetworkName -AddressPrefix 192.168.0.0/16

# Create the subnets
Add-AzVirtualNetworkSubnetConfig -VirtualNetwork $virtualnetwork -Name "subnet1" -AddressPrefix 192.168.1.0/24
Add-AzVirtualNetworkSubnetConfig -VirtualNetwork $virtualnetwork -Name "subnet2" -AddressPrefix 192.168.2.0/24
Add-AzVirtualNetworkSubnetConfig -VirtualNetwork $virtualnetwork -Name "subnet3" -AddressPrefix 192.168.3.0/24
