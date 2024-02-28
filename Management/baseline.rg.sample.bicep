//
// Baseline deployment for create Resource Group
//

// Use this sample to deploy the minimum resource configuration.

targetScope = 'resourceGroup'

// ----------
// PARAMETERS
param exResourceGroup string
// ----------

// ---------
// RESOURCES
// ---------

// resource deployed to target resource group
// module deployed to resource group in the same subscription
module exampleModule 'module.bicep' = {
  name: 'otherRG'
  scope: resourceGroup(otherResourceGroup)
}
  name: 'baseline_rg'
  params: {
    parLocation: 'westeurope'
    parResourceGroupName: 'baseline-rg'
    parTelemetryOptOut: true
    parTags: {
      tag1: 'value1'
      tag2: 'value2'
    }
  }
}
