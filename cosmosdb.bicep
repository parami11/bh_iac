param location string
param cosmosAccountNme string
param cosmosDbName string
param cosmosCollectionName_Employee string

resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' = {
  name: cosmosAccountNme
  location: location
  properties: {
    databaseAccountOfferType: 'Standard'
    enableAutomaticFailover: false
    enableMultipleWriteLocations: false
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
  }
}

resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-04-15' = {
  parent: cosmosDbAccount
  name: cosmosDbName
  properties: {
    resource: {
      id: cosmosDbName
    }
  }
}

resource employeesContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-04-15' = {
  parent: cosmosDb
  name: cosmosCollectionName_Employee
  properties: {
    resource: {
      id: cosmosCollectionName_Employee
      partitionKey: {
        paths: [
          '/id'
        ]
      }
    }
  }
}

output cosmosDb_primaryKey string = cosmosDbAccount.listKeys().primaryMasterKey
