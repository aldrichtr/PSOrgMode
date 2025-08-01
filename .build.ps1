$stitchDir = (Join-Path $env:XDG_CONFIG_HOME "stitch")
$toolsDir = (Join-Path $stitchDir "tools")
$env:Path = "$env:Path;$toolsDir"

task Clean {
  & "dotnet" @('clean')
  @('stage')
  | Foreach-Object {
    Get-ChildItem "$BuildRoot/$_"
    | Remove-Item -Recurse -Force
  }

}

task Validate -Before Compile {
  @('docs', 'out', 'publish', 'stage')
  | ForEach-Object {
    $dir = (Join-Path $BuildRoot $_)
    if (-not ($dir | Test-Path)) {
      New-Item -Path $dir -ItemType Directory
    }
  }
}

task Compile -Before Build {
  & "dotnet" @('build')
}

task Build -Before Test {
  Build-Module
}

task Test -Before Install {
  . "$toolsDir\runTests.ps1"
}

task Install {}

task Uninstall {}

task Publish {}

task . Build
