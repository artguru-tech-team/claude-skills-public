# Run AS ADMIN
# Compacte le vhdx Ubuntu — stoppe services WSL pour eviter le lock

$vhdx = "C:\Users\aquam\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu_79rhkp1fndgsc\LocalState\ext4.vhdx"

Write-Host "=== Free C avant ===" -ForegroundColor Cyan
$beforeC = (Get-PSDrive C).Free
"{0:N2} GB" -f ($beforeC / 1GB)

$beforeV = (Get-Item $vhdx).Length / 1GB
Write-Host "`n=== Taille vhdx avant ===" -ForegroundColor Cyan
"{0:N2} GB" -f $beforeV

Write-Host "`n=== Stop Docker Desktop ===" -ForegroundColor Cyan
Get-Process -Name 'Docker Desktop','com.docker.service','com.docker.backend','com.docker.build','vpnkit*' -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep 2

Write-Host "`n=== wsl --shutdown ===" -ForegroundColor Cyan
wsl --shutdown
Start-Sleep 5

Write-Host "`n=== Stop services WSL ===" -ForegroundColor Cyan
Stop-Service -Name 'LxssManager' -Force -ErrorAction SilentlyContinue
Stop-Service -Name 'vmcompute' -Force -ErrorAction SilentlyContinue
Stop-Service -Name 'WSLService' -Force -ErrorAction SilentlyContinue
Start-Sleep 5

Write-Host "`n=== Verifie qui tient le vhdx ===" -ForegroundColor Cyan
$handles = & cmd /c "openfiles /query /fo csv 2>nul" | Select-String -Pattern 'ext4.vhdx'
if ($handles) { Write-Host "Encore lock par:" $handles -ForegroundColor Red } else { Write-Host "Aucun process ne tient le fichier (ou openfiles non actif)" }

Write-Host "`n=== diskpart compact ===" -ForegroundColor Cyan
$script = @"
select vdisk file="$vhdx"
attach vdisk readonly
compact vdisk
detach vdisk
exit
"@
$tmp = New-TemporaryFile
$script | Set-Content -Path $tmp -Encoding ASCII
diskpart /s $tmp.FullName
Remove-Item $tmp -Force

Write-Host "`n=== Restart services ===" -ForegroundColor Cyan
Start-Service -Name 'LxssManager' -ErrorAction SilentlyContinue
Start-Service -Name 'vmcompute' -ErrorAction SilentlyContinue

Write-Host "`n=== Resultat ===" -ForegroundColor Cyan
$afterV = (Get-Item $vhdx).Length / 1GB
"vhdx : {0:N2} GB -> {1:N2} GB  (gain {2:N2} GB)" -f $beforeV, $afterV, ($beforeV - $afterV)
$afterC = (Get-PSDrive C).Free
"C:   : {0:N2} GB -> {1:N2} GB  (gain {2:N2} GB)" -f ($beforeC/1GB), ($afterC/1GB), (($afterC - $beforeC)/1GB)
