terraform {
  required_version = ">= 1.10.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.50"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.7"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.27"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.1.0"
    }
  }

  cloud {
    organization = "maor"
    workspaces {
      name = "hcpt-dynamic-provider-credentials"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}

provider "azuread" {}

provider "aws" {
  region = var.aws_region
}
