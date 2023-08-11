param location string
param acrName string
param acrSku string
param frontendAppId string
param backendAppId string

var acrPullDefinitionId = '7f951dda-4ed3-4680-a7ca-43fe172d538d'

resource acrResource 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: acrSku
  }
  properties: {
    adminUserEnabled: false
  }
}

resource frontEndRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, acrName, 'frontEndRoleAssignment')
  scope: acrResource
  properties: {
    principalId: frontendAppId
    principalType: 'ServicePrincipal'
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', acrPullDefinitionId)
  }
}

resource backEndRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, acrName, 'backEndRoleAssignment')
  scope: acrResource
  properties: {
    principalId: backendAppId
    principalType: 'ServicePrincipal'
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', acrPullDefinitionId)
  }
}
