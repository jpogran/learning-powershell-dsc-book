############################################################################################
##
## From Learning PowerShell DSC (Packt)
## by James Pogran (https://www.packtpub.com/networking-and-servers/learning-powershell-dsc)
##
############################################################################################
$outputPath = ([IO.Path]::Combine($PSScriptRoot, 'SetupTheSite'))
$dataScript = ([IO.Path]::Combine($PSScriptRoot, 'wmf5_config_data.ps1'))
$configData = &$dataScript

c:\vagrant\book\ch06\example_configuration.ps1 -outputPath $outputPath -configData $configData | Out-Null

if(Test-Path (Join-Path $($outputPath) 'ExampleConfiguration.mof')){
  rm (Join-Path $($outputPath) 'ExampleConfiguration.mof')
}
Rename-Item -Path (Join-Path $($outputPath) 'dsc-box2.mof') -NewName 'ExampleConfiguration.mof'

cp $outputPath\* $env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration
New-DscChecksum -Path $env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration -Force -Verbose
New-DscChecksum -Path $env:PROGRAMFILES\WindowsPowerShell\DscService\Modules -Force -Verbose
