
class OrgWarning {
    [OrgWarningType]$Type
    [OrgTimeUnit]$Unit
    [int]$Value

    OrgWarning() {
        $this.Value = $null
        $this.Unit  = [OrgTimeUnit]::none
        $this.Type  = [OrgWarningType]::none
    }

    OrgWarning([string]$w) {
        $pattern = '^(?<type>[-]{1,2})(?<value>\d+)(?<unit>[ymwdh])$'
        $w -match $pattern | Out-Null
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
                '-'   {$this.Type = [OrgWarningType]::all;   continue }
                '--'  {$this.Type = [OrgWarningType]::first; continue }
            }
        }
    }

    [string]ToString() {
        return ("{0} every {1} {2}" -f $this.Type, $this.Value, $this.Unit)
    }
}
