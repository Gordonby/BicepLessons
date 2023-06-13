param location string = resourceGroup().location

module myenv 'br/public:app/dapr-containerapps-environment:1.0.1' = {
  name: 'state'
  params: {
    location: location
    nameseed: 'stateSt1'
    applicationEntityName: 'appdata'
    daprComponentType: 'state.azure.blobstorage'
    daprComponentScopes: [
      'nodeapp'
    ]
  }
}

module appNodeService 'br/public:app/dapr-containerapp:1.0.1' = {
  name: 'stateNodeApp'
  params: {
    location: location
    containerAppName: 'nodeapp'
    containerAppEnvName: myenv.outputs.containerAppEnvironmentName
    containerImage: 'ghcr.io/dapr/samples/hello-k8s-node:latest'
    targetPort: 3000
    externalIngress: false
    createUserManagedId: false
    environmentVariables: [
      {
        name: 'APP_PORT'
        value: '3000'
      }
    ]
  }
}

module appPythonClient 'br/public:app/dapr-containerapp:1.0.1' = {
  name: 'statePyApp'
  params: {
    location: location
    containerAppName: 'pythonapp'
    containerAppEnvName: myenv.outputs.containerAppEnvironmentName
    containerImage: 'ghcr.io/dapr/samples/hello-k8s-python:latest'
    enableIngress: false
    createUserManagedId: false
    daprAppProtocol: ''
  }
}
