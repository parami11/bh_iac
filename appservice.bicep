param location string
param appServicePlanName string
param backEndAppName string
param frontEndAppName string
param appServicePlanSKU string
param acrName string

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: appServicePlanSKU
  }
  kind: 'linux'
}

resource frontEndAppService 'Microsoft.Web/sites@2020-06-01' = {
  name: frontEndAppName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${acrName}.azurecr.io/react-fe:latest'
    }
  }
}

resource backEndAppService 'Microsoft.Web/sites@2020-06-01' = {
  name: backEndAppName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${acrName}.azurecr.io/dotnet-be:latest'
    }
  }
}

output frontEndAppID string = frontEndAppService.identity.principalId
output backEndAppID string = backEndAppService.identity.principalId
