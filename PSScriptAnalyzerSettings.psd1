@{

    # Severity=@()

    # ExcludeRules=@()


    IncludeDefaultRules = $true

    # IncludeRules        = @()

    Rules = @{
        PSAvoidUsingCmdletAliases = @{
            Whitelist = @(
                'task'
                )
        }
    }

    CustomRulePath = @(
        "build/rules"
    )

    RecurseCustomRulePath = $true
}
