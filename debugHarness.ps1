Import-Module ".\PSOrgMode\PSOrgMode.psm1" -Force

Write-Information "Debug Harness loaded"

Get-Content "~\org\pim-inbox.org" | ConvertFrom-OrgElement -Verbose
