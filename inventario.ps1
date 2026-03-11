$equipo = $env:COMPUTERNAME
$usuario = $env:USERNAME

$serial = (Get-CimInstance Win32_BIOS).SerialNumber
$modelo = (Get-CimInstance Win32_ComputerSystem).Model

$ram = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
$disco = [math]::Round((Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'").Size / 1GB)

$division = Read-Host "Ingrese la division"

$url = "https://script.google.com/macros/s/AKfycbyAviq07Ej02_1CZ5-gpFiBEn-GCJiGg-B7T2QTP9TnjMhBtiNj_pdyzKJrGCuCLH46/exec"

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