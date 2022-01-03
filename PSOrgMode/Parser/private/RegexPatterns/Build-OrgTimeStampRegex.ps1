
<#
.SYNOPSIS
    Return an `OrgMode.Type.Regex.TimeStamp` object with regex patterns as named
    NoteProperties.
#>
Function Build-OrgTimeStampRegex {
    [CmdletBinding()]
    param()
    begin {}
    process {
        $ts = [PSCustomObject]@{
            PSTypeName = 'OrgMode.Type.Regex.TimeStamp'
            start      = '[<|\[]'  # an opening tag of a timestamp
            end        = '[>|\]]'    # a closing tag of a timestamp
            year       = '\d{4}'
            month      = '\d{2}'
            day        = '\d{2}'
            wday       = '\w{3}'
            time       = '\d{1,2}:\d{2}'
            repeat     = '[.+]{1,2}\d+[ymwdh]'
            warn       = '[-]{1,2}\d+[ymwdh]'
        }
        # Join blocks together to create components
        $ts | Add-Member 'date' -MemberType NoteProperty -Value (
        ($ts.year, '-', $ts.month, '-', $ts.day, '\s+', $ts.wday) -join ''
        )

        $ts | Add-Member 'internalspan' -MemberType NoteProperty -Value (
        ('(', $ts.time, ')?(-', $ts.time, ')?') -join ''
        )

        $ts | Add-Member 'stamp' -MemberType NoteProperty -Value (
          ($ts.date,
            '\s*', $ts.internalspan,
            '\s*(', $ts.repeat, ')?',
            '\s*(', $ts.warn, ')?'
        ) -join ''
        )

        # Join components together to create the patterns for orgmode timestamps
        $ts | Add-Member 'timestamp' -MemberType NoteProperty -Value (
            [PSCustomObject]@{
                pattern    = ($ts.start, $ts.stamp, $ts.end) -join ''
                components = (
                    '(?<start>', $ts.start, ')',
                    '\s*(?<date>', $ts.date, ')',
                    '\s*(?<Stime>', $ts.time, ')?',
                    '\s*-?(?<Etime>', $ts.time, ')?',
                    '\s*(?<repeat>', $ts.repeat, ')?',
                    '\s*(?<warn>', $ts.warn, ')?',
                    '\s*(?<end>', $ts.end, ')'
                ) -join ''
            }
        )

        $ts | Add-Member 'timespan' -MemberType NoteProperty -Value (
            [PSCustomObject]@{
                pattern    = ($ts.timestamp.pattern, '--', $ts.timestamp.pattern) -join ''
                components = (
                    '(?<span_start>', $ts.timestamp.pattern, ')',
                    '--',
                    '(?<span_end>', $ts.timestamp.pattern, ')'
                ) -join ''
            }
        )
    }
    end {
        $ts
    }
}
