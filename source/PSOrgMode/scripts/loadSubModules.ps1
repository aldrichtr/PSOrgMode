$sourceDir = Resolve-Path "~/projects/PSOrgMode/source" | Select-Object -ExpandProperty Path

$env:PSModulePath = "$env:PSModulePath;$sourceDir"


$directories = Get-ChildItem -Path $sourceDir -Directory -Exclude "PSOrgMode"

foreach ($dir in $directories) {
  $useBlock = [scriptblock]::Create("using module $($dir.FullName)")
  . $useBlock
}
