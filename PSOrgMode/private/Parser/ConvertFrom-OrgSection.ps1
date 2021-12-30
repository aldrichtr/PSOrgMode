
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
        $element = New-OrgElement -Type Section
        $line = 0
    }
    process {
        $current_line_content = $PSItem
        $line++

        Write-Debug "Adding $line - $current_line_content to content"
        $element.Content += $current_line_content
        switch -Regex -CaseSensitive ($current_line_content) {
            '^\s*#\+(?<kword>\w+):\s+(?<val>.*)$' {
                $element | Add-OrgProperty -Name $Matches.kword -Value $Matches.val
            }
        }
    }
    end {
        $element
    }
}
