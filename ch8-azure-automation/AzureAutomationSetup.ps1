$SubscriptionId = '79a5de62-f9aa-4693-b584-31424f327b0a'
$DateString = (Get-Date).ToString('yyMMddHHmm')
$ResourceGroupName = 'PoshAutomate' 
$WorkspaceName = 'poshauto' + $DateString
$AutomationAccountName = 'poshauto' + $DateString
$StorageAccountName = 'poshauto' + $DateString
$AutomationLocation = 'SouthCentralUS'
$WorkspaceLocation = 'SouthCentralUS'

$main = {
    # CreateResourceGroup
    CreateLogAnalyticsWorkspace
    CreateAzureAutomationAccount
    CreateStorageAccount
    AddAzureAutomationSolutionToWorkspace
    GetRegistrationInfo
    ConvertAutomationAccountToManagedIdentity
}

function CreateResourceGroup {
    New-AzResourceGroup -Name $ResourceGroupName -Location $AutomationLocation
}

function CreateLogAnalyticsWorkspace {
    $WorkspaceParams = @{
        ResourceGroupName = $ResourceGroupName
        Name              = $WorkspaceName
        Location          = $WorkspaceLocation
    }
    New-AzOperationalInsightsWorkspace @WorkspaceParams
}

function CreateAzureAutomationAccount {
    $AzAutomationAccount = @{
        ResourceGroupName = $ResourceGroupName
        Name              = $AutomationAccountName
        Location          = $AutomationLocation
        Plan              = 'Basic'
    }
    New-AzAutomationAccount @AzAutomationAccount
}

function CreateStorageAccount {
    $AzStorageAccount = @{
        ResourceGroupName = $ResourceGroupName
        AccountName       = $StorageAccountName
        Location          = $AutomationLocation
        SkuName           = 'Standard_LRS'
        AccessTier        = 'Cool'
    }
    New-AzStorageAccount @AzStorageAccount
}

function AddAzureAutomationSolutionToWorkspace {
    $WorkspaceParams = @{
        ResourceGroupName = $ResourceGroupName
        Name              = $WorkspaceName
    }
    $workspace = Get-AzOperationalInsightsWorkspace @WorkspaceParams 
    
    $AzMonitorLogAnalyticsSolution = @{
        Type                = 'AzureAutomation'
        ResourceGroupName   = $ResourceGroupName
        Location            = $workspace.Location
        WorkspaceResourceId = $workspace.ResourceId
    }
    New-AzMonitorLogAnalyticsSolution @AzMonitorLogAnalyticsSolution -ErrorAction SilentlyContinue
}

function GetRegistrationInfo {
    $InsightsWorkspace = @{
        ResourceGroupName = $ResourceGroupName
        Name              = $WorkspaceName
    }
    $Workspace = Get-AzOperationalInsightsWorkspace @InsightsWorkspace
         
    $WorkspaceSharedKey = @{
        ResourceGroupName = $ResourceGroupName
        Name              = $WorkspaceName
    }
    $WorkspaceKeys = Get-AzOperationalInsightsWorkspaceSharedKey @WorkspaceSharedKey
         
    $AzAutomationRegistrationInfo = @{
        ResourceGroupName     = $ResourceGroupName
        AutomationAccountName = $AutomationAccountName
    }
    $AutomationReg = Get-AzAutomationRegistrationInfo @AzAutomationRegistrationInfo
        @"
        `$WorkspaceID = '$($Workspace.CustomerId)'
        `$WorkSpaceKey = '$($WorkspaceKeys.PrimarySharedKey)'
        `$AutoURL = '$($AutomationReg.Endpoint)'
        `$AutoKey = '$($AutomationReg.PrimaryKey)'
"@
}

function ConvertAutomationAccountToManagedIdentity {
    $AzStorageAccount = @{
        ResourceGroupName = $ResourceGroupName
        AccountName       = $StorageAccountName
    }
    $storage = Get-AzStorageAccount @AzStorageAccount
         
    $AzAutomationAccount = @{
        ResourceGroupName     = $ResourceGroupName
        AutomationAccountName = $AutomationAccountName
        AssignSystemIdentity  = $true
    }
    $Identity = Set-AzAutomationAccount @AzAutomationAccount
         
    $AzRoleAssignment = @{
        ObjectId           = $Identity.Identity.PrincipalId
        Scope              = $storage.Id
        RoleDefinitionName = "Contributor"
    }
    Start-Sleep -Seconds 20
    New-AzRoleAssignment @AzRoleAssignment
}

& $main