
$testOptions = @{
    Name = "Testing private Parser function ConvertFrom-OrgSection"
    Tags = @('unit', 'OrgSection', 'ConvertFrom' )
}
Describe @testOptions {
    Context "Basic functionality" {
        It "Should load without error" {
            { Get-Help ConvertFrom-OrgSection -ErrorAction Stop } | Should -Not -Throw
        }
    }

    Context "When text with keywords is given" {
        InModuleScope -ModuleName $ModuleName {
            BeforeAll {
                $expectedTitle = "A short title"
                $expectedTags  = "test"
                $headSection = @(
                    "This is a line of text",
                    "#+TITLE: $expectedTitle",
                    "#+FILETAGS: $expectedTags",
                    "",
                    "More text before the first heading"
                )
                $s = $headSection | ConvertFrom-OrgSection
            }
            It "Should create a 'section' type element" {

                $s.Type | Should -Be section
            }

            It "Should set the content of the section element" {
                $s.Content.Count | Should -Be $headSection.Count
            }

            It "Should store the content unaltered" {
                @($s.Content) | Should -Be $headSection
            }

            It "Should have two properties set" {
                $s.Properties.Count | Should -Be 2
            }
            It "The new section should have the 'TITLE' property set" {

                $s | Get-OrgProperty -Name "TITLE" | Should -Be $expectedTitle
            }
            It "The new section should have the 'FILETAGS' property set" {

                $s | Get-OrgProperty -Name "FILETAGS" | Should -Be $expectedTags
            }
        }
    }
}
