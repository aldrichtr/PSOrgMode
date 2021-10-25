<#
Base class for other, more specific org-mode elements.  At a minimum,
all elements share a:
  - begining point in a 'buffer'
  - ending point in a 'buffer'
  - content: the contents within the element, meaning, without the markup.
    for example, in an OrgTimestamp object like :
    `<2021-09-26 Sun 11:00-1200 +1y>` the
    Content would be '2021-09-26 Sun 11:00-1200 +1y', but the OrgTimestamp
    will also have a [datetime]$Start, [datetime]$End


#>

class OrgElement {
    [OrgType]$Type
    [string]$Begin
    [string]$End
    [string[]]$Content
    [System.Collections.ArrayList]$Properties
    [OrgElement]$Parent
    [System.Collections.ArrayList]$Children

    OrgElement() {
      $this.Type = [OrgType]::unknown
      $this.Properties = [System.Collections.ArrayList]@()
      $this.Children = [System.Collections.ArrayList]@()
    }

    [void]addParent([OrgElement]$e) {
      $this.Parent = $e
    }
  }
