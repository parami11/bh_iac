targetScope = 'subscription'

// To Do: Read from pipeline variables
param environmentType string = 'dev1'
param applicationName string = 'bhdemo'

var resourceGroupName = 'rg-${applicationName}-${environmentType}'
var containerRegistryName = 'acr${applicationName}${environmentType}'
var containerRegistrySKU = 'Basic'
var appServicePlanName = 'appplan-${applicationName}-${environmentType}'
var appServicePlanSKU = 'P1V2'
var frontEndAppNme = 'app-fe-${applicationName}-${environmentType}'
var backEndAppNme = 'app-be-${applicationName}-${environmentType}'
var cosmosAccountName = 'cosmos-${applicationName}-${environmentType}'
var cosmosDbName = 'bhdemodb'
var cosmosCollectionName_Employee = 'employees'
var logAnalyticsNamespaceName = 'loga-${applicationName}${environmentType}'
var appInsightsName = 'appi-${applicationName}${environmentType}'

// Create Resource Group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: deployment().location
}

// Create Log Analytics Workspace
module logAnalytics 'logAnalytics.bicep' = {
  name: 'logAnalytics'
  scope: resourceGroup
  params: {
    logAnalyticsNamespaceName: logAnalyticsNamespaceName
  }
}

// Create Cosmos DB
module cosmodb 'cosmosdb.bicep' = {
  name: 'cosmosdb'
  scope: resourceGroup
  params: {
    location: resourceGroup.location
    cosmosAccountNme: cosmosAccountName
    cosmosDbName: cosmosDbName
    cosmosCollectionName_Employee: cosmosCollectionName_Employee
  }
}

//create app service
module appService 'appservice.bicep' = {
  name: 'appService'
  scope: resourceGroup
  params: {
    location: resourceGroup.location
    appServicePlanName: appServicePlanName
    appServicePlanSKU: appServicePlanSKU
    acrName: containerRegistryName
    frontEndAppName: frontEndAppNme
    backEndAppName: backEndAppNme
    cosmosDb_databaseName: cosmosDbName
    cosmosDb_primaryKey: cosmodb.outputs.cosmosDb_primaryKey
    cosmosDb_containerName: cosmosCollectionName_Employee
    cosmosDb_AccountName: cosmosAccountName
  }
}

// Create contsiner registry
module containerRegistry 'containerregistry.bicep' = {
  name: 'containerRegistry'
  scope: resourceGroup
  params: {
    location: resourceGroup.location
    acrName: containerRegistryName
    acrSku: containerRegistrySKU
    frontendAppId: appService.outputs.frontEndAppID
    backendAppId: appService.outputs.backEndAppID
  }
}
