param appServicePlanName string
param appServicePlanSKU string

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: resourceGroup().location
  properties: {
    reserved: true
  }
  sku: {
    name: appServicePlanSKU
  }
  kind: 'linux'
}
