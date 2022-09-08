
  Write-Host "Checking Internet Connectivity..." -ForegroundColor Yellow
  $TestResult = (Test-NetConnection -ComputerName login.microsoftonline.com -Port 443).TcpTestSucceeded
  if ($TestResult -eq $true){
    Write-Host "Connection to login.microsoftonline.com .............. Succeeded." -ForegroundColor Green 
  }else{
    Write-Host "Connection to login.microsoftonline.com ................. failed." -ForegroundColor Red 
  }

  $TestResult = (Test-NetConnection -ComputerName device.login.microsoftonline.com -Port 443).TcpTestSucceeded
  if ($TestResult -eq $true){
    Write-Host "Connection to device.login.microsoftonline.com ......  Succeeded." -ForegroundColor Green 
  }else{
    Write-Host "Connection to device.login.microsoftonline.com .......... failed." -ForegroundColor Red 
  }

$TestResult = (Test-NetConnection -ComputerName autologon.microsoftazuread-sso.com -Port 443).TcpTestSucceeded
if ($TestResult -eq $true){
    Write-Host "Connection to autologon.microsoftazuread-sso.com ......  Succeeded." -ForegroundColor Green 
}else{
    Write-Host "Connection to autologon.microsoftazuread-sso.comm .......... failed." -ForegroundColor Red 
}

  $TestResult = (Test-NetConnection -ComputerName enterpriseregistration.windows.net -Port 443).TcpTestSucceeded
  if ($TestResult -eq $true){
    Write-Host "Connection to enterpriseregistration.windows.net ..... Succeeded." -ForegroundColor Green 
  }else{
    Write-Host "Connection to enterpriseregistration.windows.net ........ failed." -ForegroundColor Red 
  }

    $TestResult = (Test-NetConnection -ComputerName time.windows.com -Port 443).TcpTestSucceeded
  if ($TestResult -eq $true){
    Write-Host "Connection to time.windows.com ..... Succeeded." -ForegroundColor Green 
  }else{
    Write-Host "Connection to time.windows.com ........ failed." -ForegroundColor Red 
  }