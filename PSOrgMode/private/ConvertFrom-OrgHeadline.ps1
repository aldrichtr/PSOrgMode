
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
        [string]
        $InputObject
    )
    begin {
        Write-Debug "In $($PSCmdlet.MyInvocation.MyCommand.Name)`n$('-' * 78)"
        $regex = Get-OrgModeRegexPattern -Type 'headline'
        Write-Debug "state is $($regex.state)"
        Write-Debug "priority is $($regex.priority)"
        Write-Debug "track is $($regex.track)"
        Write-Debug "tags is $($regex.tags)"
    }
    process {
        $components = [System.Collections.ArrayList]($InputObject.Split(' '))
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
        $h.Content = $InputObject
        $h.Level = $level
        $h.State = $state
        $h.Priority = $priority
        $h.Title = $title
        $h.Tracking = $track
        foreach ($tag in ($tags -split ':')) {
            if ($tag -ne '') { $h.Tags += $tag }
        }
        Write-Debug "'$InputObject' headline components:"
        Write-Debug (("  Level: '{0}'",
         "State: '{1}'",
         "Priority: '{2}'",
         "Title: '{3}'",
         "Tracking: '{4}'",
         "Tags: '{5}'") -f $h.Level, $h.State, $h.Priority, $h.Title,
         $h.Tracking,($h.Tags -join ','))
    }
    end {
        $h
        Write-Debug "End $($PSCmdlet.MyInvocation.MyCommand.Name)`n$('-' * 78)"
    }
}
