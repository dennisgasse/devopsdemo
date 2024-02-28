param location string
param workspaceName string

resource  workspace  'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
    name: workspaceName
    location: location
    properties: {
     sku: {
     name: 'Standard'
  }
   retentionInDays: 30
   features: {
   enableLogAccessUsingOnlyResourcePermissions: true
  }
}
}
