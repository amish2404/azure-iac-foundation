# Azure IaC Foundation

Module 4 project. I used code to create Azure resources instead of using the portal.

- **Bicep:** creates a VNet with 2 subnets
- **Terraform:** creates a resource group and a storage account (state stored in Azure Storage)

Region used: `indiasouthcentral` (the only kind my subscription allows).

## Deploy

Bicep:
```
az group create -n rg-iac-bicep-dev -l indiasouthcentral
az deployment group create -g rg-iac-bicep-dev -n vnet-foundation-dev --template-file bicep/main.bicep --parameters @bicep/parameters.dev.json
```

Terraform:
```
cd terraform
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

## Remote state

State is saved in storage account `stiactfstate1234`, container `tfstate`. I made a new account because there was no Module 3 one.

## Clean up

```
cd terraform
terraform destroy
az group delete -n rg-iac-tfstate --yes --no-wait
az group delete -n rg-iac-bicep-dev --yes --no-wait
```

## What I noticed

- Bicep has no state file. Terraform does.
- Both let you preview changes first (`what-if` and `plan`).
- Some resource groups got deleted mid-project, and I rebuilt them from code in minutes.
