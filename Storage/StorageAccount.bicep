//StorageAccount.bicep
param location string
param storageAccountSku string
param storageAccountName string
param storageAccountType string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSku
  }
  kind: storageAccountType
}

output name string = storageAccount.name
