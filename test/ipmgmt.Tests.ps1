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
        @{type = "GTWSUBNET"; size = 30},
        @{type = "DMZSUBNET"; size = 62},
        @{type = "EDGSUBNET"; size = 30},
        @{type = "APPSUBNET"; size = 62},
        @{type = "CRESUBNET"; size = 62}

        Get-VLSMBreakdown -Network 10.10.5.0/24 -SubnetSize $subnets
    }
}

