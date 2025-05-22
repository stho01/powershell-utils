$codeCertificate = Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.Subject -eq "CN=STHOScriptSignCert"}

if ($null -eq $codeCertificate) {
    Write-Host "Certificate not found.. Will create new certificate"

    # Generate a self-signed Authenticode certificate in the local computer's personal certificate store.
    $authenticode = New-SelfSignedCertificate -Subject "STHOScriptSignCert" -CertStoreLocation Cert:\LocalMachine\My -Type CodeSigningCert

    # Add the self-signed Authenticode certificate to the computer's root certificate store.
    ## Create an object to represent the LocalMachine\Root certificate store.
    $rootStore = [System.Security.Cryptography.X509Certificates.X509Store]::new("Root","LocalMachine")
    ## Open the root certificate store for reading and writing.
    $rootStore.Open("ReadWrite")
    ## Add the certificate stored in the $authenticode variable.
    $rootStore.Add($authenticode)
    ## Close the root certificate store.
    $rootStore.Close()
    
    # Add the self-signed Authenticode certificate to the computer's trusted publishers certificate store.
    ## Create an object to represent the LocalMachine\TrustedPublisher certificate store.
    $publisherStore = [System.Security.Cryptography.X509Certificates.X509Store]::new("TrustedPublisher","LocalMachine")
    ## Open the TrustedPublisher certificate store for reading and writing.
    $publisherStore.Open("ReadWrite")
    ## Add the certificate stored in the $authenticode variable.
    $publisherStore.Add($authenticode)
    ## Close the TrustedPublisher certificate store.
    $publisherStore.Close()
} else {
    Write-Host "Existing certificate found.. Will use existing..."
}

 # Confirm if the self-signed Authenticode certificate exists in the computer's Personal certificate store
 Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.Subject -eq "CN=STHOScriptSignCert"}
# Confirm if the self-signed Authenticode certificate exists in the computer's Root certificate store
 Get-ChildItem Cert:\LocalMachine\Root | Where-Object {$_.Subject -eq "CN=STHOScriptSignCert"}
# Confirm if the self-signed Authenticode certificate exists in the computer's Trusted Publishers certificate store
 Get-ChildItem Cert:\LocalMachine\TrustedPublisher | Where-Object {$_.Subject -eq "CN=STHOScriptSignCert"}