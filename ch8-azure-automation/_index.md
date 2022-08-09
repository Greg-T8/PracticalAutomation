# Chapter 8: Cloud-Based Automation
This chapter covers Azure Automation. Here's a quick synopsis on the scripts in this chapter:

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
