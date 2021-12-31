

Describe "Testing private Parser function ConvertFrom-OrgHeadline" -Tags @('unit', 'OrgHeadline', 'ConvertFrom' ) {
    Context "Basic functionality" {
        It "Should load without error" {
            {Get-Help ConvertFrom-OrgHeadline -ErrorAction Stop} | Should -Not -Throw
        }
    }
    Context "When '<Line>' is given" -Foreach @(
        @{
            Line     = '* This is a simple headline'
            Level    = 1
            State    = ''
            Priority = ''
            Title    = 'This is a simple headline'
            Tracking = ''
            Tags     = @()
        }
        @{
            Line     = '** TODO [#A] This is a full headline [0/1]  :tag1:tag2:'
            Level    = 2
            State    = 'TODO'
            Priority = '[#A]'
            Title    = 'This is a full headline '
            Tracking = '[0/1]'
            Tags     = @('tag1', 'tag2')
        }
    ) {
        BeforeAll {
            $h = $Line | ConvertFrom-OrgHeadline
        }
        It "Sets the Level to '<Level>' using '<Line>'" {
            $h.Level | Should -Be $Level
        }
        It "Sets the State to '<State>' using '<Line>" {
            $h.State | Should -Be $State
        }
        It "Sets the Priority to '<Priority>' using '<Line>" {
            $h.Priority | Should -Be $Priority
        }
        It "Sets the Title to '<Title>' using '<Line>" {
            $h.Title | Should -Be $Title
        }
        It "Sets the Tracking to '<Tracking>' using '<Line>" {
            $h.Tracking | Should -Be $Tracking
        }
        It "Sets the Tag to '<Tags>' using '<Line>" {
            $h.Tags.Count | Should -Be $Tags.Count
        }
    }
}
