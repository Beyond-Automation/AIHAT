function Invoke-AIHAT {
    [CmdletBinding()]
    param()

    $corePath   = Join-Path -Path $PSScriptRoot -ChildPath 'Core'
    $modulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Modules'

    . (Join-Path $corePath 'Get-AIHATConfiguration.ps1')
    . (Join-Path $corePath 'Write-AIHATLog.ps1')
    . (Join-Path $modulePath 'Get-SystemHealth.ps1')

    $config = Get-AIHATConfiguration
    $startedAt = Get-Date

    # Ensure every invocation creates a new timestamped log.
    $script:LogFile = $null

    Write-AIHATLog -Level INFO -Message "AIHAT $($config.Version) started"
    Write-AIHATLog -Level INFO -Message 'Starting System Health collection'

    $systemHealth = Get-SystemHealth

    if ($systemHealth.CollectionStatus -eq 'Success') {
        Write-AIHATLog -Level SUCCESS -Message 'System Health collection completed'
    }
    else {
        Write-AIHATLog `
            -Level ERROR `
            -Message "System Health collection failed: $($systemHealth.ErrorMessage)"
    }

    $completedAt = Get-Date
    Write-AIHATLog -Level INFO -Message 'AIHAT completed'

    [PSCustomObject]@{
        Version      = $config.Version
        ComputerName = $systemHealth.ComputerName
        StartedAt    = $startedAt
        CompletedAt  = $completedAt
        DurationSec  = [math]::Round(
            ($completedAt - $startedAt).TotalSeconds,
            2
        )
        LogFilePath  = [System.IO.Path]::GetFullPath($script:LogFile)
        SystemHealth = $systemHealth
    }
}