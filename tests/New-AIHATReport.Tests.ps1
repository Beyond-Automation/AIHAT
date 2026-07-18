BeforeAll {
    $projectRoot = Split-Path -Parent $PSScriptRoot
    $scriptPath  = Join-Path $projectRoot 'src\Core\New-AIHATReport.ps1'

    . $scriptPath

    function Get-TestAIHATResult {
        [PSCustomObject]@{
            Version             = '0.9.0'
            ComputerName        = 'TEST-PC01'
            StartedAt           = Get-Date '2026-07-18 09:00:00'
            CompletedAt         = Get-Date '2026-07-18 09:00:05'
            DurationSec         = 5.12
            LogFilePath         = 'C:\AIHAT\Logs\AIHAT_2026-07-18_090000.log'
            ReportFilePath      = $null
            SystemHealth        = [PSCustomObject]@{
                ComputerName      = 'TEST-PC01'
                OperatingSystem   = 'Windows Server 2022 Standard'
                OSVersion         = '10.0.20348'
                LastBootTime      = Get-Date '2026-07-17 08:00:00'
                UptimeDays        = 1.04
                Processor         = 'Intel(R) Xeon(R) CPU'
                LogicalProcessors = 8
                TotalMemoryGB     = 32
                UsedMemoryGB      = 12.5
                MemoryUsagePct    = 39.06
                SystemDrive       = 'C:'
                DiskSizeGB        = 500
                DiskFreeGB        = 220.4
                DiskFreePct       = 44.08
                CollectedAt       = Get-Date '2026-07-18 09:00:01'
                CollectionStatus  = 'Success'
            }
            WindowsUpdateHealth = [PSCustomObject]@{
                WindowsUpdateService = 'Running'
                ServiceStartType     = 'Automatic'
                PendingReboot        = $false
                LastInstalledUpdate  = 'KB5001234'
                LastInstalledDate    = Get-Date '2026-07-10 00:00:00'
                WSUSServer           = 'http://wsus.internal'
                UseWSUS              = $true
                AutoUpdateOption     = 4
                CollectedAt          = Get-Date '2026-07-18 09:00:03'
                CollectionStatus     = 'Success'
            }
        }
    }
}

Describe 'New-AIHATReport' {

    It 'creates the output directory when it does not already exist' {
        $outputDirectory = Join-Path $TestDrive 'Reports-Create'

        Test-Path -Path $outputDirectory | Should -BeFalse

        New-AIHATReport -Result (Get-TestAIHATResult) -OutputDirectory $outputDirectory |
            Out-Null

        Test-Path -Path $outputDirectory | Should -BeTrue
    }

    It 'returns a full path using the exact AIHAT_yyyy-MM-dd_HHmmss.html filename pattern' {
        $outputDirectory = Join-Path $TestDrive 'Reports-Pattern'

        $reportFilePath = New-AIHATReport `
            -Result (Get-TestAIHATResult) `
            -OutputDirectory $outputDirectory

        Split-Path -Path $reportFilePath -Leaf |
            Should -Match '^AIHAT_\d{4}-\d{2}-\d{2}_\d{6}\.html$'

        Test-Path -Path $reportFilePath -PathType Leaf | Should -BeTrue
    }

    It 'includes representative System Health values' {
        $outputDirectory = Join-Path $TestDrive 'Reports-SystemHealth'

        $reportFilePath = New-AIHATReport `
            -Result (Get-TestAIHATResult) `
            -OutputDirectory $outputDirectory

        $content = Get-Content -Path $reportFilePath -Raw

        $content | Should -Match 'TEST-PC01'
        $content | Should -Match 'Windows Server 2022 Standard'
        $content | Should -Match '44\.08'
    }

    It 'includes representative Windows Update Health values' {
        $outputDirectory = Join-Path $TestDrive 'Reports-WindowsUpdate'

        $reportFilePath = New-AIHATReport `
            -Result (Get-TestAIHATResult) `
            -OutputDirectory $outputDirectory

        $content = Get-Content -Path $reportFilePath -Raw

        $content | Should -Match 'KB5001234'
        $content | Should -Match 'Running'
        $content | Should -Match 'http://wsus\.internal'
    }

    It 'renders boolean values as Yes/No instead of raw booleans' {
        $outputDirectory = Join-Path $TestDrive 'Reports-Boolean'

        $reportFilePath = New-AIHATReport `
            -Result (Get-TestAIHATResult) `
            -OutputDirectory $outputDirectory

        $content = Get-Content -Path $reportFilePath -Raw

        $content | Should -Match '<th>Pending Reboot</th><td>No</td>'
        $content | Should -Match '<th>Use WSUS</th><td>Yes</td>'
    }

    It 'HTML-encodes dynamic values that contain unsafe characters' {
        $unsafeResult = Get-TestAIHATResult
        $unsafeResult.SystemHealth.OperatingSystem = "Windows <Server> & 'Test'"

        $outputDirectory = Join-Path $TestDrive 'Reports-Encoding'

        $reportFilePath = New-AIHATReport `
            -Result $unsafeResult `
            -OutputDirectory $outputDirectory

        $content = Get-Content -Path $reportFilePath -Raw

        $content | Should -Not -Match '<Server>'
        $content | Should -Match '&lt;Server&gt;'
        $content | Should -Match '&amp;'
    }

    It 'renders "Not available" for missing or null values' {
        $failedResult = Get-TestAIHATResult
        $failedResult.SystemHealth = [PSCustomObject]@{
            ComputerName     = 'TEST-PC01'
            CollectedAt      = Get-Date
            CollectionStatus = 'Failed'
            ErrorMessage     = 'WMI timeout'
        }

        $outputDirectory = Join-Path $TestDrive 'Reports-NotAvailable'

        $reportFilePath = New-AIHATReport `
            -Result $failedResult `
            -OutputDirectory $outputDirectory

        $content = Get-Content -Path $reportFilePath -Raw

        $content | Should -Match 'Not available'
        $content | Should -Match 'WMI timeout'
    }

    It 'includes version, timestamps, duration, and overall status information' {
        $outputDirectory = Join-Path $TestDrive 'Reports-Meta'

        $reportFilePath = New-AIHATReport `
            -Result (Get-TestAIHATResult) `
            -OutputDirectory $outputDirectory

        $content = Get-Content -Path $reportFilePath -Raw

        $content | Should -Match '0\.9\.0'
        $content | Should -Match '2026-07-18 09:00:00'
        $content | Should -Match '2026-07-18 09:00:05'
        $content | Should -Match '5\.12'
        $content | Should -Match 'Overall Status:'
    }

    It 'includes Beyond Automation branding' {
        $outputDirectory = Join-Path $TestDrive 'Reports-Branding'

        $reportFilePath = New-AIHATReport `
            -Result (Get-TestAIHATResult) `
            -OutputDirectory $outputDirectory

        $content = Get-Content -Path $reportFilePath -Raw

        $content | Should -Match 'Beyond Automation'
    }
}
