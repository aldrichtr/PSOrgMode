
using namespace System.Management.Automation
class Element {
    [ElementType]$Type
    [ref]$Parent

    Element() {
        $this.Type = [ElementType]::unknown
        $this.Parent = $null
    }

    [Element] GetParent() {
            if ($this.Parent -is [PSReference]) {
                return $this.Parent.Value
            } else {
                return $null
            }
    }

    [void] SetParent([Element]$e) {
        $this.Parent = [ref]$e
    }

    [void] SetParent([ref]$r) {
        if ($r.Value -is [Element]) {
            $this.Parent = $r
        }
    }
}
