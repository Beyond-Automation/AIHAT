function Get-SystemHealth {
    [CmdletBinding()]
    param()

    try {
        $operatingSystem = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop
        $computerSystem  = Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction Stop
        $processor       = Get-CimInstance -ClassName Win32_Processor -ErrorAction Stop |
            Select-Object -First 1

        $systemDrive = Get-CimInstance `
            -ClassName Win32_LogicalDisk `
            -Filter "DeviceID='$($env:SystemDrive)'" `
            -ErrorAction Stop

        if (-not $systemDrive) {
            throw "Unable to locate system drive $($env:SystemDrive)."
        }

        $uptime = (Get-Date) - $operatingSystem.LastBootUpTime

        $totalMemoryBytes = [double]$computerSystem.TotalPhysicalMemory
        $freeMemoryBytes  = [double]$operatingSystem.FreePhysicalMemory * 1KB
        $usedMemoryBytes  = $totalMemoryBytes - $freeMemoryBytes

        [PSCustomObject]@{
            ComputerName      = $env:COMPUTERNAME
            OperatingSystem   = $operatingSystem.Caption
            OSVersion         = $operatingSystem.Version
            LastBootTime      = $operatingSystem.LastBootUpTime
            UptimeDays        = [math]::Round($uptime.TotalDays, 2)
            Processor         = $processor.Name
            LogicalProcessors = $processor.NumberOfLogicalProcessors
            TotalMemoryGB     = [math]::Round($totalMemoryBytes / 1GB, 2)
            UsedMemoryGB      = [math]::Round($usedMemoryBytes / 1GB, 2)
            MemoryUsagePct    = [math]::Round(($usedMemoryBytes / $totalMemoryBytes) * 100, 2)
            SystemDrive       = $systemDrive.DeviceID
            DiskSizeGB        = [math]::Round($systemDrive.Size / 1GB, 2)
            DiskFreeGB        = [math]::Round($systemDrive.FreeSpace / 1GB, 2)
            DiskFreePct       = [math]::Round(($systemDrive.FreeSpace / $systemDrive.Size) * 100, 2)
            CollectedAt       = Get-Date
            CollectionStatus  = 'Success'
        }
    }
    catch {
        [PSCustomObject]@{
            ComputerName     = $env:COMPUTERNAME
            CollectedAt      = Get-Date
            CollectionStatus = 'Failed'
            ErrorMessage     = $_.Exception.Message
        }
    }
}