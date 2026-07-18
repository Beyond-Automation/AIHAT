BeforeAll {
    $projectRoot = Split-Path -Parent $PSScriptRoot
    $invokePath  = Join-Path $projectRoot 'src\Invoke-AIHAT.ps1'

    . $invokePath
}

Describe 'AIHAT command loading' {

    It 'Loads Invoke-AIHAT as a function' {
        Get-Command Invoke-AIHAT -CommandType Function |
            Should -Not -BeNullOrEmpty
    }

    It 'Includes the PassThru parameter' {
        $command = Get-Command Invoke-AIHAT

        $command.Parameters.Keys |
            Should -Contain 'PassThru'
    }
}
