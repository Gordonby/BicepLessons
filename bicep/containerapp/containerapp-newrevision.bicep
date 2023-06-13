param location string = resourceGroup().location

module existingRevisionInfo 'containerapp-revisioninfo.bicep' = {
  name: 'RevisionInfo'
  params: {
    containerAppName: 'nodeapp'
  }
}

module appNodeService 'containerapp.bicep' = {
  name: 'stateNodeApp'
  params: {
    location: location
    containerAppName: 'nodeapp'
    containerAppEnvName: 'env-stateSt1'
    containerImage: 'ghcr.io/dapr/samples/hello-k8s-node:latest'
    targetPort: 3000
    externalIngress: false
    createUserManagedId: false
    revisionMode: 'Multiple'
    currentActiveRevisionName: existingRevisionInfo.outputs.latestReadyRevisionName
    environmentVariables: [
      {
        name: 'APP_PORT'
        value: '3000'
      }
    ]
  }
}
