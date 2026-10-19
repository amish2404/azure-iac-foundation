\# Azure IaC Foundation



Repeatable Azure deployment using Bicep (VNet + subnets) and Terraform (resource group + storage account with remote state).



Region: `indiasouthcentral`. Azure Policy on this subscription only allows indiasouthcentral, eastasia, indonesiacentral, malaysiawest and uaenorth.



\## Prerequisites

Azure CLI, Terraform >= 1.6, Git, an Azure subscription.

```

az login --tenant <tenant-id>

```



\## Repo layout

\- `bicep/`: `main.bicep`, `parameters.dev.json`, `parameters.test.json`, deployment output

\- `terraform/`: `providers.tf`, `variables.tf`, `main.tf`, `outputs.tf`, `backend.tf`, `terraform.tfvars`

\- `docs/screenshots/`: evidence



\## Deploy Bicep

```

az group create -n rg-iac-bicep-dev -l indiasouthcentral

az deployment group what-if -g rg-iac-bicep-dev --template-file bicep/main.bicep --parameters @bicep/parameters.dev.json

az deployment group create -g rg-iac-bicep-dev -n vnet-foundation-dev --template-file bicep/main.bicep --parameters @bicep/parameters.dev.json

```

For test, use `parameters.test.json` and a separate resource group.



\## Deploy Terraform

```

cd terraform

terraform init

terraform plan -out=tfplan

terraform apply tfplan

```



\## Remote state

State lives in storage account `stiactfstate1234` (resource group `rg-iac-tfstate`), container `tfstate`, key `iac-foundation/dev.tfstate`. No Module 3 storage account existed in this subscription, so a dedicated state account was created. Access uses Azure AD with the Storage Blob Data Contributor role. State started local and was migrated with `terraform init -migrate-state`.



\## State management notes

\- State maps resource addresses in code to real Azure resources and their attributes.

\- Local state has no locking or sharing and can hold secrets, so `\*.tfstate` and `tfplan` are git-ignored.

\- The azurerm backend uses blob leases for locking.

\- Bicep has no state file. Azure Resource Manager is the source of truth, and `what-if` compares the template to live resources.



\## Verify

```

az network vnet list -g rg-iac-bicep-dev -o table

az resource list -g rg-iac-tf-dev -o table

terraform plan

```

`terraform plan` should report no changes.



\## Cleanup (in this order)

```

cd terraform

terraform destroy

az group delete -n rg-iac-tfstate --yes --no-wait

az group delete -n rg-iac-bicep-dev --yes --no-wait

```

The state account must outlive `terraform destroy`.



\## Bicep vs Terraform: my observations

\- Region policy blocked the first Bicep what-if; the same policy applied to Terraform.

\- Bicep needed no state or backend; Terraform needed init, state and a backend.

\- (Add your own observations here.)

