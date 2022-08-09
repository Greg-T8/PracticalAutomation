# Chapter 8: Cloud-Based Automation
This chapter covers Azure Automation.

## Azure Automation Setup
The author presents several chunks of code that facilitate the setup of components used by Azure Automation. I combined all chunks into a single script [AzureAutomationSetup.ps1](AzureAutomationSetup.ps1). 

This script does a lot of stuff:  
- Creates a resource group
- Creates an automation account
- Creates a Log Analytics workspace
- Adds the Azure Automation solution to the Log Analytics workspace
- Prints out the resulting registration information, including
  - Log Analytics Workspace ID and shared key
  - Azure Automation endpoint URL and primary key
- Converts automation account to a managed identity
- Grants the automation account contributor access to the storage account

For more info on Managed Identities, see
- [Azure Automation account authentication overview](https://docs.microsoft.com/en-us/azure/automation/automation-security-overview?WT.mc_id=Portal-Microsoft_Azure_Automation#managed-identities-preview)
- [What are managed identities for Azure resources?](https://docs.microsoft.com/en-us/azure/automation/automation-security-overview?WT.mc_id=Portal-Microsoft_Azure_Automation#managed-identities-preview)

## Hybrid Worker Setup
When executing tasks on-prem, you need to do two things: (1) install the Microsoft Monitoring Agent and (2) 
