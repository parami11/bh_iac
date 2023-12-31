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
param appInsightsName string
param logAnalyticsWorkspaceId string

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'string'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspaceId
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
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

resource frontEndAppService 'Microsoft.Web/sites@2022-09-01' = {
  name: frontEndAppName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${acrName}.azurecr.io/react_fe:latest'
      appSettings: [
        {
          name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
      ]
    }
  }
}

resource backEndAppService 'Microsoft.Web/sites@2022-09-01' = {
  name: backEndAppName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${acrName}.azurecr.io/dotnet_be:latest'
      appSettings: [
        {
          name: 'Cosmos_Url'
          value: 'https://${cosmosDb_AccountName}.documents.azure.com:443/'
        }
        {
          name: 'Cosmos_PrimaryKey'
          value: cosmosDb_primaryKey
        }
        {
          name: 'Cosmos_DatabaseName'
          value: cosmosDb_databaseName
        }
        {
          name: 'Cosmos_ContainerName'
          value: cosmosDb_containerName
        }
        {
          name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
      ]
    }
  }
}

output frontEndAppID string = frontEndAppService.identity.principalId
output backEndAppID string = backEndAppService.identity.principalId
