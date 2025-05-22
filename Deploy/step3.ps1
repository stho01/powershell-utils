# Path til målmappen der modulen skal installeres
# $targetModulePath = "C:\Users\$env:USERNAME\Documents\PowerShell\Modules\git-shorts"
$targetModulePath = $(Split-Path $profile) + "\modules\git-shorts"

# Path til prosjektets modulmappe
$sourceModulePath = Join-Path -Path $PSScriptRoot -ChildPath "..\modules\git-shorts"

# Hent kode-signeringsertifikatet
$codeCertificate = Get-ChildItem Cert:\LocalMachine\My | Where-Object {
    $_.Subject -eq "CN=STHOScriptSignCert"
}

if (-not $codeCertificate) {
    Write-Error "Fant ikke sertifikatet 'CN=STHOScriptSignCert'. Avbryter."
    exit 1
}

# Slett eksisterende filer i målmappen
if (Test-Path $targetModulePath) {
    Remove-Item -Path $targetModulePath\* -Recurse -Force
} else {
    # Opprett mappen hvis den ikke finnes
    New-Item -Path $targetModulePath -ItemType Directory -Force | Out-Null
}

# Kopier nye filer inn i målmappen
Copy-Item -Path "$sourceModulePath\*" -Destination $targetModulePath -Recurse -Force

# Signer alle relevante filer
$filesToSign = Get-ChildItem -Path $targetModulePath -Recurse -Include *.ps1, *.psm1, *.psd1

foreach ($file in $filesToSign) {
    Write-Host "Signer: $($file.FullName)"
    Set-AuthenticodeSignature -FilePath $file.FullName `
        -Certificate $codeCertificate `
        -TimestampServer "http://timestamp.digicert.com"
}

Write-Host "Deploy og signering fullført ✅"