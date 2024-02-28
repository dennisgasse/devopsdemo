using './vWAN-HUB-v1.bicep'

param location = 'westeuropa'
param vWANprefix01 = 'VirtWAN-prd01'
param HUBprefix01 = 'HUB-prd01'
param vnetvMX = 'vnet-vMXspoke-to-HUBprd'
param policy01 = 'Policy01-prd'
param firewallname = 'FW01-vWANprd'
param vnetname = 'spoke01'
param subnet01 = 'vMX01z1'
param subnet02 = 'vMX02z2'
param NSGvMX01 = 'NSG-vMX01'
param NSGvMX02 = 'NSG-vMX02'

