param cosmosAccountNme string

var dbName = 'bhdemodb'
var collectionName_Employee='employees'

resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' = {
  name: cosmosAccountNme
  location: resourceGroup().location
  properties:{
    databaseAccountOfferType:'Standard'
    enableAutomaticFailover:false
    enableMultipleWriteLocations:false
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: resourceGroup().location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
  }
}

resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-04-15' = {
  parent:cosmosDbAccount
  name:dbName
  properties:{
    resource:{
      id:dbName
    }
  }
}

resource employeesContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-04-15' = {
  parent:cosmosDb
  name:collectionName_Employee
  properties:{
    resource:{
      id: collectionName_Employee
      partitionKey:{
        paths:[
          '/id'
        ]
      }
    }
  }
}
