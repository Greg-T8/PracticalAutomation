$WorkspaceID = '<removed>'
$WorkSpaceKey = '<removed>'
 
$agentURL = 'https://download.microsoft.com/download' +
    '/3/c/d/3cd6f5b3-3fbe-43c0-88e0-8256d02db5b7/MMASetup-AMD64.exe'
 
$FileName = Split-Path $agentURL -Leaf
$MMAFile = Join-Path -Path $env:Temp -ChildPath $FileName
Invoke-WebRequest -Uri $agentURL -OutFile $MMAFile | Out-Null
 
$ArgumentList = '/C:"setup.exe /qn ' +
    'ADD_OPINSIGHTS_WORKSPACE=0 ' +
    'AcceptEndUserLicenseAgreement=1"'
$Install = @{
    FilePath     = $MMAFile
    ArgumentList = $ArgumentList
    ErrorAction  = 'Stop'
}
Start-Process @Install -Wait | Out-Null
 
$Object = @{
    ComObject = 'AgentConfigManager.MgmtSvcCfg'
}
$AgentCfg = New-Object @Object
 
$AgentCfg.AddCloudWorkspace($WorkspaceID,
    $WorkspaceKey)
 
Restart-Service HealthService