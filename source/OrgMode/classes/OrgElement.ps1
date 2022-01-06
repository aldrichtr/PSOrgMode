<#
Base class for other, more specific org-mode elements.  At a minimum,
all elements share a:
  - begining point in a 'buffer'
  - ending point in a 'buffer'
  - content: the raw contents within the element
  - parent element (the element )
#>

class OrgElement {
    [OrgType]$Type
    [int]$Begin
    [int]$End
    [string[]]$Content
    [System.Collections.ArrayList]$Properties
    [OrgElement]$Parent
    [System.Collections.ArrayList]$Children

    <#------------------------------------------------------------------
      Constructor - default
      Initialize defaults to empty and 0s
    ------------------------------------------------------------------#>
    OrgElement() {
      $this.Type       = [OrgType]::unknown
      $this.Begin      = 0
      $this.End        = 0
      $this.Properties = [System.Collections.ArrayList]@()
      $this.Children   = [System.Collections.ArrayList]@()
    }

    <#------------------------------------------------------------------
      Constructor - line markers

      $h = [OrgElement]::new(2,2)
    ------------------------------------------------------------------#>
    OrgElement( [int]$b , [int]$e ) {
      $this.Type       = [OrgType]::unknown
      $this.Begin      = $b
      $this.End        = $e
      $this.Properties = [System.Collections.ArrayList]@()
      $this.Children   = [System.Collections.ArrayList]@()
    }

    <#------------------------------------------------------------------
      Constructor - line markers and content

      $h = [OrgElement]::new(2,2)
      $h.Type = [OrgType]::headline
    ------------------------------------------------------------------#>
    OrgElement( [int]$b , [int]$e, [string[]]$c ) {
      $this.Type       = [OrgType]::unknown
      $this.Begin      = $b
      $this.End        = $e
      $this.Content    = $c
      $this.Properties = [System.Collections.ArrayList]@()
      $this.Children   = [System.Collections.ArrayList]@()
    }

    <#------------------------------------------------------------------
      Constructor - line markers, content and type

      $e = [OrgElement]::new(1,2, $stringArray, [OrgType]::section)
    ------------------------------------------------------------------#>
    OrgElement( [int]$b , [int]$e, [string[]]$c, [OrgType]$t ) {
      $this.Type       = $t
      $this.Begin      = $b
      $this.End        = $e
      $this.Content    = $c
      $this.Properties = [System.Collections.ArrayList]@()
      $this.Children   = [System.Collections.ArrayList]@()
    }



    [void]addParent([OrgElement]$e) {
      $this.Parent = $e
    }
  }
