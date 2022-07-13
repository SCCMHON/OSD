$clientId = "b70671ce-5631-42dc-82f4-536ac6aa2843" #Provide the Client ID
$clientSecret = "K_2FiG3dQy2A6A-_KFgIXg_whN298_qB3m" # Provide the ClientSecret
$ourTenantId = "96ece526-9c7d-48b0-8daf-8b93c90a5d18" #Specify the TenatID

$Resource = "deviceManagement/windowsAutopilotDeviceIdentities"
$Resource = "deviceManagement/managedDevices"
$graphApiVersion = "Beta"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
$authority = "https://login.microsoftonline.com/$ourTenantId"
Update-MSGraphEnvironment -AppId $clientId -Quiet
Update-MSGraphEnvironment -AuthUrl $authority -Quiet
Connect-MSGraph -ClientSecret $clientSecret | Out-Null

#$SerialNumbers = Get-Content -Path "SerialNumber.txt" #Provide the list of device you want to check the GroupTag
$Serial = (Get-WmiObject -class win32_bios).SerialNumber
$GT = Get-AutopilotDevice -serial $Serial | Select-Object -ExpandProperty groupTag
$GT