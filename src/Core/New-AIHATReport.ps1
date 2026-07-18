function New-AIHATReport {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [psobject]$Result,

        [Parameter(Mandatory)]
        [string]$OutputDirectory
    )

    function ConvertTo-AIHATDisplayValue {
        param(
            $Value
        )

        if ($null -eq $Value) {
            return 'Not available'
        }

        if ($Value -is [string] -and [string]::IsNullOrWhiteSpace($Value)) {
            return 'Not available'
        }

        if ($Value -is [bool]) {
            $text = if ($Value) { 'Yes' } else { 'No' }
            return [System.Net.WebUtility]::HtmlEncode($text)
        }

        if ($Value -is [datetime]) {
            return [System.Net.WebUtility]::HtmlEncode($Value.ToString('yyyy-MM-dd HH:mm:ss'))
        }

        return [System.Net.WebUtility]::HtmlEncode($Value.ToString())
    }

    if (-not (Test-Path -Path $OutputDirectory)) {
        if ($PSCmdlet.ShouldProcess($OutputDirectory, 'Create report output directory')) {
            New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
        }
    }

    $timestamp      = Get-Date -Format 'yyyy-MM-dd_HHmmss'
    $reportFileName = "AIHAT_$timestamp.html"
    $reportFilePath = Join-Path -Path $OutputDirectory -ChildPath $reportFileName

    $systemHealth       = $Result.SystemHealth
    $windowsUpdateHealth = $Result.WindowsUpdateHealth

    $overallStatus = if ($systemHealth.CollectionStatus -eq 'Success' -and $windowsUpdateHealth.CollectionStatus -eq 'Success') {
        'Healthy'
    }
    elseif ($systemHealth.CollectionStatus -eq 'Success' -or $windowsUpdateHealth.CollectionStatus -eq 'Success') {
        'Warning'
    }
    else {
        'Critical'
    }

    $executiveSummary =
        "AIHAT completed a health audit of $(ConvertTo-AIHATDisplayValue $Result.ComputerName) " +
        "in $(ConvertTo-AIHATDisplayValue $Result.DurationSec) seconds. " +
        "System Health collection: $(ConvertTo-AIHATDisplayValue $systemHealth.CollectionStatus). " +
        "Windows Update Health collection: $(ConvertTo-AIHATDisplayValue $windowsUpdateHealth.CollectionStatus)."

    $generatedAt = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')

    $html = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>AIHAT Health Report</title>
