// Axians CS
// versie 1.0

// ----------------------------------
// Resource grpoup create for ptoject
// ----------------------------------

// ----------
// Parameters
// ----------
@description('Azure region of the deployment')
param location string = resourceGroup().location
param vNetName string = 'vnet1'
param vNetAddressPrefix string = '10.0.0.0/16'
param subnetAddressPrefix string= '10.0.1.0/24'

module diagsettings 'Vnet-SA.bicep' = {
  name: 'Vnet-deploy'
  params: {
    location: location
    vNetName:vNetName
    vNetAddressPrefix:vNetAddressPrefix
    subnetAddressPrefix:subnetAddressPrefix
  }
}
