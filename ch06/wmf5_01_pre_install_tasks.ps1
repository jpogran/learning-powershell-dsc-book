
## this is only needed to compile the MOF on the pullserver, our chosen authoring station
Install-Package -Name 'xWebAdministration' -RequiredVersion 1.7.0.0 -Force -ForceBootStrap
Install-Package -Name 'xPSDesiredStateConfiguration' -RequiredVersion 3.4.0.0 -Force -ForceBootStrap

## this is only needed if you don't already have your DSC Resources packaged
. c:\vagrant\book\ch06\dsctooling.ps1
if(-not(Test-Path 'c:\modules')){ mkdir 'c:\modules' }
$modules = @('xWebAdministration','xPSDesiredStateConfiguration')
$modules | % {
  New-DscResourceArchive -ModulePath (Join-Path 'C:\vagrant' $_) -Destinationpath (Join-Path 'c:\modules' $_) -Force
}
New-DscChecksum -Path 'c:\modules'

## if you are using test machines that cannot resolve each other's hostnames
if(-not (Select-String -Path 'C:\Windows\System32\drivers\etc\hosts' -Pattern '192.168.0.12')){
  Add-Content -Path C:\Windows\System32\drivers\etc\hosts -Value "`n192.168.0.12`tdsc-box1"
  Add-Content -Path C:\Windows\System32\drivers\etc\hosts -Value "`n192.168.0.13`tdsc-box2"
}

## This is only required if you are using test machines without a AD domain cert or SSL cert that
## is on all machines
$CertPath = 'C:\vagrant\servercert.cer'
$cert = Get-ChildItem -Path Cert:\LocalMachine\My\ | ? { $_.Subject -eq 'CN=dsc-box1' }
if($cert.Count -eq 0){
  $cert =  New-SelfSignedCertificate -DnsName 'dsc-box1' -CertStoreLocation cert:\LocalMachine\My
}
Export-Certificate -Cert "Cert:\LocalMachine\My\$($cert.ThumbPrint)" -FilePath $CertPath
Import-Certificate -FilePath $CertPath -CertStoreLocation Cert:\LocalMachine\Root

## This is only required if you are using test machines that are not joined to the domain
## or are using IPAddresses to resolve hostnames
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value * -Force

## This is only required if did not add rules to allow the website ports. In production add
## firewall rules for the PSDSCPullServer and PSDSCReportingServer website ports
Set-NetFirewallProfile -All -Enabled false

## if you are using test machines that cannot resolve each other's hostnames
Invoke-Command -ComputerName 'dsc-box2' -Scriptblock {
  Set-NetFirewallProfile -All -Enabled false
  Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value * -Force
  Import-Certificate -FilePath "C:\vagrant\servercert.cer" -CertStoreLocation Cert:\LocalMachine\Root
  if(-not (Select-String -Path "C:\Windows\System32\drivers\etc\hosts" -Pattern "192.168.0.12")){
    Add-Content -Path C:\Windows\System32\drivers\etc\hosts -Value "`n192.168.0.12`tdsc-box1"
    Add-Content -Path C:\Windows\System32\drivers\etc\hosts -Value "`n192.168.0.13`tdsc-box2"
  }
}
