// Axians
// Minimum deployment virtual Netwerk & NSG Meraki SD-WAN Solution
// This Mudule is part of the Main module for deplyment ALZ connectiviy module

// Use this sample to deploy the minimum resource configuration
// ------------------------------------------------------------
targetScope = 'resourceGroup'
// ----------
// PARAMETERS
// ----------
param location string
// ---------
// RESOURCES
// ---------

// ---------
// Variable
//----------
var NetworkSecurityGroupNamevMX = '${vnetnamevMX}-${'nsg'}'
var vnetnamevMX = 'vnet-vMX-${'hub'}'
var snet1namevMX = 'snet-vMX-${'01'}'
var snet2namevMX = 'snet-vMX-${'02'}'
var addressPrefix = '172.16.0.0/15'
var SubnetPrefix1 = '172.16.1.0/24'
var SubnetPrefix2 = '172.16.2.0/24'
var GatewaySubnetPrefix = '172.16.3.0/27'
// var gatewaynameop = '${vnetnamevMX}-${'gw'}'
var gatewaysubnet = 'GatewaySubnet'

// ----------------
//On-prem Resources
// ----------------
resource nsg 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: NetworkSecurityGroupNamevMX
  location: location
  properties: {
    securityRules: [
      {
        name: 'allow3389'
        properties: {
          priority: 1000
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '3389'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'allowICMPInbound'
        properties: {
          priority: 1500
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '*'
          protocol: 'Icmp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'allowICMPOutbound'
        properties: {
          priority: 1500
          access: 'Allow'
          direction: 'Outbound'
          destinationPortRange: '3389'
          protocol: 'Icmp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource vnetvMX 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetnamevMX
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    enableDdosProtection: false
    enableVmProtection: false
    subnets: [
      {
        name: snet1namevMX
        properties: {
          addressPrefix: SubnetPrefix1
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
      {
        name: snet2namevMX
        properties: {
          addressPrefix: SubnetPrefix2
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
      {
        name: gatewaysubnet
        properties: {
          addressPrefix: GatewaySubnetPrefix
        }
      }
    ]
  }
}

output vnetName string = vnetvMX.id
output serverSubnetId string = vnetvMX.properties.subnets[0].id
output gwSubnetId string = vnetvMX.properties.subnets[1].id
output resourceId string = vnetvMX.id
