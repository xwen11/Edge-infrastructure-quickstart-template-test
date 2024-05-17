module "base" {
  source   = "../../modules/baseModule"
  siteId   = basename(abspath(path.module))
  location = "eastus2"
}
