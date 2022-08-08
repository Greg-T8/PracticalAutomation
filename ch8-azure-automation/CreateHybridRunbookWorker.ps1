$AutoUrl = 'https://08c6f4de-1f8c-4862-93c1-8b441bffce4f.agentsvc.scus.azure-automation.net/accounts/08c6f4de-1f8c-4862-93c1-8b441bffce4f'
$AutoKey = 'HNtH/YuAUkciGKxZnxRk+lqFnOW2sYfiRfO3P5NTuN2MAetNKGdUcT6dHNaZcIK/Y2rHjR77Rc7ldvY+3ANP9A=='
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