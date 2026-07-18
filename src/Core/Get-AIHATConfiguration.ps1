function Get-AIHATConfiguration {
    [CmdletBinding()]
    param()

    $srcRoot = Split-Path -Path $PSScriptRoot -Parent
    $projectRoot = Split-Path -Path $srcRoot -Parent

    [PSCustomObject]@{
        ProjectRoot = $projectRoot
        LogPath     = Join-Path -Path $projectRoot -ChildPath 'Logs'
        ReportPath  = Join-Path -Path $projectRoot -ChildPath 'Reports'
        Version     = '0.4.0'
    }
}