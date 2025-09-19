param (
    [Parameter(Mandatory = $true)]
    [string]$DisplayName,

    [Parameter(Mandatory = $true)]
    [ValidateSet("AzureADMyOrg", "AzureADMultipleOrgs", "AzureADandPersonalMicrosoftAccount")]
    [string]$SignInAudience
)

Import-Module Microsoft.Graph.Applications

# Connect to Microsoft Graph (prompt for login if needed)
Connect-MgGraph -Scopes "Application.ReadWrite.All", "Directory.ReadWrite.All"

# Create the application
Write-Host "Creating application: $DisplayName"
$app = New-MgApplication -DisplayName $DisplayName -SignInAudience $SignInAudience

# Create the service principal
Write-Host "Creating service principal for App ID: $($app.AppId)"
$params = @{ appId = $app.AppId }
$sp = New-MgServicePrincipal -BodyParameter $params

# Output details
Write-Host "Application and Service Principal created successfully."
Write-Host "Application ID:       $($app.AppId)"
Write-Host "Service Principal ID: $($sp.Id)"