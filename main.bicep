targetScope='subscription'

param environmentType string

var resourceGroupName='rg-bhDemo-${environmentType}'

// Create Resource Group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01'= {
  name:resourceGroupName
  location:deployment().location
}
