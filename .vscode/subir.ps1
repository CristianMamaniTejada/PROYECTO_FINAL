# Sube la carpeta aipage a https://aipage.rivadex.com
# En VS Code: Ctrl+Shift+B  (o menú Terminal > Ejecutar tarea de compilación)
#
# - Sube todo lo de la carpeta (menos .vscode). Lo que borres aquí también se borra en la web.
# - La versión anterior queda guardada en el servidor (/var/www/aipage.anterior) por si hay que volver atrás.

$ErrorActionPreference = 'Stop'
$carpeta = Split-Path -Parent $PSScriptRoot
$llave = Join-Path $HOME '.ssh\rivadex-aws'
$servidor = 'ubuntu@3.21.81.11'
$paquete = Join-Path $env:TEMP 'aipage.tgz'
$tar = Join-Path $env:WINDIR 'System32\tar.exe'
$ssh = Join-Path $env:WINDIR 'System32\OpenSSH\ssh.exe'
$scp = Join-Path $env:WINDIR 'System32\OpenSSH\scp.exe'

if (-not (Test-Path (Join-Path $carpeta 'index.html'))) {
    Write-Host 'No se subió nada: falta index.html (es la página principal).' -ForegroundColor Red
    exit 1
}

Write-Host 'Empaquetando...' -ForegroundColor Cyan
if (Test-Path $paquete) { Remove-Item $paquete -Force }
& $tar -czf $paquete --exclude .vscode --exclude .git -C $carpeta .
if ($LASTEXITCODE -ne 0) { throw 'No se pudo empaquetar la carpeta.' }

Write-Host 'Subiendo...' -ForegroundColor Cyan
& $scp -q -i $llave $paquete "${servidor}:/tmp/aipage.tgz"
if ($LASTEXITCODE -ne 0) { throw 'No se pudo subir (revisa tu internet).' }

$remoto = 'set -e; sudo rm -rf /var/www/aipage.nuevo; sudo mkdir /var/www/aipage.nuevo; ' +
    'sudo tar -xzf /tmp/aipage.tgz -C /var/www/aipage.nuevo --no-same-owner; rm -f /tmp/aipage.tgz; ' +
    'sudo chown -R www-data:www-data /var/www/aipage.nuevo; ' +
    'sudo find /var/www/aipage.nuevo -type d -exec chmod 755 {} +; sudo find /var/www/aipage.nuevo -type f -exec chmod 644 {} +; ' +
    'sudo rm -rf /var/www/aipage.anterior; sudo mv /var/www/aipage /var/www/aipage.anterior; sudo mv /var/www/aipage.nuevo /var/www/aipage'
& $ssh -i $llave $servidor $remoto
if ($LASTEXITCODE -ne 0) { throw 'El servidor no pudo publicar los cambios. La página anterior sigue en línea.' }
Remove-Item $paquete -Force

Write-Host ''
Write-Host 'Listo: https://aipage.rivadex.com (si no ves el cambio, recarga con Ctrl+F5)' -ForegroundColor Green
