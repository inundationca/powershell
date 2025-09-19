<#
.SYNOPSIS
  Connects to various Microsoft 365 services, controlled by switches.

.DESCRIPTION
  Enable logging into Microsoft Exchange, Security & Compliance, Teams, SharePoint, and Graph for management via PowerShell.

  To use, ensure the following modules are installed:

  Install-Module -Scope CurrentUser -Name MicrosoftOnlineManagement
  Install-Module -Scope CurrentUser -Name MicrosoftTeams
  Install-Module -Scope CurrentUser -Name Microsoft.Online.SharePoint.PowerShell -AllowClobber
  Install-Module -Scope Currentuser -Name Microsoft.Graph

.NOTES
  Version:        1.0
  Author:         Tyler Rasmussen
  Creation Date:  December 11th, 2024
  Purpose/Change: Initial script development
  
.EXAMPLE
  .\ConnectMicrosoft365.ps1 -Exchange #Connects to Microsoft Exchange.
  .\ConnectMicrosoft365.ps1 -SharePoint #Connects to SharePoint.
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

param (
    [switch]$Graph,
    [switch]$Exchange,
    [switch]$SharePoint,
    [switch]$Security,
    [switch]$Teams,
    [switch]$Azure,
    [switch]$Disconnect
)

#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"


#----------------------------------------------------------[Declarations]----------------------------------------------------------

$orgName = "twobyte" # for example, litwareinc for litwareinc.onmicrosoft.com

#-----------------------------------------------------------[Functions]------------------------------------------------------------

#-----------------------------------------------------------[Execution]------------------------------------------------------------

Import-Module ExchangeOnlineManagement
Import-Module MicrosoftTeams
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
Import-Module Az

if ($Graph) {
  # Log into Microsoft Graph.
  Connect-MgGraph -Scopes "User.Read.All","Group.ReadWrite.All","Application.ReadWrite.All"
}

if ($Exchange) {
  # Log into Microsoft Exchange
  Connect-ExchangeOnline -ShowProgress $true
}

if ($SharePoint) {
  # Log into SharePoint.
  Connect-SPOService -Url https://$orgName-admin.sharepoint.com
}

if ($Security) {
  # Log into Microsoft Security and Compliance.
  Connect-IPPSSession
}

if ($Teams) {
  # Log into Microsoft Teams.
  Connect-MicrosoftTeams
}

if ($Azure) {
  # Log into Microsoft Azure.
  Connect-AzAccount
}

if ($Disconnect) {
  Disconnect-SPOService; Disconnect-MicrosoftTeams; Disconnect-ExchangeOnline
}