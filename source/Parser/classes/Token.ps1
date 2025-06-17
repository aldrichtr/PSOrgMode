
using namespace System.Text

$useBlock = [scriptblock]::Create("using module $PSScriptRoot\Position.ps1")
. $useBlock

class Token {
  [string]$Type
  [Position]$Start
  [Position]$End
  [StringBuilder]$Content

  Token() {
    $this.Type = 'unknown'
    $this.Start = [Position]::new()
    $this.End   = [Position]::new()
  }

  [string] ToString() {
    return $this.Content.ToString()
  }
}
