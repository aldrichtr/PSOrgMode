
class OrgHeadline : OrgElement {
    [int]$Level
    [string]$State
    [string]$Priority
    [string]$Title
    [string]$Tracking
    [OrgTimeStamp]$Timestamp
    [OrgTimeStamp]$Scheduled
    [OrgTimeStamp]$Deadline
    [OrgTimeStamp]$Closed
    [bool]$Commented
    [bool]$Archived
    [bool]$Quoted
    [string[]]$Tags

    [string]ToString() {
        $h = ('*' * $this.Level)
        if ($this.State      -ne '') { $h += " $($this.State)" }
        if ($this.Priority   -ne '') { $h += " $($this.Priority)" }
        if ($this.Title      -ne '') { $h += " $($this.Title)" }
        if ($this.Tracking   -ne '') { $h += " $($this.Tracking)" }
        if ($this.Tags.Count -gt 0) {
            $t = ':'
            $this.Tags | ForEach-Object {
                $t += $_
                $t += ':'
            }
            $h += " $t"
        }
        return $h
    }

    OrgHeadline() : base() {
        $this.Type      = [OrgType]::headline
        $this.Content   = ''
        $this.Title     = ""
        $this.Level     = 0
        $this.Priority  = ''
        $this.State     = ''
        $this.Commented = $false
        $this.Archived  = $false
        $this.Quoted    = $false
        $this.Tags      = @()
    }
}
