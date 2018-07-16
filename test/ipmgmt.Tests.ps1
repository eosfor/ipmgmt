$ModuleManifestName = 'ipmgmt.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"
$modulePath = "$PSScriptRoot\.."

Import-Module $modulePath -Verbose


Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath | Should Not BeNullOrEmpty
        $? | Should Be $true
    }
}

Describe 'Simple test' {
    It 'Passes a simple test' {
        $subnets =
        @{type = "gateway"; size = 30},
        @{type = "dmz"; size = 62},
        @{type = "edge"; size = 30},
        @{type = "backend"; size = 62},
        @{type = "core"; size = 62}

        Get-VLSMBreakdown -Network 10.234.11.0/24 -SubnetSize $subnets
    }
}

