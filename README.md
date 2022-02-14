# Bicep Lessons
Gotchas and workarounds for bicep lang

## 1 - Conditionality on objects.

When creating a highly conditional bicep module, IE. one that will deploy different resources or different configuration of resources based on the parameters. Authors need to be aware of the different behaviour that the Azure Resource Providers have.

### Scenario : Network Security Group

The scenario here is that an virtual network subnet is being created for Azure Application Gateway. Conditonally, the subnet will have an NSG. However 

In the case of setting the condition on the subnet directly, the syntax doesn't work. It results in `Value for reference id is missing. Path properties.subnets[4].properties.networkSecurityGroup.`

```bicep
var appgw_subnet = {
  name: appgw_subnet_name
  properties: {
    addressPrefix: vnetAppGatewaySubnetAddressPrefix
    networkSecurityGroup: ingressApplicationGateway && networkSecurityGroups ? {
      id: nsgAppGw.outputs.nsgId
    } : {}
  }
}
```

If a null value is provided then this error is thrown `Value for the id property is invalid. Expecting a string. Actual value is Null. Path properties.subnets[4].properties.networkSecurityGroup.`

```bicep
var appgw_subnet = {
  name: appgw_subnet_name
  properties: {
    addressPrefix: vnetAppGatewaySubnetAddressPrefix
    networkSecurityGroup: ingressApplicationGateway && networkSecurityGroups ? {
      id: nsgAppGw.outputs.nsgId
    } : {
      id: json('null')
    }
  }
}
```

The next logical fix would be to set the id to be an empty string, but this results in `Property id '' at path 'properties.subnets[4].properties.networkSecurityGroup.id' is invalid. Expect fully qualified resource Id that start with '/subscriptions/{subscriptionId}' or '/providers/{resourceProviderNamespace}`

```bicep
var appgw_subnet = {
  name: appgw_subnet_name
  properties: {
    addressPrefix: vnetAppGatewaySubnetAddressPrefix
    networkSecurityGroup: ingressApplicationGateway && networkSecurityGroups ? {
      id: nsgAppGw.outputs.nsgId
    } : {
      id: ''
    }
  }
}
```

The solution is actually to split out the NSG into multiple objects and then conditionally union (join) them together.

```bicep
var appgw_baseSubnet = {
  name: appgw_subnet_name
  properties: {
    addressPrefix: vnetAppGatewaySubnetAddressPrefix
  }
}

var appGw_nsg = {
  properties: {
    networkSecurityGroup: {
      id: nsgAppGw.outputs.nsgId
    }
  }
}

var appgw_subnet = ingressApplicationGateway && networkSecurityGroups ? union(appgw_baseSubnet,appGw_nsg) : appgw_baseSubnet
```

