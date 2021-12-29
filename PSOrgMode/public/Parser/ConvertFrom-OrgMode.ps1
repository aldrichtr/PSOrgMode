
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
        $di = ""
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
        $content_start = $line_number = 1


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
        Write-Debug "$ed`e[92m$('-' * 78)"
        Write-Debug "$ed`e[92m Line | `e[0m'$current_line'"
        Write-Debug ("$ed`e[92m {0,4} |" -f $line_number)

        Write-Debug "$dl Parse state: $($parse_state.ToString())"

        switch -Regex -CaseSensitive ($current_line) {
            $regex.headline {
                Write-Debug "$dl Token match: orgmode HEADLINE"
                if ($content.Length -gt 0) {
                    Write-Debug ("$dl There are {0} lines of content" -f $content.Length)
                    $s = $content | ConvertFrom-OrgSection
                    $s.Begin = $content_start
                    $s.End = $line_number - 1
                    if (-not($parse_state.hasFlag([ParseState]::HEADLINE))) {
                        <#------------------------------------------------------
                        This is the first headline we have seen, so unless we
                        are in some other mode, the content up to here must have
                        been the special 'firstsection'.  The only section that
                        doesn't belong to a headline. Add it to root
                        ------------------------------------------------------#>
                        (("$dl First headline, first {0} lines ",
                             "are in 'first section'") -join ''
                        ) -f ($line_number - 1) | Write-Debug
                        $root | Add-OrgElement $s

                        Write-Debug "$dl Adding HEADLINE to parse state"
                        $parse_state += [ParseState]::HEADLINE

                    } else {
                        <#------------------------------------------------------
                        We already had at least one headline, so any content we
                        collected should be part of the headline above this one.
                        ------------------------------------------------------#>
                        Write-Debug ("$dl Section belongs to '{0}'" -f $previous_headline.Title)
                        $previous_headline | Add-OrgElement $s
                    }
                }

                # reset content
                $content = @()
                $content_start = $line_number + 1
                $h = $current_line | ConvertFrom-OrgHeadline

                if ($h.Level -eq 1) {
                    <#----------------------------------------------------------
                     Current Level == 1: Add it to the document root
                    ----------------------------------------------------------#>
                    Write-Debug "$dl level 1 heading, adding it to the document root"
                    # reset, start back at the root
                    $root | Add-OrgElement $h

                } elseif ( $h.Level -eq $previous_headline.Level) {
                    <#----------------------------------------------------------
                     Current Level == Previous Level: Same as previous headline,
                     add it to the parent headline as the "next" child
                    ----------------------------------------------------------#>
                    (("$dl level {0} heading, same as previous " ,
                    "level {1} heading adding to parent") -join ''
                    ) -f $h.Level, $previous_headline.Level | Write-Debug

                    $previous_headline.Parent | Add-OrgElement $h

                } elseif ($h.Level -eq ($previous_headline.Level + 1)) {
                    <#----------------------------------------------------------
                     Current Level == Previous Level++: A child headline of the
                     previous headline, add it as a child of previous headline
                    ----------------------------------------------------------#>
                    (("$dl level {0} heading, adding it to the previous ",
                        "level {1} heading") -join ''
                     ) -f $h.Level, $previous_headline.Level | Write-Debug

                    $previous_headline | Add-OrgElement $h
                } elseif (($h.Level -lt $previous_headline.Level) -and
                ($h.Level -gt 1)) {
                    $levels_back = $previous_headline.Level - $h.Level
                    (("$dl level {0} heading, previous was {1}, ",
                        "walking back {2} levels") -join ''
                     ) -f $h.Level, $previous_headline.Level, $levels_back | Write-Debug

                    $new_parent = $previous_headline
                    for ($i = 0; $i -le $levels_back; $i++) {
                        $new_parent = $new_parent.Parent
                    }
                    Write-Debug ("$dl adding to headline '{0}'" -f $new_parent.Title)
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
                Write-Debug "$dl Token match: orgmode PLANNING"
                $ts = $Matches.stamp | ConvertFrom-OrgTimeStamp
                switch ($Matches.type) {
                    SCHEDULED { $previous_headline.Scheduled = $ts; continue }
                    DEADLINE { $previous_headline.Deadline = $ts; continue }
                    CLOSED { $previous_headline.Closed = $ts; continue }
                }

                $content_start++
                continue
            }
            $regex.timestamp {
                Write-Debug "$dl Token match: orgmode TIMESTAMP"
                $previous_headline.Timestamp = $current_line |
                ConvertFrom-OrgTimeStamp

                $content_start++
                continue
            }
            $regex.property.drawer.start {
                Write-Debug "$dl Token match: orgmode PROPERTY DRAWER START"
                Write-Debug "$dl Adding PROPERTY to parse state"
                $parse_state += [ParseState]::PROPERTY

                $content_start++
                continue
            }
            $regex.property.setting {
                Write-Debug "$dl Token match: orgmode PROPERTY"
                if ($parse_state.hasFlag([ParseState]::PROPERTY)) {
                    "{0,-5} Adding property {1} - {2}" -f $line_number,
                    $Matches.name, $Matches.value | Write-Debug
                    $previous_headline | Add-OrgProperty -Name $Matches.name -Value $Matches.value
                }

                $content_start++
                continue
            }
            $regex.property.drawer.end {
                Write-Debug "$dl Token match: orgmode PROPERTY DRAWER END"
                Write-Debug "$dl Removing PROPERTY from parse state"
                $parse_state -= [ParseState]::PROPERTY

                $content_start++
                continue
            }
            $regex.keyword {
                Write-Debug "$dl Token match: orgmode KEYWORD"
                if ($parse_state.hasFlag([ParseState]::HEADLINE)) {
                    # only collect keywords if we aren't in the "first section"
                    # the `ConvertFrom-OrgSection` will pick up any in there and
                    # keep them as properties of the section, so we can bypass
                    # them here
                    if ($affiliated_keywords -contains $Matches.name) {
                        Write-Debug ("$dl '{0}' is AFFILIATED, stored for later" -f $Matches.name)
                        $options = @{
                            Name  = $Matches.name
                            Value = $Matches.value
                        }
                        $keywords += New-OrgProperty @options
                    }
                } else {
                    $content += $current_line
                }
                continue
            }
            default {
                Write-Debug "$dl No match, adding to CONTENT"
                $content += $current_line
            }
        }

        $line_number++
    }
    end {
        Write-Debug $df
        $root
    }
}
