param (
    [Parameter(Mandatory = $true)]
    [string]$ComputerName
)

$cred = Get-Credential

# Optional: Set TrustedHosts if needed (uncomment if connecting to non-domain machines)
# Set-Item WSMan:\localhost\Client\TrustedHosts -Value $ComputerName -Force

if (Test-Connection -ComputerName $ComputerName -Count 2 -Quiet) {
    Enter-PSSession -ComputerName $ComputerName -Credential $cred

} else {
    Write-Host "Cannot reach $ComputerName."
}