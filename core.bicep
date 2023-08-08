targetScope='subscription'

// To Do: Read from pipeline variables
param environmentType string='dev1'
param applicationName string='bhdemo'

var resourceGroupName='rg-${applicationName}-${environmentType}'
var cosmosAccountName='cosmos-${applicationName}-${environmentType}'
var containerRegistryName= 'acr${applicationName}${environmentType}'
var containerRegistrySKU= 'Basic'


// Create Resource Group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01'= {
  name:resourceGroupName
  location:deployment().location
}

// Create Cosmos DB
module cosmodb 'cosmosdb.bicep'={
  name:'cosmosdb'
  scope:resourceGroup
  params:{
    cosmosAccountNme:cosmosAccountName
  }
}

// Create contsiner registry
module containerRegistry 'containerregistry.bicep'={
  name:'containerRegistry'
  scope:resourceGroup
  params:{
    acrName:containerRegistryName
    acrSku:containerRegistrySKU
  }
}
