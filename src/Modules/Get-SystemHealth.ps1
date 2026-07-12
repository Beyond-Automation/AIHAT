function Get-SystemHealth {
    [CmdletBinding()]
    param()

    $operatingSystem = Get-CimInstance -ClassName Win32_OperatingSystem
    $computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem
    $processor = Get-CimInstance -ClassName Win32_Processor | Select-Object -First 1
    $systemDrive = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='$($env:SystemDrive)'"

    $uptime = (Get-Date) - $operatingSystem.LastBootUpTime
    $memoryUsedBytes = $computerSystem.TotalPhysicalMemory - $operatingSystem.FreePhysicalMemory * 1KB

    [PSCustomObject]@{
        ComputerName      = $env:COMPUTERNAME
        OperatingSystem   = $operatingSystem.Caption
        OSVersion         = $operatingSystem.Version
        LastBootTime      = $operatingSystem.LastBootUpTime
        UptimeDays        = [math]::Round($uptime.TotalDays, 2)
        Processor         = $processor.Name
        LogicalProcessors = $processor.NumberOfLogicalProcessors
        TotalMemoryGB     = [math]::Round($computerSystem.TotalPhysicalMemory / 1GB, 2)
        UsedMemoryGB      = [math]::Round($memoryUsedBytes / 1GB, 2)
        SystemDrive       = $systemDrive.DeviceID
        DiskSizeGB        = [math]::Round($systemDrive.Size / 1GB, 2)
        DiskFreeGB        = [math]::Round($systemDrive.FreeSpace / 1GB, 2)
        CollectedAt       = Get-Date
    }
}