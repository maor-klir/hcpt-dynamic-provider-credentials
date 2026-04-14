# HCP Terraform Dynamic Provider Credentials

This repository configures OIDC federation between my HCP Terraform organization and multiple cloud providers, enabling secure authentication without the use of static credentials.

## Overview

Dynamic provider credentials use OpenID Connect (OIDC) to establish a trust relationship between HCP Terraform and various providers.  
This is not limited to cloud providers like AWS and Azure, but also extends to the Kubernetes and Helm providers, which can utilize the Kubernetes API as an [OIDC identity provider](https://developer.hashicorp.com/terraform/cloud-docs/dynamic-provider-credentials/kubernetes-configuration).

## How dynamic credentials work

A workload identity token is generated for each Terraform plan or apply run. HCP Terraform sends this parrticular token to the OIDC provider, which verifies it and returns temporary credentials that are automatically set up in the run environment.  
After the run is completed, these temporary credentials are discarded.  
This approach ensures secure, short-lived access to cloud resources without managing static credentials, significantly improving security posture.

## Current implemented providers

- Azure
- AWS

## Security considerations

The current configuration uses highly privileged administrative permissions for both AWS and Azure.

**Security hardening recommendations:**

- Replace `AdministratorAccess` with least-privilege policies tailored to specific use cases
- Scope Azure role assignments to specific resource groups
- Implement condition constraints in trust policies
- Regular audit of granted permissions

## References

- [HCP Terraform Dynamic Provider Credentials](https://developer.hashicorp.com/terraform/cloud-docs/dynamic-provider-credentials)
- [AWS OIDC Documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html)
- [Azure Workload Identity Federation](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation)
