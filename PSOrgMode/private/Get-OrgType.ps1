
<#
.SYNOPSIS
    Return the OrgType of an item.
#>
Function Get-OrgType {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        # The OrgMode component to get the type of
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true,
            ParameterSetName = 'Object'
        )]
        [OrgElement]
        $Element,

        # The name of the type to get
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true,
            ParameterSetName = 'Type'
        )]
        [OrgType]
        $Type,

        # The base type of the given type
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $false
        )]
        [switch]
        $Base
    )
    begin {
        function getBase([int]$o) {
           :basetypes foreach( $v in ([OrgBaseType].GetEnumValues() | Sort-Object -Descending)) {
                if ($o -gt $v) {
                    $o = $v
                    break basetypes
                }
            }
            $o
        }
    }
    process {
        if ($PSBoundParameters['Element']) {
            # easy, just return the type stored in Element
            $t = $Element.Type
        } elseif ($PSBoundParameters['Type']) {
            # Also easy, you already gave me the type.  Mostly here to
            # be able to add the '-Base' switch
            $t = $Type
        } else {
            # A little more involved.  You dont want a specific type,
            # so we need to make a list of all of them.  Adding a little
            # sugar by including the base type.
            $t = @()
            [OrgType].GetEnumNames() | ForEach-Object {
                $base_type = getBase([OrgType]::$_)
                $orgtype = [PSCustomObject]@{
                    Name = $_
                    Value = ("{0:x}" -f [int]([OrgType]::$_))
                    Group = [OrgBaseType].GetEnumName($base_type)
                }
                $t += $orgtype
            }
        }

        if ($Base) {
            [OrgBaseType]$t = getBase($t)
        }
    }
    end {
            $t
        }
    }
