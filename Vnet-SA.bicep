// Demo vandaag DC team meeting
param location string 
param vNetName string 
param vNetAddressPrefix string
param subnetAddressPrefix string

resource vnet 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: vNetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [vNetAddressPrefix]
    }
  }
}

resource serverFarmSubnet 'Microsoft.Network/virtualNetworks/subnets@2020-06-01' = {
  name: 'aSubnet'
  parent: vnet
  properties: { 
    addressPrefix: subnetAddressPrefix
    delegations: [
      {
        name: 'Microsoft.Web/serverfarms'
        properties: {
          serviceName: 'Microsoft.Web/serverfarms'
        }
      }
    ]
  }
}
