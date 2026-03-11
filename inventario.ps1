$equipo = $env:COMPUTERNAME
$usuario = $env:USERNAME

$serial = (Get-CimInstance Win32_BIOS).SerialNumber
$modelo = (Get-CimInstance Win32_ComputerSystem).Model

$ram = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
$disco = [math]::Round((Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'").Size / 1GB)

$division = Read-Host "Ingrese la division"

$url = "https://script.google.com/macros/s/AKfycbyGsCEWUDe1Qza9vsJH_9M9oTaHNTun983YiXc1Zlj7FWj6YsNsNMFgbeFQZ_pxc5ml/exec"

$data = @{
equipo=$equipo
usuario=$usuario
serial=$serial
modelo=$modelo
ram=$ram
disco=$disco
division=$division
} | ConvertTo-Json

Invoke-RestMethod -Uri $url -Method Post -Body $data -ContentType "application/json"

Write-Host "Inventario enviado correctamente"