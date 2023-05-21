locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Service     = "DevOps"
    ManagedWith = "terraform"
    environment = "Development"
    Owner       = "Tamie-Emmanuel"
    Company     = "Elitesolutionsit"
  }
}