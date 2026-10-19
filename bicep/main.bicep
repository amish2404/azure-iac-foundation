targetScope = 'resourceGroup'

@description('Name of the virtual network')
param vnetName string

@description('Azure region; defaults to the resource group location')
param location string = resourceGroup().location

@description('Address space for the VNet')
param vnetAddressPrefix string = '10.10.0.0/16'

@description('Subnets to create')
param subnets array = [
  { name: 'snet-web', addressPrefix: '10.10.1.0/24' }
  { name: 'snet-app', addressPrefix: '10.10.2.0/24' }
]

@description('Tags applied to the VNet')
param tags object = {}

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [ vnetAddressPrefix ]
    }
    subnets: [for s in subnets: {
      name: s.name
      properties: {
        addressPrefix: s.addressPrefix
      }
    }]
  }
}

output vnetId string = vnet.id
output subnetIds array = [for (s, i) in subnets: vnet.properties.subnets[i].id]