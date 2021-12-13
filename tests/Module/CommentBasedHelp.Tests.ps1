
BeforeDiscovery {
    $ShouldProcessParameters = 'WhatIf', 'Confirm'

    # Generate command list for generating Context / TestCases
    $Module = Get-Module $ModuleName
    $CommandList = @(
        $Module.ExportedFunctions.Keys
        $Module.ExportedCmdlets.Keys
    )

}

Describe "Help Content for <_>" -Tags @('analyze', 'help') -ForEach $CommandList {
    BeforeAll {
        #Renaming the automatic variable set in '-Foreach $CommandList
        $Command = $_
        $Help = Get-Help -Name $Command -Full | Select-Object -Property *
        $Parameters = Get-Help -Name $Command -Parameter * -ErrorAction Ignore |
        Where-Object { $_.Name -and $_.Name -notin $ShouldProcessParameters } |
        ForEach-Object {
            @{
                Name        = $_.name
                Description = $_.Description.Text
            }
        }
        $Ast = @{
            # Ast will be $null if the command is a compiled cmdlet
            Ast        = (Get-Content -Path "function:/$Command" -ErrorAction Ignore).Ast
            Parameters = $Parameters
        }
        $Examples = $Help.Help.Examples.Example | ForEach-Object { @{ Example = $_ } }
    }

    It "has help content" {
        $Help | Should -Not -BeNullOrEmpty
    }
    It "contains a synopsis for <_>" {
        $Help.Synopsis | Should -Not -BeNullOrEmpty
    }

    It "contains a description for <_>" {
        $Help.Description | Should -Not -BeNullOrEmpty
    }


    # This will be skipped for compiled commands ($Ast.Ast will be $null)
    It "has a help entry for all parameters of <_>" -TestCases $Ast -Skip:(-not ($Parameters -and $Ast.Ast)) {
        @($Parameters).Count | Should -Be $Ast.Body.ParamBlock.Parameters.Count -Because 'the number of parameters in the help should match the number in the function script'
    }

    It "has a description for parameter -<Name>" -TestCases $Parameters -Skip:(-not $Parameters) {
        $Description | Should -Not -BeNullOrEmpty -Because "parameter $Name should have a description"
    }

    It "has at least one usage example for <_>" {
        $Help.Examples.Example.Code.Count | Should -BeGreaterOrEqual 1
    }

    It "lists a description for $Command example: <Title>" -TestCases $Examples {
        $Example.Remarks | Should -Not -BeNullOrEmpty -Because "example $($Example.Title) should have a description!"
    }
}
