$clientId = "b70671ce-5631-42dc-82f4-536ac6aa2843"
$clientSecret = "K_2FiG3dQy2A6A-_KFgIXg_whN298_qB3m"
$ourTenantId = "96ece526-9c7d-48b0-8daf-8b93c90a5d18"
$Resource = "deviceManagement/windowsAutopilotDeviceIdentities"
$Resource = "deviceManagement/managedDevices"
$graphApiVersion = "Beta"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
$authority = "https://login.microsoftonline.com/$ourTenantId"
Update-MSGraphEnvironment -AppId $clientId -Quiet
Update-MSGraphEnvironment -AuthUrl $authority -Quiet
Connect-MSGraph -ClientSecret $clientSecret | Out-Null
$Serial = (Get-WmiObject -class win32_bios).SerialNumber
$GT = Get-AutopilotDevice -serial $Serial | Select-Object -ExpandProperty groupTag
$GT
Clear-Host
Start-Sleep 2
Write-Host  "*****************************************" -F Yellow
Write-Host  "*                                       *" -F Yellow
Write-Host  "*                                       *" -F Yellow 
Write-Host  "* " -f Yellow -NoNewline; Write-Host " Current Group TAG is: $GT" -f Green  -NoNewline; Write-Host  "  * " -f Yellow
Write-Host  "*                                       *" -F Yellow
Write-Host  "*                                       *" -F Yellow
Write-Host  "*****************************************" -F Yellow