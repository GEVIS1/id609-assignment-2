# https://thomasthornton.cloud/2020/02/05/application-security-group-assignment-using-powershell/

$asg1Config = @{
    ResourceGroupName = $ResourceGroupName
    Name = "AsgServers"
    Location = $Location
}
$asg2Config = @{
    ResourceGroupName = $ResourceGroupName
    Name = "AsgWork"
    Location = $Location
}
$nsg1Config = @{
    ResourceGroupName = $ResourceGroupName
    Name = "NSG-ABC"
    Location = $Location
}

$asg1 = New-AzApplicationSecurityGroup @asg1Config
$asg2 = New-AzApplicationSecurityGroup @asg2Config
$nsg1 = New-AzNetworkSecurityGroup @nsg1Config

# Add/create rules: https://adamtheautomator.com/azure-nsg/#:~:text=To%20create%20an%20Azure%20NSG,NSG%20under%2C%20and%20the%20location.