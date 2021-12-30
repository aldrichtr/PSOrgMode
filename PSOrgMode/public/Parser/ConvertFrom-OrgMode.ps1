
Function ConvertFrom-OrgMode {
    <#
    .SYNOPSIS
        Creates an object from orgmode formatted strings.
    .DESCRIPTION
        Parse given text in org-mode format and return a tree of elements.
    .NOTES
        The `ConvertFrom-OrgMode` function is basically a wrapper around other, more
        specialized `ConvertFrom-` functions.  The main purpose of this function is
        to pass the text to the other functions, and collect
        the results into a single object and return it.
    .INPUTS
        String(s) containing text in orgmode format
    .EXAMPLE
        PS C:\> $o = Get-Content '.\inbox.org' | ConvertFrom-OrgMode
    #>
    [CmdletBinding()]
    param(
        # The input from the pipeline
        [Parameter(
            ValueFromPipeline
        )]
        [AllowEmptyString()]
        [String[]]
        $Buffer,

        <#
        Set the parse mode for handling the input:
        - null : the default, treat the input as a whole orgmode buffer, i.e a file
        - section : parse the input as a section of an orgmode buffer.
        #>
        [Parameter(
        )]
        [AllowNull()]
        [AllowEmptyString()]
        [ValidateSet('none', 'section')]
        [string]
        $Mode = 'none',

        <#
        Set the "recursiveness" of the parser.  There are three options:
        - headline : Build a tree of headlines only.  No document properties,
        sections, planning information, etc.
        - top      : Build a tree of headlines, drawers, lists, etc
        - all      : the default.  Build a tree containing all
        elements and objects in the input
        #>
        [Parameter(
        )]
        [ValidateSet('all', 'headline', 'top')]
        [String]
        $Granularity = 'all'
    )
    begin {
        [Flags()] enum ParseState {
            UNKNOWN = 0
            HEADLINE = 1
            PROPERTY = 2
            DRAWER = 4
            LIST = 8
            BLOCK = 16
        }

        # A hashtable of regular expressions used to match
        # orgmode tokens
        $regex = @{
            'headline'  = '^\*+ .*$'
            'blank'     = '^\s*$'
            'planning'  = ('^\s*(?<type>SCHEDULED|DEADLINE|CLOSED):',
                '\s+(?<stamp>[<\[].*[>\]])\s*$') -join ''
            'timestamp' = '^\s*[<|\[]\d{4}-\d{2}-\d{2}.*$'
            'property'  = @{
                'setting' = '^\s*:(?<name>.*):\s+(?<value>.*)?$'
                'drawer'  = @{
                    'start' = '^\s*:PROPERTIES:.*$'
                    'end'   = '^\s*:END:.*$'
                }
            }
            'keyword'   = '^\s*\#\+(\w+):\s+(.*)$'
            'block'     = @{
                'start' = '^\s*\#\+BEGIN_(?<type>\w+)\s*?(.*)?\s*$'
                'end'   = '^\s*\#\+END_(?<type>\w+)\s*?(.*)?\s*$'
            }
        }

        # Relative line number of the Buffer, starting at 1
        $line_number = 1

        # Unless the current text is an element or marker, store it
        # as content of the element being created
        [string[]]$content = @()

        # Keywords come before the element that can use them, like a table
        # heading, or a caption.
        $affiliated_keywords = @(
            "CAPTION",
            "DATA",
            "HEADER",
            "HEADERS",
            "LABEL",
            "NAME",
            "PLOT",
            "RESNAME",
            "RESULT",
            "RESULTS",
            "SOURCE",
            "SRCNAME",
            "TBLNAME"
        )

        # Store them here until the element goes looking for them
        [OrgProperty[]]$keywords = @()

        # Initially, we don't know the state of the Buffer
        # Once we encounter a headline, we set the HEADLINE flag
        [ParseState]$parse_state = [ParseState]::UNKNOWN

        switch ($Mode) {
            'none' {
                $root = New-OrgElement -Type orgdata
                $root.Begin = $line_number
                continue
            }
            'section' { continue }
        }
    }

    process {
        $current_line = $PSItem

        "{0,-5}: '{1}'" -f $line_number, $current_line | Write-Debug
        switch -Regex -CaseSensitive ($current_line) {
            $regex.headline {
                "{0,-5} Matches HEADLINE" -f $line_number | Write-Verbose
                if (-not($parse_state.hasFlag([ParseState]::HEADLINE))) {
                    ("     First headline, first {0} lines",
                    " are in 'first section'") -f $line_number | Write-Debug
                    <#----------------------------------------------------------
                     This is the first headline we have seen, so unless we are
                     in some other mode, the content up to here must have been
                     the special 'firstsection'.  The only section that doesn't
                     belong to a headline.
                    ----------------------------------------------------------#>
                    $s = $content | ConvertFrom-OrgSection
                    $root | Add-OrgElement $s

                    # reset content
                    $content = @()
                    $parse_state += [ParseState]::HEADLINE
                }

                $h = $current_line | ConvertFrom-OrgHeadline

                if ($h.Level -eq 1) {
                    <#----------------------------------------------------------
                     Current Level == 1: Add it to the document root
                    ----------------------------------------------------------#>
                    "     level 1 heading, adding it to the document root" |
                    Write-Debug
                    # reset, start back at the root
                    $root | Add-OrgElement $h

                } elseif ( $h.Level -eq $previous_headline.Level) {
                    <#----------------------------------------------------------
                     Current Level == Previous Level: Same as previous headline,
                     add it to the parent headline as the "next" child
                    ----------------------------------------------------------#>
                    (("     level {0} heading, same as previous",
                        " {1} heading adding to parent") -join '') -f $h.Level,
                    $previous_headline.Level | Write-Debug

                    $previous_headline.Parent | Add-OrgElement $h

                } elseif ($h.Level -eq ($previous_headline.Level + 1)) {
                    <#----------------------------------------------------------
                     Current Level == Previous Level++: A child headline of the
                     previous headline, add it as a child of previous headline
                    ----------------------------------------------------------#>
                    (("     level {0} heading, adding it to the previous",
                        " {1} heading") -join '') -f $h.Level,
                    $previous_headline.Level | Write-Debug

                    $previous_headline | Add-OrgElement $h
                } elseif (($h.Level -lt $previous_headline.Level) -and
                ($h.Level -gt 1)) {
                    $levels_back = $previous_headline.Level - $h.Level
                    (("     level {0} heading, previous was {1}, walking back ",
                        " {2} levels") -join '') -f $h.Level,
                    $previous_headline.Level, $levels_back | Write-Debug

                    $new_parent = $previous_headline
                    for ($i = 0; $i -le $levels_back; $i++) {
                        $new_parent = $new_parent.Parent
                    }
                    "       adding to {0}" -f $new_parent.Title | Write-Debug
                    $new_parent | Add-OrgElement $h
                } else {
                    ("$line_number : Malformed org-mode heading.`n",
                    "'$($h.Content)'`nis Level $($h.Level) but previous heading is",
                    " Level $($previous_headline.Level)") -join '' | Write-Error
                }
                $previous_headline = $h
                continue
            }
            $regex.planning {
                "{0,-5} Matches PLANNING" -f $line_number | Write-Verbose
                $ts = $Matches.stamp | ConvertFrom-OrgTimeStamp
                switch ($Matches.type) {
                    SCHEDULED { $previous_headline.Scheduled = $ts; continue }
                    DEADLINE { $previous_headline.Deadline = $ts; continue }
                    CLOSED { $previous_headline.Closed = $ts; continue }
                }
                continue
            }
            $regex.timestamp {
                "{0,-5} Matches Timestamp" -f $line_number | Write-Verbose
                $previous_headline.Timestamp = $current_line |
                ConvertFrom-OrgTimeStamp
                continue
            }
            $regex.property.drawer.start {
                "{0,-5} Matches start of property drawer" -f $line_number | Write-Verbose
                $parse_state += [ParseState]::PROPERTY
                continue
            }
            $regex.property.setting {
                "{0,-5} Matches property" -f $line_number | Write-Verbose
                if ($parse_state.hasFlag([ParseState]::PROPERTY)) {
                    "{0,-5} Adding property {1} - {2}" -f $line_number,
                    $Matches.name, $Matches.value | Write-Debug
                    $previous_headline | Add-OrgProperty -Name $Matches.name -Value $Matches.value
                }
                continue
            }
            $regex.property.drawer.end {
                "{0,-5} Matches end of property drawer" -f $line_number | Write-Verbose
                $parse_state -= [ParseState]::PROPERTY
                continue
            }
            $regex.keyword {
                if ($parse_state.hasFlag([ParseState]::HEADLINE)) {
                    "{0,-5} Matches keyword" -f $line_number | Write-Verbose
                    # only collect keywords if we aren't in the "first section"
                    # the `ConvertFrom-OrgSection` will pick up any in there and
                    # keep them as properties of the section, so we can bypass
                    # them here
                    if ($affiliated_keywords -contains $Matches.name) {
                        "{0,-5} keyword '{1}' stored for later" -f $line_number,
                        $Matches.name | Write-Debug
                        $options = @{
                            Name = $Matches.name
                            Value = $Matches.value
                        }
                        $keywords += New-OrgProperty @options
                    } else {
                        $content += $current_line
                    }

                }
            }
            default {
                "{0,-5} No match, adding to content" -f $line_number | Write-Verbose
                $content += $current_line
            }
        }

        $line_number++
    }
    end {
        $root
    }
}
