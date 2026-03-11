$equipo = $env:COMPUTERNAME
$usuario = $env:USERNAME

$serial = (Get-CimInstance Win32_BIOS).SerialNumber
$modelo = (Get-CimInstance Win32_ComputerSystem).Model

$ram = [math]::round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
$disco = [math]::round((Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'").Size / 1GB)

$division = Read-Host "Ingrese la division"

$ruta = "C:\Users\pedro.rojas\OneDrive\InventarioIT\InventarioEquipos.csv"

"$equipo,$usuario,$serial,$modelo,$ram,$disco,$division" | Out-File $ruta -Append

Write-Host ""
Write-Host "Inventario registrado correctamente"
Read-Host "Presione ENTER para cerrar"