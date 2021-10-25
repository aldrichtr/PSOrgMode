

Describe "Build-OrgModeTimeStampRegex function" {
    Context "When the function is invoked" {
        BeforeAll {
            $t = Build-OrgTimeStampRegex
        }
        It "Returns the proper 'start' regex" {
           $t.start | Should -BeExactly '[<|\[]'
        }
        It "Returns the proper timespan pattern" {
            $t.timespan.pattern | Should -BeExactly '[<|\[]\d{4}-\d{2}-\d{2}\s+\w{3}\s*(\d{1,2}:\d{2})?(-\d{1,2}:\d{2})?\s*([.+]{1,2}\d+[ymwdh])?\s*([-]{1,2}\d+[ymwdh])?[>|\]]--[<|\[]\d{4}-\d{2}-\d{2}\s+\w{3}\s*(\d{1,2}:\d{2})?(-\d{1,2}:\d{2})?\s*([.+]{1,2}\d+[ymwdh])?\s*([-]{1,2}\d+[ymwdh])?[>|\]]'
        }
    }
}
