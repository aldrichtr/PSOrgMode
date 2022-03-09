
$testOptions = @{
    Name = "Testing public Parser function ConvertFrom-OrgMode"
    Tags = @('integration', 'OrgMode', 'ConvertFrom' )
}
Describe @testOptions {
    Context "Basic functionality" {
        It "Should load without error" {
            { Get-Help ConvertFrom-OrgMode -ErrorAction Stop } | Should -Not -Throw
        }
    }

    Context "When an orgmode formatted file is given as input" {
        BeforeAll {
            $orgBuffer = @"
#+TITLE: A test of all element types the parser knows

This is a section before the first headline
* Level one headline
  <2021-09-27 Mon>
* TODO [#A] Level one todo headline with priority :tag1:
  text in the todo headline

* DONE Level one todo headline that is done :tag4:
  :PROPERTIES:
  :CATEGORY: garden
  :END:

** Level two headline with tags :tag1:tag2:

* Source code block
  #+BEGIN_SRC powershell
    Get-ChildItem -Path "."
  #+END_SRC
* Example block
  #+BEGIN_EXAMPLE
  an Example
  #+END_EXAMPLE

  #+CAPTION: A nice table
  | col 1 | col 2 |
  |-------+-------|
  | A     | B     |

* Planning data headlines
** Scheduled for next year
   SCHEDULED: <2022-10-01 Sat -2d>
** Deadline on january 1
   DEADLINE: <2022-01-01 Sat -10d>
** DONE Closed item
   CLOSED: <2021-10-05 Tue 10:32>
"@
            $o = $orgBuffer -split "`n" | ConvertFrom-OrgMode
        }
        #region Buffer

        it "Should create an OrgElement object" {
            $o.Type | Should -Be orgdata
        }

        It "Should have seven children" {
            $o.Children | Should -HaveCount 7
        }
        #endregion Buffer

        #region First section

        It "Should have a first section" {
            $o.Children[0].Type | Should -Be section
        }

        It "Should have three lines of content" {
            $o.Children[0].Content.Count | Should -Be 3
        }

        It "Should set the start of the first section at line 1" {
            $o.Children[0].Begin | Should -Be 1
        }

        It "Should set the end of the first section at line 3" {
            $o.Children[0].End | Should -Be 3
        }
        It "Should have the Title property Set" {
            $o.Children[0] | Get-OrgProperty -Name 'TITLE' |
            Should -Match "A test of all element types the parser knows"
        }
        #endregion First section

        #region Headlines
        It "Should add a section to the second level 1 headline" {
            $o.Children[2].Children[0].Type | Should -Be section
        }
        #endregion Headlines
    }
}
