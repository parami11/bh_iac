targetScope = 'subscription'

// To Do: Read from pipeline variables
param environmentType string = 'dev1'
param applicationName string = 'bhdemo'

var resourceGroupName = 'rg-${applicationName}-${environmentType}'
var cosmosAccountName = 'cosmos-${applicationName}-${environmentType}'
var containerRegistryName = 'acr${applicationName}${environmentType}'
var containerRegistrySKU = 'Basic'
var appServicePlanName = 'appplan-${applicationName}-${environmentType}'
var appServicePlanSKU = 'P1V2'
var frontEndAppNme = 'app-fe-${applicationName}-${environmentType}'
var backEndAppNme = 'app-be-${applicationName}-${environmentType}'
var acrPullDefinitionId = '7f951dda-4ed3-4680-a7ca-43fe172d538d'

// Create Resource Group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: deployment().location
}

// Create Cosmos DB
module cosmodb 'cosmosdb.bicep' = {
  name: 'cosmosdb'
  scope: resourceGroup
  params: {
    cosmosAccountNme: cosmosAccountName
  }
}

//create app service
module appService 'appservice.bicep' = {
  name: 'appService'
  scope: resourceGroup
  params: {
    appServicePlanName: appServicePlanName
    appServicePlanSKU: appServicePlanSKU
    acrName: containerRegistryName
    frontEndAppName: frontEndAppNme
    backEndAppName: backEndAppNme
  }
}

// Create contsiner registry
module containerRegistry 'containerregistry.bicep' = {
  name: 'containerRegistry'
  scope: resourceGroup
  params: {
    acrName: containerRegistryName
    acrSku: containerRegistrySKU
    frontendAppId: appService.outputs.frontEndAppID
  }
}
