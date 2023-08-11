param appServicePlanName string
param backEndAppName string
param frontEndAppName string
param appServicePlanSKU string
param acrName string

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: resourceGroup().location
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
  location: resourceGroup().location
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

output frontEndAppID string = frontEndAppService.identity.principalId
