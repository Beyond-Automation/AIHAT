function Get-WindowsUpdateHealth {
    [CmdletBinding()]
    param()

    try {
        $wuService = Get-Service -Name 'wuauserv' -ErrorAction Stop

        $rebootPending =
            (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending') -or
            (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired')

        $lastHotfix = Get-HotFix |
            Where-Object InstalledOn |
            Sort-Object InstalledOn -Descending |
            Select-Object -First 1

        $windowsUpdatePolicyPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
        $autoUpdatePolicyPath = Join-Path $windowsUpdatePolicyPath 'AU'

        $windowsUpdatePolicy = Get-ItemProperty `
            -Path $windowsUpdatePolicyPath `
            -ErrorAction SilentlyContinue

        $autoUpdatePolicy = Get-ItemProperty `
            -Path $autoUpdatePolicyPath `
            -ErrorAction SilentlyContinue

        [PSCustomObject]@{
            WindowsUpdateService = $wuService.Status
            ServiceStartType     = $wuService.StartType
            PendingReboot        = $rebootPending
            LastInstalledUpdate  = $lastHotfix.HotFixID
            LastInstalledDate    = $lastHotfix.InstalledOn
            WSUSServer           = $windowsUpdatePolicy.WUServer
            UseWSUS              = $autoUpdatePolicy.UseWUServer -eq 1
            AutoUpdateOption     = $autoUpdatePolicy.AUOptions
            CollectedAt          = Get-Date
            CollectionStatus     = 'Success'
        }
    }
    catch {
        [PSCustomObject]@{
            WindowsUpdateService = $null
            PendingReboot        = $null
            CollectedAt          = Get-Date
            CollectionStatus     = 'Failed'
            ErrorMessage         = $_.Exception.Message
        }
    }
}