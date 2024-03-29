﻿Write-Host -ForegroundColor Green "Installing Intune Graph Connector Module"
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
$Serial =""
$Serial = (Get-WmiObject -class win32_bios).SerialNumber
$GT = ""
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

#Write-Host "Please press any key to continue" -F Yellow
#[Console]::ReadKey() | Out-Null

#######################################################################################

# Prompt User From Selection

$answer = Read-Host "Would you like to change the current group tag of $GT ? Y/N"

while("y","n" -notcontains $answer)
{
	$answer = Read-Host "y or n"
}

if ($answer -eq "y")
{
# Prompt for Group Tag Selection

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'AutoPilot Group Tag'
$form.Size = New-Object System.Drawing.Size(380,200)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,120)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,120)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please Select Group Tag:'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(260,100)
$listBox.Height = 80

[void] $listBox.Items.Add('Azure-USCANLA')
[void] $listBox.Items.Add('Azure-EMEA')
[void] $listBox.Items.Add('Azure-APAC')

$x = ""

$form.Controls.Add($listBox)

$form.Topmost = $true

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $x = $listBox.SelectedItem
    $x
}

# Set Group Tag

Write-Host -ForegroundColor Green "Changing Group Tag to $x"
Get-AutopilotDevice -serial $Serial | Set-AutopilotDevice -groupTag $x

}
else
{
Write-Host "Not Changing Group Tag. Current tag: $GT " -ForegroundColor Green
}

############## Detect & Remove Existing Intune Device ###########

Write-Host -ForegroundColor Green "Checking For Intune Associated Device..."
$devicename = ""
$devicename = Get-IntuneManagedDevice -Filter ("SerialNumber eq '$Serial'") | Select-Object -ExpandProperty deviceName

   if ($devicename)
   {
    Write-Host -ForegroundColor Red "Associated Intune Device Found"
    Write-Host -ForegroundColor Yellow "Associated Intune Device Name: $devicename"
    # Prompt for removal

$answer2 = Read-Host "Would you like to remove the Associated Intune Device: $devicename ? Y/N"

while("y","n" -notcontains $answer2)
{
	$answer2 = Read-Host "y or n"
}
if ($answer2 -eq "y")
{
Write-Host -ForegroundColor Yellow "Removing Intune Device..."
$id = Get-AutopilotDevice -serial $Serial | Select-Object -ExpandProperty managedDeviceId
Remove-IntuneManagedDevice -managedDeviceId $id
 }
else
{
Write-Host "Not removing device. Skipping" -ForegroundColor Yellow
}
}

else
 {
     Write-Host -ForegroundColor Green "No Associated Intune Device Found. Continuing Deployment."    
     }

############### 

# Logging to SQL DB


###############


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

#URL to custom WIM
#$ImageFileUrl = "https://sccmshare.blob.core.windows.net/osd/install.wim" # Win10 20H1
#$ImageFileUrl = "https://sccmshare.blob.core.windows.net/osd/install-3-Windows-10-Enterprise.wim" # Win10 21H2
$ImageFileUrl = "https://sccmshare.blob.core.windows.net/osd/Win_11_21H2_Index3.wim" # Win11 20H2

#Start OSDCloud ZTI the RIGHT way
Write-Host  -ForegroundColor Green "Starting OSDCloud. Please Wait..."

Start-OSDCloud -ZTI -SkipAutopilot -SkipODT -ImageFileUrl "$ImageFileUrl"
#Start-OSDCloud -ZTI -SkipAutopilot -SkipODT -ImageFileUrl "$ImageFileUrl" -ImageIndex 3 -Verbose
#Start-OSDCloud -OSLanguage en-us -OSBuild 21H2 -OSEdition Enterprise -ZTI

#Start-OSCloudGUI

#Restart from WinPE

Write-Host "Image Deployment Complete. Remove any USB Drives and press any key to continue" -F Green
[Console]::ReadKey() | Out-Null

Write-Host  -ForegroundColor Green "Restarting in 30 seconds! Remove Any USB Drives!"
Start-Sleep -Seconds 30
wpeutil reboot


#https://raw.githubusercontent.com/SCCMHON/OSD/main/osd.ps1