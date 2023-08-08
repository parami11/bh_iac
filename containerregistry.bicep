param acrName string
param acrSku string


resource acrResource 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: acrName
  location: resourceGroup().location
  sku: {
    name: acrSku
  }
  properties: {
    adminUserEnabled: false
  }
}
