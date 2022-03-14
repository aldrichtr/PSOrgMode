[CmdletBinding()]
param(
    # BuildRoot is automatically set by Invoke-Build, but it could
    # be modified here so that hierarchical builds can be done
    [Parameter()]
    [string]
    $BuildRoot = $BuildRoot,

    # This is the module name used in many directory, file and script
    # functions
    [Parameter()]
    [string]
    $ModuleName = 'PSOrgMode',

    # Tags to filter the Pester Tests
    [Parameter(
    )]
    [string]$TestTags
)


. ./build/BuildTool.ps1

task Test {
    $pConfig = New-PesterConfiguration
    $pConfig.Run.Path = "$BuildRoot\tests"
    $pConfig.Run.SkipRemainingOnFailure = 'Container'
    $pConfig.Filter.ExcludeTag = @('analyze')
    $pConfig.Output.Verbosity = 'Detailed'
    if ($null -ne $TestTags) {
        $pConfig.Filter.Tag = @($TestTags)
    }
    Invoke-Pester -Configuration $pConfig
}

task stage_orgmode_module {
    foreach ($line in (Get-Content "$BuildRoot\source\LoadOrder.txt")) {
        Write-Build Red "this line is $line"
        switch -Regex ($line) {
            '^\s*$' {
                # blank line, skip
                continue
            }
            '^\s*#.*$' {
                # Comment line, skip
                continue
            }
            '^(?<module>\w+)\\.*\.ps1$' {
                $file = "$BuildRoot\source\$line"
                Get-Content $file | Add-Content -Path "$BuildRoot\stage\PSOrgMode\$($Matches.module).psm1"
            }
            Default {
                # nothing to do
            }
        }
    }
}
