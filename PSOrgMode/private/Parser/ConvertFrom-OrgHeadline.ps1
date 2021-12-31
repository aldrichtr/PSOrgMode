
<#
.SYNOPSIS
    Convert text in org-mode format into an object
#>
Function ConvertFrom-OrgHeadline {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [string[]]
        $Buffer,

        # Optionally set the starting position (line number) of the headline
        [Parameter(
        )]
        [int]
        $Begin,

        # Optionally set the ending position (line number) of the headline
        [Parameter(
        )]
        [int]
        $End
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


        $line_number = 1
        $regex = Get-OrgModeRegexPattern -Type 'headline'
    }
    process {
        $current_line = $PSItem

        Write-Debug "$ed`e[92m$di Line | `e[0m'$current_line'"
        Write-Debug ("$ed`e[92m$di {0,4} |" -f $line_number)

        $components = [System.Collections.ArrayList]($current_line.Split(' '))
        # confirm that the first component is only "stars"
        $stars = $components[0].ToCharArray()
        if (($stars -ne '*').Count -eq 0) {
            # extract it from the list
            $components.Remove($stars -join '')
            $level = $stars.Count
        }
        # Todo state is positional, if it matches somewhere else in the
        # headline, its not a Todo state
        if ($components[0] -cmatch $regex.state) {
            $state = $components[0]
            $components.Remove($state)
        }

        switch -Regex ($components) {
            $regex.priority { $priority = $_ }
            $regex.track { $track = $_ }
            $regex.tags { $tags = $_ }
        }
        # everything else is part of the title, so remove
        # the parts we already matched
        if ($priority) { $components.Remove($priority) }
        if ($tags)     { $components.Remove($tags)     }
        if ($track)    { $components.Remove($track)    }
        # and join the components back together
        $title = $components -join ' '

        $h = New-OrgElement -Type headline
        $h.Content = $current_line
        $h.Level = $level
        $h.State = $state
        $h.Priority = $priority
        $h.Title = $title
        $h.Tracking = $track
        foreach ($tag in ($tags -split ':')) {
            if ($tag -ne '') { $h.Tags += $tag }
        }
        if ($PSBoundParameters['Begin']) {
            $h.Begin = $Begin
        }

        if ($PSBoundParameters['End']) {
            $h.End = $End
        }

        ((
         "$dl Level:    '{0}'",
         "$dl State:    '{1}'",
         "$dl Priority: '{2}'",
         "$dl Title:    '{3}'",
         "$dl Tracking: '{4}'",
         "$dl Tags:     '{5}'") -join "`n"
         ) -f $h.Level, $h.State,
            $h.Priority, $h.Title,
            $h.Tracking, ($h.Tags -join ',') | Write-Debug

         $line_number++
         Write-Output $h

    }
    end {
        Write-Debug $df
    }
}
