# Storage account creation new version.

$version = 'DeploymentStorageAccountAzure v1.0'

<#
DeploymentStorageAccountAzure

(C) 



TODO Enhancements
[X] Create a new storage account
[] xxxx
[] ..........
#>


#Import Module
Import-Module -Name AzureRM.Storage
Import-Module -Name AzureRM.Profile


###########################
### Variables ###
###########################

$subscriptionname = Enter the subscription name here
$Ipwhitelist = enter here the Ip address to create whitelist like 123.123.123.123
$containername = enter here the container name

$accesstier = hot or cold

$skuname = Standard_LRS or RO_LRS

$storageversion = StorageV2 or V1

$virtualnetworkt11 = enter the information /subscriptions/cxc-cxcxc-cxcx-xccx-xcxc/resourceGroups/cxcxxcxc/providers/Microsoft.Network/virtualNetworks/cxcxxccx/subnets/networkname
$virtualnetworkt21 = enter the information /subscriptions/cxc-cxcxc-cxcx-xccx-xcxc/resourceGroups/cxcxxcxc/providers/Microsoft.Network/virtualNetworks/cxcxxccx/subnets/networkname
$virtualnetworkt31 = enter the information /subscriptions/cxc-cxcxc-cxcx-xccx-xcxc/resourceGroups/cxcxxcxc/providers/Microsoft.Network/virtualNetworks/cxcxxccx/subnets/networkname

$virtualnetworkt12 = enter the information /subscriptions/cxc-cxcxc-cxcx-xccx-xcxc/resourceGroups/cxcxxcxc/providers/Microsoft.Network/virtualNetworks/cxcxxccx/subnets/networkname
$virtualnetworkt22 = enter the information /subscriptions/cxc-cxcxc-cxcx-xccx-xcxc/resourceGroups/cxcxxcxc/providers/Microsoft.Network/virtualNetworks/cxcxxccx/subnets/networkname
$virtualnetworkt32 = enter the information /subscriptions/cxc-cxcxc-cxcx-xccx-xcxc/resourceGroups/cxcxxcxc/providers/Microsoft.Network/virtualNetworks/cxcxxccx/subnets/networkname




###########################
### C O N N E C T I O N ###
###########################


$env = Get-AzureRmEnvironment -Name AzureCloud
Login-AzureRmAccount -Environment $env

Select-AzureRmSubscription -SubscriptionName $subscriptionname




function MainMenu {
    $leave = 0
    $title = "-- Main Menu --"
    $message = "Select command:"
    $optN = New-Object System.Management.Automation.Host.ChoiceDescription "&New Storage Account", "Create a New Storage Account."
    $optX = New-Object System.Management.Automation.Host.ChoiceDescription "E&xit", "Exit the program."
    $options = [System.Management.Automation.Host.ChoiceDescription[]]($optN, $optX)

    do {

        $result = $host.ui.PromptForChoice($title, $message, $options, 1)
        Write-Host

        switch ($result) {
            0 { NewStorageAccount; break }
            1 { Write-Host "Goodbye !"; $leave = 1; break }
        }
    } while ($leave -ne 1)
}



function NewStorageAccount {

    $locationarray = @(Get-AzureRmLocation).Location
    $menu = @{ }
    for ($i = 1; $i -le $locationarray.count; $i++) {
        Write-Host "$i. $($locationarray[$i-1])"
        $menu.Add($i, ($locationarray[$i - 1]))
    }
    [int]$ans = Read-Host 'Enter the location or X to exit'
    $selection = $menu.Item($ans)
    $Location = $selection


    $ResourceGrouparray = @(Get-AzureRmResourceGroup).ResourceGroupName
    $menu = @{ }
    for ($i = 1; $i -le $ResourceGrouparray.count; $i++) {
        Write-Host "$i. $($ResourceGrouparray[$i-1])"
        $menu.Add($i, ($ResourceGrouparray[$i - 1]))
    }
    [int]$ans = Read-Host 'Enter Resource Group or X to exit'
    $selection1 = $menu.Item($ans)
    $ResourceGroup = $selection1



    $EnvironmentCoris = @("test1", "test2", "Prod")
    $menu = @{ }
    for ($i = 1; $i -le $EnvironmentCoris.count; $i++) {
        Write-Host "$i. $($EnvironmentCoris[$i-1])"
        $menu.Add($i, ($EnvironmentCoris[$i - 1]))
    }
    [int]$ans = Read-Host 'Enter Environment or X to exit'
    $selection2 = $menu.Item($ans)
    $EnvironmentCoris = $selection2

    switch ( $EnvironmentCoris ) {
        test1 {
            Write-Host "The name needs to have 8"
    $name = Read-Host "Enter the Storage Account Name"
            New-AzureRmStorageAccount -EnableHttpsTrafficOnly $true -ResourceGroupName $ResourceGroup -Location  $Location -AccessTier $accesstier -SkuName $skuname -Name $name -Kind $storageversion -NetworkRuleSet (@{bypass = "Logging,Metrics";
    ipRules= (@{IPAddressOrRange = "$Ipwhitelist"; Action = "allow" });
    virtualNetworkRules=(@{VirtualNetworkResourceId = "$virtualnetworkt11"; Action = "allow"},
            @{VirtualNetworkResourceId = "$virtualnetworkt21"; Action = "allow" },
            @{VirtualNetworkResourceId = "$virtualnetworkt31"; Action = "allow" });
            defaultAction = "Deny"}) |Out-Null

            New-AzureRmStorageContainer -ResourceGroupName $ResourceGroup -StorageAccountName $name -Name $containername |Out-Null
        

            Write-Host " The storage account $name was created successfully"
        }
        test2 {
            Write-Host "The name needs to have 8"
    $name = Read-Host "Enter the Storage Account Name"
            New-AzureRmStorageAccount -EnableHttpsTrafficOnly $true -ResourceGroupName $ResourceGroup -Location  $Location -AccessTier $accesstier -SkuName $skuname -Name $name -Kind $storageversion -NetworkRuleSet (@{bypass = "Logging,Metrics";
    ipRules= (@{IPAddressOrRange = "$Ipwhitelist"; Action = "allow" });
    virtualNetworkRules=(@{VirtualNetworkResourceId = "$virtualnetworkt12"; Action = "allow"},
        @{VirtualNetworkResourceId = "$virtualnetworkt22"; Action = "allow" },
        @{VirtualNetworkResourceId = "$virtualnetworkt32"; Action = "allow" });
        defaultAction = "Deny"}) |Out-Null

            New-AzureRmStorageContainer -ResourceGroupName $ResourceGroup -StorageAccountName $name -Name $containername | Out-Null
         

            Write-Host " The storage account $name was created successfully"
        }
        Prod {


            Write-host "Will be implemented in the future"



        }
    }

}
    #Initialize
    MainMenu

