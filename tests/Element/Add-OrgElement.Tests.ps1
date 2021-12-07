
InModuleScope -ModuleName 'PSOrgMode' {
    Describe 'Testing private Element function Add-OrgElement' -Tags @('unit', 'OrgElement', 'Add' ) {
        Context 'Basic functionality' {
            It 'Should load without error' {
                { Get-Help Add-OrgElement -ErrorAction Stop } | Should -Not -Throw
            }
        }
        Context 'When Parent is passed on the pipeline and Child(ren) are Args' {
            BeforeAll {
                $root = New-OrgElement -Type orgdata
                $h = New-OrgElement -Type headline
                $h.level = 1
                $h.title = 'a test heading'
            }
            It 'Should add the arguments to the pipeline element' {
                $root | Add-OrgElement $h
                $root.Children[0].level | Should -Be 1
                $root.Children[0].title | Should -Be 'a test heading'
            }
        }
    }
}
