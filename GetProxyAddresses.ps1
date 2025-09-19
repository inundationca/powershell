# Import the Active Directory module
Import-Module ActiveDirectory

# Set the distinguished name (DN) of the target OU
$ouDN = "OU=Internal,OU=User Accounts,OU=S00 - Corporate,DC=ad,DC=georgeandbell,DC=com"

# Get all users in the specified OU with proxyAddresses
$users = Get-ADUser -SearchBase $ouDN -Filter * -Properties mail, proxyAddresses

foreach ($user in $users) {
    $aliases = $user.proxyAddresses | Where-Object { $_ -like "smtp:*" -or $_ -like "SMTP:*" }

    if ($aliases) {
        Write-Host "User: $($user.SamAccountName)"
        Write-Host "Primary Email: $($user.mail)"
        Write-Host "Aliases:"
        foreach ($alias in $aliases) {
            Write-Host "`t$alias"
        }
        Write-Host "`n---------------------------`n"
    }
}