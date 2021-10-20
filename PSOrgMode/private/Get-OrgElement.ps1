<#
.SYNOPSIS
    Retrieve OrgElement(s) of the given type
.DESCRIPTION
    `Get-OrgElement` is a "plumbing" function.  Meaning, other "user-facing"
    functions use this one to gather and filter their return values.  For
    example, `Get-OrgHeadline` is really just `Get-OrgElement -Type headline`
.INPUTS
    An OrgElement to act as the "root" to get elements from.
.OUTPUTS
    OrgElement or an Array of OrgElements
#>

Function Get-OrgElement {
    [CmdletBinding()]
    param(
        # The container to retrieve elements from
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [OrgElement]
        $From,

        # The element type, defaults to 'any'
        # This parameter is not needed if using the Filter parameter.
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true
        )]
        [OrgType]
        $Type = [OrgType]::any,

        # Fields and values to filter Elements by
        # Expects a HashTable of 'Field = ValueFilter' to build the return
        # elements list:
        #
        # $e | Get-OrgElement -Filter @{'State' = 'TODO'} -Type "headline"
        # $e | Get-OrgElement -Filter @{'Property' = @{'CATEGORY' = 'Garden'}}
        # $e | Get-OrgElement -Filter @{'Property' = @{'CATEGORY' = 'Garden'; 'Location' = 'Georgia'}}
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true
        )]
        [HashTable]
        $Filter,

        # Recurse into elements.
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $false,
            ParameterSetName = 'Recursion'
        )]
        [switch]
        $Recurse,

        # If recursion is specified, limit the levels to recurse into
        # defaults to 8.
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $false,
            ParameterSetName = 'Recursion'
        )]
        [Int]
        $Depth
    )

    begin {
        # to build an effective filter, we want to add
        # as many criteria as necessary to the .Where() function
        #
        # To do that, we build up individual comparisons in a string
        # and then convert it to a [scriptblock], and use that in the
        # .Where() below
        $criteria = @()
        $criteria_join_type = ' -and '
        $children = @()
    }

    process {
        if ($Recurse) {
            Write-Debug "Recursion was specified"
            # If the Depth wasn't specified, then use 8 to start, but
            # we use this to pass to the next level
            if( -not $PSBoundParameters['Depth']) { $Depth = 8 }
            # Decrement the Depth
            $Depth = $Depth - 1
            Write-Debug "Depth is now $Depth"
            if ($Depth -gt 0) {
                foreach ($child in $From.Children) {
                    $children += Get-OrgElement `
                    -From $child `
                    -Filter $Filter `
                    -Recurse:$Recurse `
                    -Type $Type `
                    -Depth $Depth
                }
            }
        }
        if ($Type -ne [OrgType]::any) {
            $criteria += '($_.Type -eq "' + $Type + '")'
        }

        if ($PSBoundParameters['Filter']) {
            foreach ($f in $Filter.Keys) {
                if ($f -like "propert*") {
                    Write-Debug "Filtering by property"
                    $props = $Filter[$f]
                    Write-Debug "$($props.Keys) keys"
                    foreach ($p in $props.Keys) {
                        $criteria += (
                            '(',
                            '$_ | Test-OrgProperty -Name "', $p, '"',
                            ' -Value "', $props[$p], '"',
                            ')'
                        ) -join ''
                    }
                } else {
                    Write-Debug "Filtering by attribute"
                    $criteria += (
                        '(',
                        '$_.', $f, ' -eq "', $Filter[$f], '"',
                        ')'
                    ) -join ''
                }
            }
        }
        if ($criteria.Length -gt 0) {
            $block_text = $criteria -join $criteria_join_type
            $block_text = "($block_text)"
            Write-Debug "Filtering Children using:`n$block_text"
            $where_script = [scriptblock]::Create($block_text)
            $children += $From.Children.Where($where_script)
        } else {
            # no criteria was given, return them all
            $children += $From.Children
        }
    }
    end {
        $children
    }
}
