param containerAppName string = 'nodeapp'

resource containerApp 'Microsoft.App/containerApps@2023-04-01-preview' existing = {
  name: containerAppName
}

output latestRevisionName string = containerApp.properties.latestRevisionName
output latestReadyRevisionName string = containerApp.properties.latestReadyRevisionName
