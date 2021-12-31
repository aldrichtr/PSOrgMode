
class OrgProperty {
    [string]$Name
    [string[]]$Value

    OrgProperty() {
        $this.Name = ''
        $this.Value = @()
    }

    OrgProperty([string]$n) {
        $this.Name = $n
        $this.Value = @()
    }

    OrgProperty([string]$n, [string[]]$v) {
        $this.Name = $n
        $this.Value = $v
    }

}
