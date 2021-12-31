

class OrgTimeStamp {
    [OrgType]$Type
    [bool]$Active
    [datetime]$Start
    [datetime]$End
    [OrgRepeater]$Repeat
    [OrgWarning]$Warning

    OrgTimeStamp() {
        # design decision, new timestamps are active by default.
        $this.Active = $true
        $this.Type = [OrgType]::timestamp
        $this.Repeat = [OrgRepeater]::new()
        $this.Warning = [OrgWarning]::new()
    }

    [void]setRepeat([string]$r) {
        $this.Repeat = [OrgRepeater]::new($r)
    }

    [void]setWarning([string]$w) {
        $this.Warning = [OrgWarning]::new($w)
    }

    [string]ToString() {
        if ($this.Start.Date -eq $this.End.Date) {
            if ($this.Start.TimeOfDay -ne $this.End.TimeOfDay) {
                # day same time different
                $out = ("{0} {1}-{2}" -f $this.Start.ToShortDateString(),
                $this.Start.ToShortTimeString(), $this.End.ToShortTimeString())
            } else {
                # day same time same
                $out = ("{0}" -f $this.Start.ToString())
            }
        } else {
            # day different
            $out = ("{0} - {1}"-f $this.Start.ToString("yyyy-MM-dd HH:mm"),
            $this.End.ToString("yyyy-MM-dd HH:mm"))
        }
        return $out
    }
}
