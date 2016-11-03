trap {
  write-error $_
  exit 1
}

$env:GOPATH = Join-Path -Path $PWD "gopath"
$env:PATH = $env:GOPATH + "/bin;C:/go/bin;" + $env:PATH


if ((Get-Command "go.exe" -ErrorAction SilentlyContinue) -eq $null)
{
  Write-Host "Installing Go 1.7.3!"
  Invoke-WebRequest https://storage.googleapis.com/golang/go1.7.3.windows-amd64.msi -OutFile go.msi

  $p = Start-Process -FilePath "msiexec" -ArgumentList "/passive /norestart /i go.msi" -Wait -PassThru

  if($p.ExitCode -ne 0)
  {
    throw "Golang MSI installation process returned error code: $($p.ExitCode)"
  }
  Write-Host "Go is installed!"
}

go.exe build -o winsw-pipe-output/winsw-pipe-$version.exe $env:GOPATH/src/github.com/cloudfoundry/bosh-agent/jobsupervisor/pipe/main.go
