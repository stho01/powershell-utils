 # Confirm if the self-signed Authenticode certificate exists in the computer's Personal certificate store
 Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.Subject -eq "CN=STHOScriptSignCert"}
# Confirm if the self-signed Authenticode certificate exists in the computer's Root certificate store
 Get-ChildItem Cert:\LocalMachine\Root | Where-Object {$_.Subject -eq "CN=STHOScriptSignCert"}
# Confirm if the self-signed Authenticode certificate exists in the computer's Trusted Publishers certificate store
 Get-ChildItem Cert:\LocalMachine\TrustedPublisher | Where-Object {$_.Subject -eq "CN=STHOScriptSignCert"}