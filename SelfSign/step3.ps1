$path = "C:\Users\$env:USERNAME\Documents\WindowsPowerShell\Modules\git-shorts\git-shorts.psm1"

# Get the code-signing certificate from the local computer's certificate store with the name *ATA Authenticode* and store it to the $codeCertificate variable.
$codeCertificate = Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.Subject -eq "CN=STHOScriptSignCert"}

# Sign the PowerShell script
# PARAMETERS:
# FilePath - Specifies the file path of the PowerShell script to sign, eg. C:\ATA\myscript.ps1.
# Certificate - Specifies the certificate to use when signing the script.
# TimeStampServer - Specifies the trusted timestamp server that adds a timestamp to your script's digital signature. Adding a timestamp ensures that your code will not expire when the signing certificate expires.
Set-AuthenticodeSignature -FilePath $path -Certificate $codeCertificate -TimeStampServer "http://timestamp.digicert.com"