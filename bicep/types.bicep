
//q: When are bicep types useful

resource automationAccount 'Microsoft.Automation/automationAccounts@2022-08-08' = {
  name: 'aaMyAutomationAccount'
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    sku: {
      name: 'Free'
    }
  }
}
