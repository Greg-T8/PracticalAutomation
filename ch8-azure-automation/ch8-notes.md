[Chapter 8: Cloud-Based Automation](#chapter-8-cloud-based-automation)
  - [Azure Automation Setup](#azure-automation-setup)
  - [Hybrid Worker Setup](#hybrid-worker-setup)
    - [Issue: Machine is already registered as a hybrid runbook worker](#issue-machine-is-already-registered-as-a-hybrid-runbook-worker)

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

The script [CreateHybridRunbookWorker.ps1](CreateHybridRunbookWorker.ps1) does the following:
- Looks up the install path for the Microsoft Monitoring Agent
- Imports the module `HybridRegistration.psd1` from the AzureAutomation folder in the install path
- Runs the cmdlet `Add-HybridRunbookWorker`

Note that this script depends on the output of [AzureAutomationSetup.ps1](AzureAutomationSetup.ps1).

### Issue: Machine is already registered as a hybrid runbook worker
You will receive the following error when running `CreateHybridRunbookWorker` multiple times:

![](img/2022-08-09-05-19-00.png)

The module `HybridRegistration.psd1` provides an option to remove the registration:

![](img/2022-08-09-05-22-39.png)

But you need to know the existing registration URL. This URL is not easy to get as there's no `Get-HybridRunbookWorker` cmdlet.

To fix, just delete the registry key `HKLM\Software\Microsoft\HybridRunbookWorker`.

## Managing Modules for Hybrid Runbook Workers
You need to manually manage your PowerShell modules on Hybrid Runbook Workers, as Azure Automation doesn't do that for you.

Be sure to scope module installation to `AllUsers`:

`Install-Module -Name <module name> -Scope AllUsers`

