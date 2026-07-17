function Invoke-AIHAT {
    [CmdletBinding()]
    param()

    $corePath   = Join-Path -Path $PSScriptRoot -ChildPath 'Core'
    $modulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Modules'

    . (Join-Path -Path $corePath -ChildPath 'Get-AIHATConfiguration.ps1')
    . (Join-Path -Path $corePath -ChildPath 'Write-AIHATLog.ps1')
    . (Join-Path -Path $modulePath -ChildPath 'Get-SystemHealth.ps1')
    . (Join-Path -Path $modulePath -ChildPath 'Get-WindowsUpdateHealth.ps1')

    $config    = Get-AIHATConfiguration
    $startedAt = Get-Date

    # Create a new timestamped log for every invocation.
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

    Write-AIHATLog -Level INFO -Message 'Starting Windows Update Health collection'
    $windowsUpdateHealth = Get-WindowsUpdateHealth

    if ($windowsUpdateHealth.CollectionStatus -eq 'Success') {
        Write-AIHATLog -Level SUCCESS -Message 'Windows Update Health collection completed'
    }
    else {
        Write-AIHATLog `
            -Level ERROR `
            -Message "Windows Update Health collection failed: $($windowsUpdateHealth.ErrorMessage)"
    }

    $completedAt = Get-Date

    Write-AIHATLog -Level INFO -Message 'AIHAT completed'

    [PSCustomObject]@{
        Version             = $config.Version
        ComputerName        = $systemHealth.ComputerName
        StartedAt           = $startedAt
        CompletedAt         = $completedAt
        DurationSec         = [math]::Round(
            ($completedAt - $startedAt).TotalSeconds,
            2
        )
        LogFilePath         = [System.IO.Path]::GetFullPath($script:LogFile)
        SystemHealth        = $systemHealth
        WindowsUpdateHealth = $windowsUpdateHealth
    }
}
