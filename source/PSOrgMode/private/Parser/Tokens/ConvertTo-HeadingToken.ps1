
using namespace System.Collections
using namespace OrgMode.Parser

function ConvertTo-HeadingToken {
  <#
    .SYNOPSIS
        Convert a string to an OrgMode.Parser.HeadingToken
    #>
  [CmdletBinding()]
  param(
    # The string to parse into a HeadingToken
    [Parameter(
      ValueFromPipeline
    )]
    [string]$InputObject
  )
  begin {
    Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    $acceptedKeywords = Get-OrgTodoKeyword
    $message = ''
    $token = [HeadingToken]::new()

    ## Regexen for heading components
    $r = @{
      line     = '\*+\s+.*'
      state    = '[A-Z]{4,}' #case sensitive!
      priority = '\[\#\w\]'
      track    = '\[\d+/\d+\]'
      tags     = '\:(\w+\:)+'
    }
  }
  process {

    # --------------------------------------------------------------------------------
    #region Input validation
    if ($InputObject -notmatch $r.line) {
      $message = "$InputObject is not a valid OrgMode Heading"
      $exceptionText = ( @($message, $_.ToString()) -join "`n")
      $thisException = [Exception]::new($exceptionText)
      $eRecord = New-Object System.Management.Automation.ErrorRecord -ArgumentList (
        $thisException,
        $null,  # errorId
        $_.CategoryInfo.Category, # errorCategory
        $null  # targetObject
      )
      $PSCmdlet.ThrowTerminatingError( $eRecord )
    }
    #endregion Input validation
    # --------------------------------------------------------------------------------


    # --------------------------------------------------------------------------------
    #region Level
    $components = [ArrayList]::new(($InputObject -split ' '))
    if ($components.Count -gt 0) {
      $stars = $components[0]
      if ($stars -match '^\*+$') {
        $token.level = $stars.Length
        [void]$components.Remove($stars)
      } else {
        $message = "Orgmode headings must begin with 1 or more '*'"
        $exceptionText = ( @($message, $_.ToString()) -join "`n")
        $thisException = [Exception]::new($exceptionText)
        $eRecord = New-Object System.Management.Automation.ErrorRecord -ArgumentList (
          $thisException,
          $null,  # errorId
          $_.CategoryInfo.Category, # errorCategory
          $null  # targetObject
        )
        $PSCmdlet.ThrowTerminatingError( $eRecord )
      }
      #endregion Level
      # --------------------------------------------------------------------------------


      # --------------------------------------------------------------------------------
      #region keyword
      if ($components[0] -cin $acceptedKeywords) {
        $token.keyword = $components[0]
        [void]$components.RemoveAt(0)
      }
      #endregion keyword
      # --------------------------------------------------------------------------------


      # --------------------------------------------------------------------------------
      #region Remaining elements

      switch -Regex ($components) {
        $r.priority { $priority = $_ }
        $r.track { $track = $_ }
        $r.tags { $tags = $_ }
      }
      # everything else is part of the title, so remove
      # the parts we already matched
      if ($priority) {
        $token.priority = $priority
        [void]$components.Remove($priority)
      }
      if ($track) {
        $token.tracking = $track
        [void]$components.Remove($track)
      }
      if ($tags) {
        foreach ($tag in ($tags -split ':')) {
          if (-not ([string]::IsNullorEmpty($tag))) {
            [void]$token.tags.Add($tag.Trim())
          }
        }
        [void]$components.Remove($tags)
      }

      ## and join the components back together
      $token.title = $components -join ' '

      #endregion Remaining elements
      # --------------------------------------------------------------------------------
      $token
    } else {
      $message = "$InputObject is not a valid OrgMode heading"
      $exceptionText = ( @($message, $_.ToString()) -join "`n")
      $thisException = [Exception]::new($exceptionText)
      $eRecord = New-Object System.Management.Automation.ErrorRecord -ArgumentList (
        $thisException,
        $null,  # errorId
        $_.CategoryInfo.Category, # errorCategory
        $null  # targetObject
      )
      $PSCmdlet.ThrowTerminatingError( $eRecord )
    }
  }
  end {
    Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
  }
}
