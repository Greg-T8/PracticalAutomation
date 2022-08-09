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
- Converts automation account to a Managed Identity
- Grants the automation account contributor access to the storage account

For more info on Managed Identities, see
- [Azure Automation account authentication overview](https://docs.microsoft.com/en-us/azure/automation/automation-security-overview?WT.mc_id=Portal-Microsoft_Azure_Automation#managed-identities-preview)
- [What are managed identities for Azure resources?](https://docs.microsoft.com/en-us/azure/automation/automation-security-overview?WT.mc_id=Portal-Microsoft_Azure_Automation#managed-identities-preview)

## Hybrid Worker Setup
When executing tasks on-prem, you need to do two things: (1) install the Microsoft Monitoring Agent (MMA) and (2) register the system as a hybrid runbook worker.

The script [SetUpMicrosoftMonitoringAgent.ps1](SetUpMicrosoftMonitoringAgent.ps1) does several things:
- Downloads the MMA to the user's local temp directory
- Runs the setup.exe for the MMMA
- Registers the Log Analytics workspace with the MMA configuration


