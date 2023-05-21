locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Service     = "DevOps"
    Owner       = "Tamie-Emmanuel"
    Company     = "Elitesolutionsit"
    environment = "Development"
    ManagedWith = "terraform"
  }
}