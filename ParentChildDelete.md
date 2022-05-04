
## The problem

The bicep file [vnetparentchild.bicep](bicep/vnetparentchild.bicep) creates vnet, subnet and dns resources.
My expectation is that subsequent deployments of the bicep will result in no changes to the resources, however errors during redeployment and modification notices in the what-if results tell a different story.

## Reproducing it

```azurecli
az group create -g innerloopsweden -l swedencentral

az deployment group create -g innerloopsweden -f .\bicep\vnetparentchild.bicep

az deployment group what-if -g innerloopsweden -f .\bicep\vnetparentchild.bicep

# Deploy something into that vnet


az deployment group create -g innerloopsweden -f .\bicep\vnetparentchild.bicep
```

## The What-If

The resource group already contains a deployment using the same input parameters.
I'd expect no changes to be made, however you can see 3 changes.

1. Log Analytics customer id (not worrying about this)
2. Vnet properties.subnets
3. Subnet properties.delegations

```text
az deployment group what-if -g innerloopsweden -f .\bicep\vnetparentchild.bicep 
Note: The result may contain false positive predictions (noise).
You can help us improve the accuracy of the result by opening an issue here: https://aka.ms/WhatIfIssues

Resource and property changes are indicated with these symbols:
  - Delete
  ~ Modify
  = Nochange
  x Noeffect

The deployment will update the following scope:

Scope: /subscriptions/REDACTED/resourceGroups/innerloopsweden


  ~ Microsoft.Network/virtualNetworks/myawsomevnet/subnets/azure_mysql_subnet [2021-05-01]
    ~ properties.delegations: [
      ~ 0:

        - id:   "/subscriptions/REDACTED/resourceGroups/innerloopsweden/providers/Microsoft.Network/virtualNetworks/myawsomevnet/subnets/azure_mysql_subnet/delegations/dlg-Microsoft.DBforMySQL-flexibleServers"
        - type: "Microsoft.Network/virtualNetworks/subnets/delegations"

      ]

  = Microsoft.Network/privateDnsZones/contoso.private.mysql.database.azure.com [2020-06-01]
  = Microsoft.Network/privateDnsZones/contoso.private.mysql.database.azure.com/virtualNetworkLinks/myawsomevnet [2020-06-01]

Resource changes: 2 to modify, 2 no change.
```

Even though the what-if will be performing some modifications, the deployment does succeed time after time.

## Using the subnet 

When i deploy the MySql service which leverages the subnet, the problems start. The first deployment succeeds, however subsequent deployments fail when the vnet/subnet modifications are processed.

> Subnet azure_mysql_subnet is in use by /subscriptions/REDACTED/resourceGroups/innerloopsweden/providers/Microsoft.Network/virtualNetworks/myawsomevnet/subnets/azure_mysql_subnet/serviceAssociationLinks/azure_mysql_subnet-service-association-link and cannot be deleted. In order to delete the subnet, delete all the resources within the subnet. See aka.ms/deletesubnet


