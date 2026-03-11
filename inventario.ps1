$equipo = $env:COMPUTERNAME
$usuario = $env:USERNAME

# BIOS
$bios = Get-CimInstance Win32_BIOS
$serial = $bios.SerialNumber

# Sistema
$cs = Get-CimInstance Win32_ComputerSystem
$modelo = $cs.Model
$ram = [math]::Round($cs.TotalPhysicalMemory / 1GB)

# Laptop o Desktop
$tipoEquipo = "Desktop"
$bateria = Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue
if ($bateria) {
$tipoEquipo = "Laptop"
}

# Disco
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"

$discoTotal = [math]::Round($disk.Size / 1GB)
$discoLibre = [math]::Round($disk.FreeSpace / 1GB)
$discoUsado = $discoTotal - $discoLibre

# SSD o HDD
$tipoDisco = "HDD"
$physical = Get-PhysicalDisk -ErrorAction SilentlyContinue | Select-Object -First 1
if ($physical.MediaType -eq "SSD") {
$tipoDisco = "SSD"
}

# IP
$ip = (Get-NetIPAddress -AddressFamily IPv4 |
Where-Object {$_.IPAddress -notlike "169.*"} |
Select-Object -First 1).IPAddress

# Windows
$os = Get-CimInstance Win32_OperatingSystem
$windows = $os.Caption
$version = $os.Version

# Activación Windows
$lic = Get-CimInstance SoftwareLicensingProduct |
Where-Object {$_.PartialProductKey -and $_.ApplicationID -eq "55c92734-d682-4d71-983e-d6ec3f16059f"}

$activado = "No"
if ($lic.LicenseStatus -eq 1) {
$activado = "Si"
}

# Fecha
$fecha = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# División
$division = Read-Host "Ingrese la division"

# URL Apps Script
$url = "https://script.google.com/macros/s/AKfycbxez5iqVVDixQyLU64Xs5JmTXRAAzUifX1mU6PW8BNovR8Ps4lv-ik2M--knEgv9_R5/exec"

$data = @{
equipo=$equipo
usuario=$usuario
serial=$serial
modelo=$modelo
tipoEquipo=$tipoEquipo
ram=$ram
discoTotal=$discoTotal
discoUsado=$discoUsado
discoLibre=$discoLibre
tipoDisco=$tipoDisco
ip=$ip
windows=$windows
version=$version
activado=$activado
fecha=$fecha
division=$division
} | ConvertTo-Json

Invoke-RestMethod -Uri $url -Method Post -Body $data -ContentType "application/json"

Write-Host "Inventario enviado correctamente"
Read-Host "Presione ENTER para cerrar"