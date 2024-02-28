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
param vWANprefix01 string 
param HUBprefix01 string
param vnetvMX string
param policy01 string
param firewallname string
param vnetname string
param subnet01 string
param subnet02 string
param NSGvMX01 string
param NSGvMX02 string
// ---
// VAR
// ---
var IPprefix01 = '10.1.0.0/16'
var IPprefix02 = '10.0.0.0/16'
var IPprefix03 = '10.0.1.0/24'
var Ipprefix04 = '10.0.2.0/24'
var collectionrule01 = 'RC01'
// -------------------
// Resource Vitual WAN
// -------------------
resource virtualWan 'Microsoft.Network/virtualWans@2021-08-01' = {
  name: vWANprefix01
  location: location
  properties: {
    disableVpnEncryption: false
    allowBranchToBranchTraffic: true
    type: 'Standard'
  }
}
// -------------------
// Resource Vitual HUB
// -------------------
resource virtualHub 'Microsoft.Network/virtualHubs@2021-08-01' = {
  name: HUBprefix01
  location: location
  properties: {
    addressPrefix: IPprefix01
    virtualWan: {
      id: virtualWan.id
    }
  }
}

resource hubVNetconnection 'Microsoft.Network/virtualHubs/hubVirtualNetworkConnections@2021-08-01' = {
  parent: virtualHub
  name: vnetvMX
  dependsOn: [
    firewall
  ]
  properties: {
    remoteVirtualNetwork: {
      id: virtualNetwork.id
    }
    allowHubToRemoteVnetTransit: true
    allowRemoteVnetToUseHubVnetGateways: false
    enableInternetSecurity: true
    routingConfiguration: {
      associatedRouteTable: {
        id: hubRouteTable.id
      }
      propagatedRouteTables: {
        labels: [
          vnetname
        ]
        ids: [
          {
            id: hubRouteTable.id
          }
        ]
      }
    }
  }
}

resource policy 'Microsoft.Network/firewallPolicies@2021-08-01' = {
  name: policy01
  location: location
  properties: {
    threatIntelMode: 'Alert'
  }
}

resource ruleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2021-08-01' = {
  parent: policy
  name: 'DefaultApplicationRuleCollectionGroup'
  properties: {
    priority: 300
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: collectionrule01
        priority: 100
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'Allow-msft'
            sourceAddresses: [
              '*'
            ]
            protocols: [
              {
                port: 80
                protocolType: 'Http'
              }
              {
                port: 443
                protocolType: 'Https'
              }
            ]
            targetFqdns: [
              '*.microsoft.com'
            ]
          }
        ]
      }
    ]
  }
}

resource firewall 'Microsoft.Network/azureFirewalls@2021-08-01' = {
  name: firewallname
  location: location
  properties: {
    sku: {
      name: firewallname
      tier: 'Standard'
    }
    hubIPAddresses: {
      publicIPs: {
        count: 1
      }
    }
    virtualHub: {
      id: virtualHub.id
    }
    firewallPolicy: {
      id: policy.id
    }
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: vnetname
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        IPprefix02
      ]
    }
    enableDdosProtection: false
    enableVmProtection: false
  }
}

resource subnet_vMX01 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' = {
  parent: virtualNetwork
  name: subnet01
  properties: {
    addressPrefix: IPprefix03
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource subnet_vMX02 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' = {
  parent: virtualNetwork
  name: subnet02
  dependsOn: [
    subnet_vMX01
  ]
  properties: {
    addressPrefix: Ipprefix04
    routeTable: {
      id: routeTable.id
    }
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource nsg_vMX01 'Microsoft.Network/networkSecurityGroups@2021-08-01' = {
  name: NSGvMX01
  location: location
  properties: {
    securityRules: [
      {
        name: 'RDP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 300
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource nsg_vMX02 'Microsoft.Network/networkSecurityGroups@2021-08-01' = {
  name: NSGvMX02
  location: location
  properties: {
    securityRules: [
      {
        name: 'RDP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 300
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource publicIP_jump_srv 'Microsoft.Network/publicIPAddresses@2021-08-01' = {
  name: 'publicIP-jump-srv'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}

resource routeTable 'Microsoft.Network/routeTables@2021-08-01' = {
  name: policy01
  location: location
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'jump-to-inet'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'Internet'
        }
      }
    ]
  }
}

resource hubRouteTable 'Microsoft.Network/virtualHubs/hubRouteTables@2021-08-01' = {
  parent: virtualHub
  name: 'RT_VNet'
  properties: {
    routes: [
      {
        name: 'Workload-SNToFirewall'
        destinationType: 'CIDR'
        destinations: [
          '10.0.1.0/24'
        ]
        nextHopType: 'ResourceId'
        nextHop: firewall.id
      }
      {
        name: 'InternetToFirewall'
        destinationType: 'CIDR'
        destinations: [
          '0.0.0.0/0'
        ]
        nextHopType: 'ResourceId'
        nextHop: firewall.id
      }
    ]
    labels: [
      'VNet'
    ]
  }
}
