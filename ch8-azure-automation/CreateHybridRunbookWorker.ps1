$AutoUrl = '<removed>'
$AutoKey = '<removed>'
$Group   = $env:COMPUTERNAME
 
$Path = 'HKLM:\SOFTWARE\Microsoft\System Center ' +
    'Operations Manager\12\Setup\Agent'
$installPath = Get-ItemProperty -Path $Path |
    Select-Object -ExpandProperty InstallDirectory
$AutomationFolder = Join-Path $installPath 'AzureAutomation'
 
$ChildItem = @{
    Path    = $AutomationFolder
    Recurse = $true
    Include = 'HybridRegistration.psd1'
}
$modulePath = Get-ChildItem @ChildItem | Select-Object -ExpandProperty FullName
 
Import-Module $modulePath
 
$HybridRunbookWorker = @{
    Url       = $AutoUrl
    key       = $AutoKey
    GroupName = $Group
}
Add-HybridRunbookWorker @HybridRunbookWorker