<#
.SYNOPSIS
    Convert a TIMESTAMP string into a datetime object
.DESCRIPTION
    An orgmode timestamp does more than just identify a datetime.  It can
    be:
    - Active or Inactive
    - A date
    - A date and time
    - A date with a time range
    - A date range
    - A date and time range
    - A date/time with a repeat interval
    - A date/time with a delay period (before a SCHEDULED: item shows in agenda)
    - A date/time with a warning period (when a DEADLINE: shows in agenda)

    To store those items, there are six basic formats for an orgmode timestamp:
    <DATE TIME REPEAT-OR-DELAY>                              : Active timestamp
    [DATE TIME REPEAT-OR-DELAY]                              : Inactive timestamp
    <DATE TIME-TIME REPEAT-OR-DELAY>                         : Active timespan
    [DATE TIME-TIME REPEAT-OR-DELAY]                         : Inactive timespan
    <DATE TIME REPEAT-OR-DELAY>--<DATE TIME REPEAT-OR-DELAY> : Active timespan
    [DATE TIME REPEAT-OR-DELAY]--[DATE TIME REPEAT-OR-DELAY] : Inactive timespan

    `ConvertFrom-OrgTimeStamp` can read all of these formats, and returns a
    timestamp object with:
    - Active = ($true or $false)
    - Start  = [datetime]
    - End    = [datetime]
    - Repeat = [string]

.EXAMPLE
    PS C:\> $d = "<2021-09-01 Wed>" | ConvertFrom-OrgTimeStamp
    $d.Start
    Wednesday, September 1, 2021 00:00:00

.LINK
    https://orgmode.org/worg/dev/org-syntax.html#Timestamp

.LINK
    https://orgmode.org/manual/Dates-and-Times.html#Dates-and-Times
#>
Function ConvertFrom-OrgTimeStamp {
    [CmdletBinding()]
    param(
        # The timestamp String
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
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

        $regex = Get-OrgModeRegexPattern -Type 'timestamp'
        $line_number = 1


        function convertStamp([string]$t) {
            $null = $t -match $regex.timestamp.components
            if ($Matches.Count -gt 0) {
                if (($Matches.start -eq '<') -and
                ($Matches.end -eq '>')) {
                    $active = $true
                }
                if (($Matches.start -eq '[') -and
                ($Matches.end -eq ']')) {
                    $active = $false
                }

                $t_date = $Matches.date
                if ($Matches.Stime) { $stime = $Matches.Stime }
                else { $stime = "00:00" }
                if ($Matches.Etime) { $etime = $Matches.Etime }
                else { $etime = $stime }
                $t_start = Get-Date "$t_date $stime"
                $t_end = Get-Date "$t_date $etime"
                $t_repeat = $Matches.repeat
                $t_warn = $Matches.warn
                # Make an object and return it
                $ts = [OrgTimeStamp]::new()
                    $ts.Active = $active
                    $ts.Start  = $t_start
                    if ($t_end) {$ts.End = $t_end}
                    if ($t_repeat) {$ts.Repeat = [OrgRepeater]::new($t_repeat)}
                    if ($t_warn) {$ts.Warning = [OrgWarning]::new($t_warn)}
            } else {
                Write-Error "convertStamp Could not parse $t"
            }
            $ts
        }
        function convertSpan([string]$t) {
            # Since a timespan is two stamps, here we just split
            # them, convert them to an object and then merge the
            # results into a single, new object and return it.

            $null = $t -match $regex.timespan.components
            if ($Matches.Count -gt 0) {
                $s = convertStamp($Matches.span_start)
                $e = convertStamp($Matches.span_end)

                # If the repeat/warn is in the left and not the right,
                # or the right not the left, no problem, but...
                # *could be a bug here*, I'm not sure if
                # org-mode handles two repeat/warn cookies,
                # but I'm going to say the right one
                # wins.
                if ($s.Repeat.Type -ne [OrgRepeatType]::none) {
                    if ($e.Repeat.Type -ne [OrgRepeatType]::none) {
                        $r = $e.Repeat
                    } else {
                        $r = $s.Repeat
                    }
                } else {
                    $r = $e.Repeat
                }
                if ($s.Warning.Type -ne [OrgWarningType]::none) {
                    if ($e.Repeat.Type -ne [OrgWarningType]::none) {
                        $w = $e.Warning
                    } else {
                        $w = $s.Warning
                    }
                } else {
                    $w = $e.Warning
                }
                $ts = [OrgTimeStamp]::new()
                    $ts.Active = $s.Active
                    $ts.Start  = $s.Start
                    $ts.End    = $e.Start
                    $ts.Repeat = $r
                    $ts.Warning = $w
            } else {
                Write-Error "convertSpan Could not parse $t"
            }
            $ts
        }
    }
    process {
        # This section is basically just a wrapper around the real work
        # which happens in the convertStamp and convertSpan inner-functions
        # defined above.
        $current_line = $PSItem

        Write-Debug "$ed`e[92m$di Line | `e[0m'$current_line'"
        Write-Debug ("$ed`e[92m$di {0,4} |" -f $line_number)

        switch -Regex ($current_line) {
            $regex.withAnchors($regex.timestamp.pattern) {
                Write-Debug "$dl Token match: TIMESTAMP"
                $ts = convertStamp($current_line)
                continue
            }
            $regex.withAnchors($regex.timespan.pattern) {
                Write-Debug "$dl Token match: TIMESPAN"
                $ts = convertSpan($current_line)
                continue
            }
            Default {
                Write-Error "$current_line doesn't appear to be a valid TIMESTAMP"
            }
        }

        $line_number++
        Write-Output $ts
    }
    end {
        Write-Debug $df
    }
}
