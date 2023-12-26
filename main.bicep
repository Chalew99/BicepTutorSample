param location string = 'westus3'
param storageAccountName string = 'toylaunch${uniqueString(resourceGroup().id)}'
param appServiceAppName string = 'toylaunch${uniqueString(resourceGroup().id)}'

@allowed([
  'nonprod'
  'prod'
])
param environmentType string

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

module appService 'modules/appService.bicep' = {
  name: 'appService'
  params: {
    location: location
    appServiceAppName: appServiceAppName
    environmentType: environmentType
  }
}

output appServiceAppHostName string = appService.outputs.appServiceAppHostName

// resource appServicePlan 'Microsoft.Web/serverFarms@2022-03-01' = {
//   name: appServicePlanName
//   location: location
//   sku: {
//     name: appServicePlanSkuName
//   }
// }

// resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
//   name: appServiceAppName
//   location: location
//   properties: {
//     serverFarmId: appServicePlan.id
//     httpsOnly: true
//   }
// }
