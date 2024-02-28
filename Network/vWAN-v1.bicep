param virtualWans_vWAN_vMX_name string = 'vWAN-vMX'

resource virtualWans_vWAN_vMX_name_resource 'Microsoft.Network/virtualWans@2022-11-01' = {
  name: virtualWans_vWAN_vMX_name
  location: 'westeurope'
  tags: {
    CostCenter: 'RG-TAG'
  }
  properties: {
    disableVpnEncryption: false
    allowBranchToBranchTraffic: true
    office365LocalBreakoutCategory: 'None'
    type: 'Standard'
  }
}