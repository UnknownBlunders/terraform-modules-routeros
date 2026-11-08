terraform {
  required_version = ">= 1.0"

  required_providers {
    routeros = {
      source  = "terraform-routeros/routeros"
      version = ">= 1.0"
    }
    onepassword = {
      source  = "1password/onepassword"
      version = ">=3.3.1"
    }
  }
}
