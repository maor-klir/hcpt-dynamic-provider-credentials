########################################################################################
##### Azure variables for HCP Terraform integration - Dynamic provider credentials #####
########################################################################################

variable "hcpt_azure_audience" {
  type        = string
  default     = "api://AzureADTokenExchange"
  description = "The audience value to use in run identity tokens"
}

variable "hcpt_hostname" {
  type        = string
  default     = "app.terraform.io"
  description = "The hostname of the HCP Terraform or TFE instance we'd like to use with Azure"
}

variable "hcpt_organization_name" {
  type        = string
  default     = "maor"
  description = "The name of our HCP Terraform organization"
}

variable "hcpt_project_name" {
  type        = string
  default     = "Default Project"
  description = "The project under which a workspace will be created"
}

variable "hcpt_workspace_name" {
  type        = string
  description = "The name of the workspace that we'd like to create and connect to Azure"
}

variable "azure_subscription_id" {
  type        = string
  description = "Azure subscription ID where resources will be created"
}

########################################################################################
##### AWS variables for HCP Terraform integration - Dynamic provider credentials #######
########################################################################################

variable "aws_region" {
  type        = string
  default     = "eu-central-1"
  description = "The AWS region where resources will be created"
}

variable "hcpt_aws_audience" {
  type        = string
  default     = "aws.workload.identity"
  description = "The audience value to use in run identity tokens"
}
###################################################################################
# These variables are global and are alreaady defined above for Azure integration #
###################################################################################
# variable "hcpt_hostname" {
#   type        = string
#   default     = "app.terraform.io"
#   description = "The hostname of HCP Terraform or TFE instance you'd like to use with AWS"
# }

# variable "hcpt_organization_name" {
#   type        = string
#   description = "The name of your HCP Terraform organization"
# }

# variable "hcpt_project_name" {
#   type        = string
#   default     = "Default Project"
#   description = "The project under which a workspace will be created"
# }

# variable "hcpt_workspace_name" {
#   type        = string
#   default     = "my-aws-workspace"
#   description = "The name of the workspace that you'd like to create and connect to AWS"
# }
