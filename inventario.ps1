$equipo = $env:COMPUTERNAME
$usuario = $env:USERNAME

$serial = (Get-CimInstance Win32_BIOS).SerialNumber
$modelo = (Get-CimInstance Win32_ComputerSystem).Model

$ram = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
$disco = [math]::Round((Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'").Size / 1GB)

$division = Read-Host "Ingrese la division"

$carpeta = "$env:USERPROFILE\InventarioIT"
New-Item -ItemType Directory -Path $carpeta -Force | Out-Null

$ruta = "$carpeta\InventarioEquipos.csv"

if (!(Test-Path $ruta)) {
"Equipo,Usuario,Serie,Modelo,RAM_GB,Disco_GB,Division" | Out-File $ruta
}

"$equipo,$usuario,$serial,$modelo,$ram,$disco,$division" | Out-File $ruta -Append

Write-Host "Inventario guardado en $ruta"
Read-Host "Presione ENTER para cerrar"