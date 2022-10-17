$VirtualNetworkName = "vnetgevis1"
$ResourceGroupName = "ID609OE1-gevis1"
$Asg1Name = "AsgServers"
$Asg2Name = "AsgWork"
$NsgName = "NSG-ABC"
$ServerAName="ServerA"
$ServerBName = "ServerB"
$ServerCName = "ServerC"

Remove-AzVM -Name $ServerAName -ResourceGroupName $ResourceGroupName -ForceDeletion $true -Force
Remove-AzVM -Name $ServerBName -ResourceGroupName $ResourceGroupName -ForceDeletion $true -Force
Remove-AzVM -Name $ServerCName -ResourceGroupName $ResourceGroupName -ForceDeletion $true -Force
Remove-AzNetworkSecurityGroup -Name $NsgName -ResourceGroupName $ResourceGroupName -Force
Remove-AzApplicationSecurityGroup -Name $Asg1Name -ResourceGroupName $ResourceGroupName -Force
Remove-AzApplicationSecurityGroup -Name $Asg2Name -ResourceGroupName $ResourceGroupName -Force
Remove-AzVirtualNetwork -Name $VirtualNetworkName -ResourceGroupName $ResourceGroupName -Force
