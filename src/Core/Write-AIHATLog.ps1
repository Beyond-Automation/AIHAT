function Write-AIHATLog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('INFO','SUCCESS','WARNING','ERROR')]
        [string]$Level,

        [Parameter(Mandatory)]
        [string]$Message
    )

    $logFolder = Join-Path $PSScriptRoot "..\..\Logs"

    if (-not (Test-Path $logFolder)) {
        New-Item -ItemType Directory -Path $logFolder -Force | Out-Null
    }

    if (-not $script:LogFile) {
        $timestamp = Get-Date -Format 'yyyy-MM-dd_HHmmss'
        $script:LogFile = Join-Path $logFolder "AIHAT_$timestamp.log"
    }

    $time = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $entry = "$time [$Level] $Message"

    Add-Content -Path $script:LogFile -Value $entry

    Write-Host $entry
}