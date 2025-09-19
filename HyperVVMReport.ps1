# Get all VMs on the host
$vms = Get-VM

# Build a report
$report = foreach ($vm in $vms) {
    $vmName = $vm.Name
    $cpuCount = $vm.ProcessorCount
    $memory = $vm.MemoryStartup / 1MB

    # Get associated VHD(s)
    $vhdDrives = Get-VMHardDiskDrive -VMName $vmName
    foreach ($vhd in $vhdDrives) {
        $vhdPath = $vhd.Path
        if (Test-Path $vhdPath) {
            $vhdSizeBytes = (Get-Item $vhdPath).Length
            $vhdSizeGB = [math]::Round($vhdSizeBytes / 1GB, 2)
        } else {
            $vhdSizeGB = "N/A"
        }

        # Output per VHD
        [PSCustomObject]@{
            VMName     = $vmName
            CPUCount   = $cpuCount
            MemoryMB   = $memory
            VHDPath    = $vhdPath
            VHDSizeGB  = $vhdSizeGB
        }
    }
}

# Export to CSV
$report | Export-Csv -Path "C:\Report.csv" -NoTypeInformation