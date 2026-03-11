$equipo = $env:COMPUTERNAME
$usuario = $env:USERNAME

$bios = Get-CimInstance Win32_BIOS
$serial = $bios.SerialNumber

$cs = Get-CimInstance Win32_ComputerSystem
$modelo = $cs.Model
$ram = [math]::Round($cs.TotalPhysicalMemory / 1GB)

# Detectar Laptop o Desktop
$tipoEquipo = "Desktop"
$bateria = Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue
if ($bateria) {
    $tipoEquipo = "Laptop"
}

# Disco
$discoInfo = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
$disco = [math]::Round($discoInfo.Size / 1GB)

# Detectar SSD o HDD
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

# Fecha
$fecha = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# División
$division = Read-Host "Ingrese la division"

# URL de tu Apps Script
$url = "https://script.google.com/macros/s/AKfycbz64pTS--KwYkhTKpH_9VVoRoT6ws856UHdiQZYz1d6l4Tljjyk-YfmoYaT64hGpYMy/exec"

$data = @{
equipo=$equipo
usuario=$usuario
serial=$serial
modelo=$modelo
tipoEquipo=$tipoEquipo
ram=$ram
disco=$disco
tipoDisco=$tipoDisco
ip=$ip
windows=$windows
version=$version
fecha=$fecha
division=$division
} | ConvertTo-Json

Invoke-RestMethod -Uri $url -Method Post -Body $data -ContentType "application/json"

Write-Host "Inventario enviado correctamente"
Read-Host "Presione ENTER para cerrar"