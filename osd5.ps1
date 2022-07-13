Write-Host -ForegroundColor Green "Installing Intune Graph Connector Module"
Install-Module -Name Microsoft.Graph.Intune -Force
Write-Host -ForegroundColor Green "Installing Windows AutoPilot Intune Connector Module"
Install-Module -Name WindowsAutoPilotIntune -Force
Write-Host -ForegroundColor Green "Determing Current Group TAG"
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
#Clear-Host
Start-Sleep 2
Write-Host  "*****************************************" -F Yellow
Write-Host  "*                                       *" -F Yellow
Write-Host  "*                                       *" -F Yellow 
Write-Host  " Current Group TAG is: $GT" -F Green
Write-Host  "*                                       *" -F Yellow
Write-Host  "*                                       *" -F Yellow
Write-Host  "*****************************************" -F Yellow

Write-Host "Please press any key to continue" -F Yellow
[Console]::ReadKey() | Out-Null


Write-Host  -ForegroundColor Green "Starting Honeywell OSDCloud ZTI"
Start-Sleep -Seconds 5

#Change Display Resolution for Virtual Machine
if ((Get-MyComputerModel) -match 'Virtual') {
    Write-Host  -ForegroundColor Green "Setting Display Resolution to 1600x"
    Set-DisRes 1600
}

#Make sure I have the latest OSD Content
Write-Host  -ForegroundColor Green "Updating OSD PowerShell Module"
Install-Module OSD -Force

Write-Host  -ForegroundColor Green "Importing OSD PowerShell Module"
Import-Module OSD -Force

#Start OSDCloud ZTI the RIGHT way
Write-Host  -ForegroundColor Green "Start OSDCloud"
Start-OSDCloud -OSLanguage en-us -OSBuild 21H2 -OSEdition Enterprise -ZTI

#Restart from WinPE
Write-Host  -ForegroundColor Green "Restarting in 30 seconds!"
Start-Sleep -Seconds 30
wpeutil reboot


#https://raw.githubusercontent.com/SCCMHON/OSD/main/osd.ps1