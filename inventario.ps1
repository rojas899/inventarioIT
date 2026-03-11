$equipo = $env:COMPUTERNAME
$usuario = $env:USERNAME

$bios = Get-CimInstance Win32_BIOS
$serial = $bios.SerialNumber

$cs = Get-CimInstance Win32_ComputerSystem
$modelo = $cs.Model
$ram = [math]::Round($cs.TotalPhysicalMemory / 1GB)

$disco = [math]::Round((Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'").Size / 1GB)

$ip = (Get-NetIPAddress -AddressFamily IPv4 |
Where-Object {$_.IPAddress -notlike "169.*"} |
Select-Object -First 1).IPAddress

$os = Get-CimInstance Win32_OperatingSystem
$windows = $os.Caption
$version = $os.Version

$fecha = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$division = Read-Host "Ingrese la division"

$url = "https://script.google.com/macros/s/AKfycbzT2NJunMlEm4W35XIkjVyZ8kB8mjEi4No4zWZJCWi8M4M9Q17YwPTOTqhCBNLF2rFP/exec"

$data = @{
equipo=$equipo
usuario=$usuario
serial=$serial
modelo=$modelo
ram=$ram
disco=$disco
ip=$ip
windows=$windows
version=$version
fecha=$fecha
division=$division
} | ConvertTo-Json

Invoke-RestMethod -Uri $url -Method Post -Body $data -ContentType "application/json"

Write-Host "Inventario enviado correctamente"
Read-Host "Presione ENTER para cerrar"