module "base" {
  source          = "../../modules/base"
  location        = "eastus"
  siteId          = basename(abspath(path.module))
  domainFqdn      = "jumpstart.local"
  startingAddress = "192.168.1.55"
  endingAddress   = "192.168.1.65"
  defaultGateway  = "192.168.1.1"
  dnsServers      = ["192.168.1.254"]
  adouSuffix      = "DC=jumpstart,DC=local"
  domainServerIP  = "192.168.1.254"
  servers = [
    {
      name        = "AzSHOST1",
      ipv4Address = "192.168.1.12"
    },
    {
      name        = "AzSHOST2",
      ipv4Address = "192.168.1.13"
    }
  ]
  managementAdapters = ["FABRIC", "FABRIC2"]
  storageNetworks = [
    {
      name               = "Storage1Network",
      networkAdapterName = "StorageA",
      vlanId             = "711"
    },
    {
      name               = "Storage2Network",
      networkAdapterName = "StorageB",
      vlanId             = "712"
    }
  ]
  rdmaEnabled                   = false     // Change to true if RDMA is enabled.
  storageConnectivitySwitchless = false     // Change to true if storage connectivity is switchless.
  enableProvisioners            = true      // Change to false when Arc servers are connected by yourself.
  authenticationMethod          = "Credssp" // or "Default"
  subscriptionId                = var.subscriptionId
  domainAdminUser               = var.domainAdminUser
  domainAdminPassword           = var.domainAdminPassword
  localAdminUser                = var.localAdminUser
  localAdminPassword            = var.localAdminPassword
  deploymentUserPassword        = var.deploymentUserPassword
  servicePrincipalId            = var.servicePrincipalId
  servicePrincipalSecret        = var.servicePrincipalSecret
  rpServicePrincipalObjectId    = var.rpServicePrincipalObjectId


  # Region Hybrid AKS related parameters
  aksArc-controlPlaneIp = "192.168.1.190"

  // the following value only need to provide if you want to create a new logical network, if not, set aksArc-lnet-usingExistingLogicalNetwork to true and specify the existing logical network name in logicalNetworkName
  aksArc-lnet-startingAddress = "192.168.1.171"
  aksArc-lnet-endingAddress   = "192.168.1.190"
  aksArc-lnet-addressPrefix   = "192.168.1.0/24"
  aksArc-lnet-defaultGateway  = "192.168.1.1"
  aksArc-lnet-dnsServers      = ["192.168.1.254"]
  rbacAdminGroupObjectIds     = ["1b81c027-029d-434d-9642-376e392bfe65"]
  # End region of hybrid aks related parameters

  # Region site manager parameters
  # Check ./doc/Add-Site-Manager.md for more information
  country         = "US"
  city            = "redmond"
  companyName     = "contoso"
  postalCode      = "4331"
  stateOrProvince = "unkown"
  streetAddress1  = "1 microsoft way"
  contactName     = "qfai"
  emailList       = ["xxx@contoso.com"]
  mobile          = "xxxx"
  phone           = "xxxx"
 }