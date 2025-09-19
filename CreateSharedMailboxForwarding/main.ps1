
<#
.SYNOPSIS
  Creates a mailbox and configures forwarding to an external address. Useful when migration/merging organizations.

.DESCRIPTION
  On execution, the script will perform the following steps for each listed user.

    1. Create shared mailbox.
    2. Configure forwarding to an external address.
    3. Hide the account from the GAL.

.PARAMETER
    -CSVPath - Path to CSV.
    
.INPUTS
    None
.OUTPUTS
    None
.NOTES
  Version:        1.0
  Author:         Two Byte Blog
  Creation Date:  June 20, 2025
  
.EXAMPLE
  .\main.ps1 -CsvPath .\mailboxes.csv
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

param (
    [Parameter(Mandatory = $true)]
    [string]$CsvPath
)

#-----------------------------------------------------------[Execution]------------------------------------------------------------

# Import CSV data.
$csvData = Import-Csv -Path $CsvPath

foreach ($mailbox in $csvData) {
    $displayName = $mailbox.DisplayName.Trim()
    $alias       = $mailbox.Alias.Trim()
    $email       = $mailbox.PrimarySmtpAddress.Trim()
    $forwardTo   = $mailbox.ExternalForwardAddress.Trim()

    # Create new shared mailbox.
    if (-not (Get-Mailbox -Identity $email -ErrorAction SilentlyContinue)) {
        Write-Host "$displayName - Creating shared mailbox: $displayName <$email>..."

        New-Mailbox -Shared `
                    -Name $displayName `
                    -DisplayName $displayName `
                    -Alias $alias `
                    -PrimarySmtpAddress $email

        Write-Host "$displayName - Created shared mailbox: $email."
    } else {
        Write-Warning "$displayName - Mailbox $email already exists. Skipping creation."
    }

    # Configure forwarding.
    try {
        Set-Mailbox -Identity $email `
                    -ForwardingSmtpAddress $forwardTo `
                    -DeliverToMailboxAndForward $false

        Write-Host "$displayName - Forwarding set from $email to $forwardTo."
    } catch {
        Write-Error "$displayName - Failed to set forwarding for: $_."
    }

    # Enable hiding shared mailbox from GAL.
    try {
        Set-Mailbox -Identity $email -HiddenFromAddressListsEnabled $true
        Write-Host "$displayName - $email hidden from GAL."
    } catch {
        Write-Warning "$displayName - Could not hide $email from GAL."
    }
}