
BeforeDiscovery {
    . "$($Source.Path)\OrgMode\classes\OrgProperty.ps1"
}
BeforeAll {
    . "$($Source.Path)\OrgMode\classes\OrgProperty.ps1"
}

Describe "Testing OrgMode class OrgProperty" -Tags @('unit', 'OrgProperty') {
    Context "When a new object is created" {
        It "Should not throw an error" {
            { $null = New-Object OrgProperty } | Should -Not -Throw
        }
    }
    Context "When a new object is created without arguments" {
        BeforeAll {
            $p = New-Object OrgProperty
        }

        It "Should have a blank Name" {
            $p.Name | Should -BeNullOrEmpty
        }
        It "Should have a blank Value" {
            $p.Value | Should -BeNullOrEmpty
        }
    }

    Context "When a new object is created with one argument <PropName>" -Foreach @(
        @{
            PropName = 'Gardening'
        }
    ){
        BeforeAll {
            $p = New-Object OrgProperty -ArgumentList $PropName
        }

        It "Should set the Name to <PropName>" {
            $p.Name | Should -Be $PropName
        }
    }
    Context "When a new object is created with two arguments '<PropName>' '<PropValue>'" -Foreach @(
        @{
            PropName = 'CATEGORY'
            PropValue = 'Gardening'
        }
    ){
        BeforeAll {
            $p = New-Object OrgProperty -ArgumentList $PropName, $PropValue
        }

        It "Should set the Name to <PropName>" {
            $p.Name | Should -Be $PropName
        }
        It "Should set the Value to <PropValue>" {
            $p.Value | Should -Be $PropValue
        }
    }

    Context "When a new object is created with an array of values '<PropName>' '<PropValue>'" -Foreach @(
        @{
            PropName = 'Letters'
            PropValue = @('G', 'A')
        }
    ){
        BeforeAll {
            $p = New-Object OrgProperty -ArgumentList $PropName, $PropValue
        }

        It "Should set the Name to <PropName>" {
            $p.Name | Should -Be $PropName
        }
        It "Should set the Value to <PropValue>" {
            $p.Value | Should -Be $PropValue
        }
    }
}
