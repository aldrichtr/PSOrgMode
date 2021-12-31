
class OrgRepeater {
    [OrgRepeatType]$Type
    [OrgTimeUnit]$Unit
    [int]$Value


    OrgRepeater() {
        $this.Value = $null
        $this.Unit  = [OrgTimeUnit]::none
        $this.Type  = [OrgRepeatType]::none
    }

    OrgRepeater([string]$r) {
        $pattern = '^(?<type>[.+]+)(?<value>\d+)(?<unit>[ymwdh])$'
        $r -match $pattern | Out-Null
        if ($Matches.Count -gt 0) {
            $this.Value = $Matches.value
            switch ($Matches.unit) {
                'y' {$this.Unit = [OrgTimeUnit]::year;  continue}
                'm' {$this.Unit = [OrgTimeUnit]::month; continue}
                'w' {$this.Unit = [OrgTimeUnit]::week;  continue}
                'd' {$this.Unit = [OrgTimeUnit]::day;   continue}
                'h' {$this.Unit = [OrgTimeUnit]::hour;  continue}
            }
            switch ($Matches.type) {
                '+'  {$this.Type = [OrgRepeatType]::cumulate; continue }
                '.+' {$this.Type = [OrgRepeatType]::restart;   continue }
                '++' {$this.Type = [OrgRepeatType]::catchup;   continue }
            }
        }
    }

    [string]ToString() {
        return ("{0} every {1} {2}" -f $this.Type, $this.Value, $this.Unit)
    }
}