<style>
    body { font-family: 'Segoe UI', Arial, sans-serif; background-color: #f4f6f8; color: #1f2933; margin: 0; padding: 0; }
    .container { max-width: 900px; margin: 0 auto; padding: 24px; }
    header { background-color: #0b3d91; color: #ffffff; padding: 24px; border-radius: 6px 6px 0 0; }
    header h1 { margin: 0; font-size: 28px; }
    header p { margin: 4px 0 0; opacity: 0.85; }
    section { background-color: #ffffff; padding: 20px 24px; margin-bottom: 16px; border: 1px solid #e1e4e8; border-radius: 6px; }
    section h2 { margin-top: 0; color: #0b3d91; border-bottom: 2px solid #e1e4e8; padding-bottom: 8px; }
    table { width: 100%; border-collapse: collapse; }
    table th, table td { padding: 8px 12px; text-align: left; border-bottom: 1px solid #e1e4e8; }
    table th { width: 40%; color: #52606d; font-weight: 600; }
    .status-Healthy { color: #1f8a70; font-weight: 600; }
    .status-Warning { color: #b98900; font-weight: 600; }
    .status-Critical { color: #c0392b; font-weight: 600; }
    footer { text-align: center; padding: 16px; color: #7b8794; font-size: 13px; }
</style>
</head>
<body>
<div class="container">
    <header>
        <h1>AIHAT Health Report</h1>
        <p>AI Infrastructure Health Audit Toolkit &mdash; Version $(ConvertTo-AIHATDisplayValue $Result.Version)</p>
        <p>Generated $generatedAt</p>
    </header>

    <section>
        <h2>Executive Summary</h2>
        <p>$executiveSummary</p>
        <p>Overall Status: <span class="status-$overallStatus">$overallStatus</span></p>
    </section>

    <section>
        <h2>System Health</h2>
        <table>
            <tr><th>Computer Name</th><td>$(ConvertTo-AIHATDisplayValue $systemHealth.ComputerName)</td></tr>
            <tr><th>Operating System</th><td>$(ConvertTo-AIHATDisplayValue $systemHealth.OperatingSystem)</td></tr>
            <tr><th>OS Version</th><td>$(ConvertTo-AIHATDisplayValue $systemHealth.OSVersion)</td></tr>
            <tr><th>Uptime (days)</th><td>$(ConvertTo-AIHATDisplayValue $systemHealth.UptimeDays)</td></tr>
            <tr><th>Processor</th><td>$(ConvertTo-AIHATDisplayValue $systemHealth.Processor)</td></tr>
            <tr><th>Logical Processors</th><td>$(ConvertTo-AIHATDisplayValue $systemHealth.LogicalProcessors)</td></tr>
            <tr><th>Total Memory (GB)</th><td>$(ConvertTo-AIHATDisplayValue $systemHealth.TotalMemoryGB)</td></tr>
            <tr><th>Used Memory (GB)</th><td>$(ConvertTo-AIHATDisplayValue $systemHealth.UsedMemoryGB)</td></tr>
            <tr><th>Memory Usage %</th><td>$(ConvertTo-AIHATDisplayValue $systemHealth.MemoryUsagePct)</td></tr>
            <tr><th>System Drive</th><td>$(ConvertTo-AIHATDisplayValue $systemHealth.SystemDrive)</td></tr>
            <tr><th>Disk Size (GB)</th><td>$(ConvertTo-AIHATDisplayValue $systemHealth.DiskSizeGB)</td></tr>
            <tr><th>Disk Free (GB)</th><td>$(ConvertTo-AIHATDisplayValue $systemHealth.DiskFreeGB)</td></tr>
            <tr><th>Disk Free %</th><td>$(ConvertTo-AIHATDisplayValue $systemHealth.DiskFreePct)</td></tr>
            <tr><th>Collection Status</th><td>$(ConvertTo-AIHATDisplayValue $systemHealth.CollectionStatus)</td></tr>
            <tr><th>Error Message</th><td>$(ConvertTo-AIHATDisplayValue $systemHealth.ErrorMessage)</td></tr>
        </table>
    </section>

    <section>
        <h2>Windows Update Health</h2>
        <table>
            <tr><th>Service Status</th><td>$(ConvertTo-AIHATDisplayValue $windowsUpdateHealth.WindowsUpdateService)</td></tr>
            <tr><th>Service Start Type</th><td>$(ConvertTo-AIHATDisplayValue $windowsUpdateHealth.ServiceStartType)</td></tr>
            <tr><th>Pending Reboot</th><td>$(ConvertTo-AIHATDisplayValue $windowsUpdateHealth.PendingReboot)</td></tr>
            <tr><th>Last Installed Update</th><td>$(ConvertTo-AIHATDisplayValue $windowsUpdateHealth.LastInstalledUpdate)</td></tr>
            <tr><th>Last Installed Date</th><td>$(ConvertTo-AIHATDisplayValue $windowsUpdateHealth.LastInstalledDate)</td></tr>
            <tr><th>WSUS Server</th><td>$(ConvertTo-AIHATDisplayValue $windowsUpdateHealth.WSUSServer)</td></tr>
            <tr><th>Use WSUS</th><td>$(ConvertTo-AIHATDisplayValue $windowsUpdateHealth.UseWSUS)</td></tr>
            <tr><th>Auto Update Option</th><td>$(ConvertTo-AIHATDisplayValue $windowsUpdateHealth.AutoUpdateOption)</td></tr>
            <tr><th>Collection Status</th><td>$(ConvertTo-AIHATDisplayValue $windowsUpdateHealth.CollectionStatus)</td></tr>
            <tr><th>Error Message</th><td>$(ConvertTo-AIHATDisplayValue $windowsUpdateHealth.ErrorMessage)</td></tr>
        </table>
    </section>

    <section>
        <h2>Execution Details</h2>
        <table>
            <tr><th>Version</th><td>$(ConvertTo-AIHATDisplayValue $Result.Version)</td></tr>
            <tr><th>Started At</th><td>$(ConvertTo-AIHATDisplayValue $Result.StartedAt)</td></tr>
            <tr><th>Completed At</th><td>$(ConvertTo-AIHATDisplayValue $Result.CompletedAt)</td></tr>
            <tr><th>Duration (sec)</th><td>$(ConvertTo-AIHATDisplayValue $Result.DurationSec)</td></tr>
            <tr><th>Log File</th><td>$(ConvertTo-AIHATDisplayValue $Result.LogFilePath)</td></tr>
        </table>
    </section>

    <footer>
        Beyond Automation &mdash; Engineering Smarter IT Operations.
    </footer>
</div>
</body>
</html>
"@

    Set-Content -Path $reportFilePath -Value $html -Encoding UTF8

    return $reportFilePath
}
