
<#
.SYNOPSIS
    Creates an object from orgmode formatted strings.
.DESCRIPTION
    Parse given text in org-mode format and return a tree of elements.
    `ConvertFrom-OrgMode` can handle several types of org-mode formatted text:

    The first is the contents of an org-mode file.  Because one of the many uses
    of an org-mode buffer/file is to create a document, the input is parsed,
    collecting "document specific" information and storing that in addition to
    the contents and structure.

    The second type would be one or more org-mode elements (such as sections,
    headlines, properties, etc.). This would be converted into a tree of 1 or
    more objects and returned.

    Lastly would be a set of instructions or settings to be used by other calls
    to `ConvertFrom-OrgMode`.  For example, perhaps there are some Latex
    fragments or Document properties that need to be set as a "template", and
    subsequent calls to `ConvertFrom-OrgMode` would honor those settings, or add
    them to the object created.
.NOTES
    The `ConvertFrom-OrgMode` function is basically a wrapper around other, more
    specialized `ConvertFrom-` functions.  The main purpose of this function is
    to identify the components, pass the text to the other functions, and collect
    the results into a single object and return it.
.INPUTS
    String(s) containing text, and optional org-mode markup.
.EXAMPLE
    PS C:\> $o = Get-Content '.\inbox.org' | ConvertFrom-OrgMode
#>
Function ConvertFrom-OrgMode {
    [CmdletBinding()]
    param(
        # The input from the pipeline
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true
        )]
        [String[]]
        $InputObject,

        <#
        Set the granularity of the parser.  There are three options:
        - headline : Build a tree of headlines only.  No document properties,
                     sections, planning information, etc.
        - top      : Build a tree of headlines, drawers, lists, etc
        - all      : the default.  Build a tree containing all
                     elements and objects in the input
        #>
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $false
        )]
        [ValidateSet('all', 'headline', 'top')]
        [String]
        $Granularity = 'all'
    )
    begin {
        # most dont need capture groups because another function handles the
        # parsing.

        $regex = Get-OrgModeRegexPattern
        $empty_line = $regex.withAnchors($regex.plaintext.blank_line)

        $property_single = '^\s*\#\+(\w+):\s+(.*)$'
        $property_drawer_start = '^\s*:PROPERTIES:.*$'
        $property_drawer_property = '^\s*:(?<prop_name>.*):\s+(?<prop_value>.*)?$'
        $property_drawer_end = '^\s*:END:.*$'

        $planning = ('^\s*(?<type>SCHEDULED|DEADLINE|CLOSED):',
        '\s+(?<stamp>[<\[].*[>\]])\s*$') -join ''

        $block_start = '^\s*\#\+BEGIN_(?<type>\w+)\s*?(.*)?\s*$'
        $block_end = '^\s*\#\+END_(?<type>\w+)\s*?(.*)?\s*$'

        $bullet_types = '-|+|*'
        $checkbox_types = '-|x|'
        $checkbox_item = (
            '^\s*', $bullet_types,
            ' \[', $checkbox_types, '\]',
            '\s+(.*)$') -join ''


        $line_number = 0
        Write-Debug "In $($PSCmdlet.MyInvocation.MyCommand.Name)`n$('-' * 78)"
        Write-Verbose "Parser Granularity set to: '$Granularity'"
        $root = New-OrgElement -Type orgdata
    }

    process {
        $line_number++
        $logging_indent = (' ' * ($line_number.ToString()).Length)

        Write-Verbose "${line_number}: '$InputObject'"
        switch -Regex -CaseSensitive ($InputObject) {
            $regex.withAnchors($regex.headline.line) {
                Write-Verbose "$logging_indent| matches org headline"
                $h = $InputObject | ConvertFrom-OrgHeadline
                if ($h.Level -eq 1) {
                    Write-Verbose "$logging_indent|  - level 1 heading, adding it to the top"
                    # reset, start back at the root
                    $h | Add-OrgElement -To $root
                }
                elseif ( $h.Level -eq $previous_element.Level) {
                    Write-Verbose "$logging_indent|  - level $($h.Level) heading, same as previous $($previous_element.Level) heading adding to parent"
                    # A child on the same level as the last one
                    $h | Add-OrgElement -To $previous_element.Parent

                }
                elseif ($h.Level -eq ($previous_element.Level + 1)) {
                    Write-Verbose "$logging_indent|  - level $($h.Level) heading, adding it to the previous $($previous_element.Level) heading"
                    # A child of the previous element
                    $h | Add-OrgElement -To $previous_element
                }
                else {
                    Write-Error "$logging_indent| Malformed org-mode heading.`n `
                    '$($h.Content)' is Level ${h.Level} but previous heading is `
                    Level ${previous_element.Level}"
                }
                $previous_element = $h
                $current_headline = $h
                continue
            }
            $property_single {
                Write-Verbose "$logging_indent| matches org-mode node-property"
                continue
            }
            $property_drawer_start {
                Write-Verbose "$logging_indent| matches start of org property block"
                continue
            }
            $property_drawer_end {
                Write-Verbose "$logging_indent| matches end of org property block"
                continue
            }
            $property_drawer_property {
                Write-Verbose "$logging_indent| matches property element"
                continue
            }
            $planning {
                Write-Verbose "$logging_indent| matches org planning information"
                Write-Verbose "$logging_indent|   - type:'$($Matches.type)' time:'$($Matches.stamp)'"
                $ts = $Matches.stamp | ConvertFrom-OrgTimeStamp
                switch ($Matches.type) {
                    SCHEDULED { $current_headline.Scheduled = $ts; continue }
                    DEADLINE  { $current_headline.Deadline  = $ts; continue }
                    CLOSED    { $current_headline.Closed    = $ts; continue }
                }
                continue
            }
            {($_ -cmatch $regex.withAnchors($regex.timestamp.timestamp.pattern)) -or
             ($_ -cmatch $regex.withAnchors($regex.timestamp.timespan.pattern))}    {
                Write-Verbose "$logging_indent| matched Timestamp information"
                $current_headline.Timestamp = $InputObject | ConvertFrom-OrgTimeStamp
                continue
            }
            $block_start {
                Write-Verbose "$logging_indent| matched start of $($Matches.type) block"
                continue
            }
            $block_end {
                Write-Verbose "$logging_indent| matched end of $($Matches.type) block"
                continue
            }
            $table_row {
                Write-Verbose "$logging_indent| matched Table row"
                continue
            }
            $empty_line {
                Write-Verbose "$logging_indent| matched empty line"
                continue
            }
            default {
                Write-Verbose "$logging_indent| matched line of text(default)"
                continue
            }
        }
        Write-Verbose ('-' * ($logging_indent.Length + 2))
    }

    end {
        Write-Verbose "$line_number lines processed"
        $root
        Write-Verbose "End $($PSCmdlet.MyInvocation.MyCommand.Name)`n$('-' * 78)"
    }
}
