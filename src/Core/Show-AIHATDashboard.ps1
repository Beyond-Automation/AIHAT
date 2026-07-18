function Show-AIHATDashboard {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject]$Result
    )

    Clear-Host

    Write-Host ''
    Write-Host '==================================================' -ForegroundColor Cyan
    Write-Host ' AIHAT' -ForegroundColor Cyan
    Write-Host ' AI Infrastructure Health Audit Toolkit' -ForegroundColor DarkCyan
    Write-Host " Version $($Result.Version)" -ForegroundColor Yellow
    Write-Host '==================================================' -ForegroundColor Cyan
    Write-Host ''

    Write-Host 'SYSTEM HEALTH' -ForegroundColor Cyan
    Write-Host '--------------------------------------------------'

    Write-Host 'Computer Name  : ' -NoNewline
    Write-Host $Result.SystemHealth.ComputerName -ForegroundColor Green

    Write-Host 'Operating System: ' -NoNewline
    Write-Host $Result.SystemHealth.OperatingSystem -ForegroundColor Green

    Write-Host 'Uptime         : ' -NoNewline
    Write-Host "$($Result.SystemHealth.UptimeDays) days"

    Write-Host 'Memory Usage   : ' -NoNewline
    Write-Host "$($Result.SystemHealth.MemoryUsagePct)%" -ForegroundColor Yellow

    Write-Host 'Disk Free      : ' -NoNewline
    Write-Host "$($Result.SystemHealth.DiskFreePct)%" -ForegroundColor Green

    Write-Host ''
    Write-Host 'WINDOWS UPDATE HEALTH' -ForegroundColor Cyan
    Write-Host '--------------------------------------------------'

    Write-Host 'Service Status : ' -NoNewline
    Write-Host $Result.WindowsUpdateHealth.WindowsUpdateService

    Write-Host 'Start Type     : ' -NoNewline
    Write-Host $Result.WindowsUpdateHealth.ServiceStartType

    Write-Host 'Pending Reboot : ' -NoNewline

    if ($Result.WindowsUpdateHealth.PendingReboot) {
        Write-Host 'Yes' -ForegroundColor Yellow
    }
    else {
        Write-Host 'No' -ForegroundColor Green
    }

    Write-Host 'Last Update    : ' -NoNewline
    Write-Host $Result.WindowsUpdateHealth.LastInstalledUpdate

    Write-Host 'Installed Date : ' -NoNewline
    Write-Host $Result.WindowsUpdateHealth.LastInstalledDate

    Write-Host ''
    Write-Host 'EXECUTION' -ForegroundColor Cyan
    Write-Host '--------------------------------------------------'

    Write-Host 'Duration       : ' -NoNewline
    Write-Host "$($Result.DurationSec) seconds" -ForegroundColor Green

    Write-Host 'Log File       : ' -NoNewline
    Write-Host $Result.LogFilePath -ForegroundColor DarkGray

    Write-Host '==================================================' -ForegroundColor Cyan
    Write-Host ''
}
