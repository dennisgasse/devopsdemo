param vnetName string = 'vMX-Vnet'
param addressPrefix string = '172.16.1.0/24'
param deployGatewaySubnet bool = true
param dnsServers array = []
param tags object = {}
param location string = 'westeurope'

// Create subnet address prefixes from VNet address prefix
var serverPrefix = '${split(addressPrefix, '.')[0]}.${split(addressPrefix, '.')[1]}.${split(addressPrefix, '.')[2]}.0/26'
var gatewayPrefix = '${split(addressPrefix, '.')[0]}.${split(addressPrefix, '.')[1]}.${split(addressPrefix, '.')[2]}.64/26'

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: '${vnetName}-snet-servers-nsg'
  location: location
}

var standardSubnet = [
  {
    name: 'snet-servers'
    properties: {
      addressPrefix: serverPrefix
      networkSecurityGroup: {
        id: nsg.id
      }
    }
  }
]

var gatewaySubnet = [
  {
    name: 'GatewaySubnet'
    properties: {
      addressPrefix: gatewayPrefix
    }
  }
]

resource vnet 'Microsoft.Network/virtualNetworks@2020-08-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    dhcpOptions: {
      dnsServers: dnsServers
    }
    subnets: deployGatewaySubnet ? union(standardSubnet, gatewaySubnet) : deployGatewaySubnet ? union(standardSubnet, gatewaySubnet) : standardSubnet
  }
}
