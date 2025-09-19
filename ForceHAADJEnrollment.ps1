$HAADJStatus = dsregcmd.exe /status | Select-String -Pattern "AzureAdJoined : NO" -SimpleMatch

if ($HAADJStatus) {
    Start-ScheduledTask -TaskName Automatic-Device-Join -TaskPath "\Microsoft\Windows\Workplace Join"
}