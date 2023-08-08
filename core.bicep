targetScope='subscription'

param environmentType string
param applicationName string='bhdemo'

var resourceGroupName='rg-${applicationName}-${environmentType}'

// Create Resource Group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01'= {
  name:resourceGroupName
  location:deployment().location
}
