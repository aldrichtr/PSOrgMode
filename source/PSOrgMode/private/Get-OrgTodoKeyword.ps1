
function Get-OrgTodoKeyword {
    <#
    .SYNOPSIS
        Return the list of Keywords from the configuration
    #>
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        $config = Import-Configuration
        | Select-Object -ExpandProperty Todo
    }
    process {
      if ($null -ne $config) {
        $config.Keywords
      } else {
        @('TODO', 'DONE')
      }
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
