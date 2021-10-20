

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
}
