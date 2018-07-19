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

Describe 'A simple test for Get-VLSMBreakdown' {
    It 'Passes a simple test for Get-VLSMBreakdown' {
        $subnets =
        @{type = "GTWSUBNET"; size = 30},
        @{type = "DMZSUBNET"; size = 62},
        @{type = "EDGSUBNET"; size = 55},
        @{type = "APPSUBNET"; size = 62},
        @{type = "CRESUBNET"; size = 62}

        Get-VLSMBreakdown -Network 10.10.0.0/16 -SubnetSize $subnets | ft
    }
}

Describe 'A simple test for Get-IPRanges' {
    It 'Passes a simple test for Get-IPRanges' {
        Get-IPRanges -Networks "10.10.5.0/24", "10.10.7.0/24" -CIDR 22 -BaseNet "10.10.0.0/16"
    }
}

