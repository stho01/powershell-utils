try {
    . $PSScriptRoot/Deploy/step1.ps1
    . $PSScriptRoot/Deploy/step2.ps1
    . $PSScriptRoot/Deploy/step3.ps1
}
finally {
    Set-Location $PSScriptRoot
}