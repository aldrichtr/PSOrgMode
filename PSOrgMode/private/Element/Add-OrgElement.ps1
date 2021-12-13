
function Add-OrgElement {
 <#
 .SYNOPSIS
     Add a Child Item to an OrgElement
 .DESCRIPTION
     Parsing an orgmode buffer creates an object hierarchy, where each
     Element has a Parent|Child relationship.  An element has 0 or 1
     Parent and 0 or more Children.
    - Sets the `Parent` property of the Elements passed to the `Child`
       parameter
     - Adds all elements passed to the `Child` parameter to the Children[]
       property of the element passed to the `Parent` parameter
 .EXAMPLE
     ```powershell
     $root | Add-OrgElement $heading
     ```
     Sets the $heading element as a child of $root
 .EXAMPLE
     ```powershell
     $root | Add-OrgElement $heading -PassThru | Get-OrgHeadline
     ```
     Setting the `PassThru` parameter passes the $root element to
     `Get-OrgHeadline`
 .NOTES
     This function is not exported.
 .LINK
     New-OrgElement
     Get-OrgElement
 #>
    [CmdletBinding()]
    param(
        # The OrgElement to add the other OrgElement to
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [Alias('To')]
        [ValidateNotNullOrEmpty()]
        [OrgElement]
        $Parent,

        # One or more OrgElements to add
        [Parameter(
            Position = 0,
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromRemainingArguments = $true
        )]
        [ValidateNotNullOrEmpty()]
        [OrgElement[]]
        $Child,

        # When set, `Add-OrgElement` will return the Parent element to
        # the pipeline for further processing
        # Nothing is returned by default
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $false
        )]
        [switch]
        $PassThru
    )
    # make sure we set up bidirectional relationship
    # or fail out
    begin {}
    process {
        Write-Debug "Adding $($Child.count) to $($Parent.type)"
        foreach ($c in $Child) {
            try {
                $Parent.Children.Add($c) | Out-Null
                $c.addParent($Parent)

                Write-Debug "Parent set to : $($c.Parent.Type)"
            } catch {
                Write-Error "Unable to add the $($c.Type) to $($Parent.Type)`n$_"
            }
        }
    }
    end {
        if ($PassThru) { $Parent }
    }
}
