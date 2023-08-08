targetScope='subscription'

// To Do: Read from pipeline variables
param environmentType string='dev1'
param applicationName string='bhdemo'

var resourceGroupName='rg-${applicationName}-${environmentType}'
var cosmosAccountName='cosmos-${applicationName}-${environmentType}'

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
