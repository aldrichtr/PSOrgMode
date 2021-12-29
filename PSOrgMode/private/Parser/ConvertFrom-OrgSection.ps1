
Function ConvertFrom-OrgSection {
    <#
    .SYNOPSIS
        Convert text in org-mode format into an OrgSection object
    #>
    [CmdletBinding()]
    param(
        # The text to parse into an OrgSection
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [AllowEmptyString()]
        [string[]]
        $Buffer

    )
    begin {
        #region Debug and Verbose output
        # Store logging messages so that output can be formatted better than
        # the default YELLOW YELLING

        # A shortcut to add the debug message continuation line "heading"
        # we want it to look like:
        # <DEBUG or VERBOSE>: in the _loud yellow_
        #  <function name> -----------------------------------------------------
        #  Line | <message>
        #       | <message>
        #       | <message>
        #  <function name> -----------------------------------------------------

        # Function name
        $fn = $PSCmdlet.MyInvocation.MyCommand.Name
        # Debugging indent
        $di = "$(' ' * 6)|"
        # Erase 'DEBUG:'
        $ed = "`e[2K`e[`G"

        # Heading length
        $hl = 78 - ($fn.Length + $di.Length)
        # Debugging Headline
        $dh = ("$ed`e[1;92m$di$fn $('-' * $hl)`e[0m")
        # Debugging Footer
        $df = ("$ed`e[1;92m$di$('-' * $hl) $fn`e[0m")
        # Debugging continuation line
        $dl = "$ed`e[92m$di      |`e[0m"
        Write-Debug $dh
        #endregion Debug and Verbose output

        $element = New-OrgElement -Type section
        $line_number = 1
    }
    process {
        $current_line = $PSItem

        Write-Debug "$ed`e[92m$di Line | `e[0m'$current_line'"
        Write-Debug ("$ed`e[92m$di {0,4} |" -f $line_number)


        $element.Content += $current_line
        switch -Regex -CaseSensitive ($current_line) {
            '^\s*#\+(?<kword>\w+):\s+(?<val>.*)$' {
                Write-Debug "$dl KEYWORD found"
                "$dl  > Adding property {0} - {1}" -f $Matches.kword,
                $Matches.val | Write-Debug
                $element | Add-OrgProperty -Name $Matches.kword -Value $Matches.val
            }
        }
    }
    end {
        Write-Debug $df
        $element
    }
}
