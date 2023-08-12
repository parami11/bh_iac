param location string
param appServicePlanName string
param backEndAppName string
param frontEndAppName string
param appServicePlanSKU string
param acrName string
param cosmosDb_AccountName string
param cosmosDb_primaryKey string
param cosmosDb_databaseName string
param cosmosDb_containerName string

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
      appSettings: [
        {
          name: 'AzureCosmosDbSettings__URL'
          value: 'https://${cosmosDb_AccountName}.documents.azure.com:443/'
        }
        {
          name: 'AzureCosmosDbSettings__PrimaryKey'
          value: cosmosDb_primaryKey
        }
        {
          name: 'AzureCosmosDbSettings__DatabaseName'
          value: cosmosDb_databaseName
        }
        {
          name: 'AzureCosmosDbSettings__ContainerName'
          value: cosmosDb_containerName
        }
      ]
    }
  }
}

output frontEndAppID string = frontEndAppService.identity.principalId
output backEndAppID string = backEndAppService.identity.principalId
