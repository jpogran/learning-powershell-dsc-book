############################################################################################
##
## From Learning PowerShell DSC (Packt)
## by James Pogran (https://www.packtpub.com/networking-and-servers/learning-powershell-dsc)
##
############################################################################################
$outputPath = ([IO.Path]::Combine($PSScriptRoot, 'SetupTheSite'))
$dataScript = ([IO.Path]::Combine($PSScriptRoot, 'https_config_data.ps1'))
$configData = &$dataScript

.\example_configuration.ps1 -outputPath $outputPath -configData $configData | Out-Null

if(Test-Path (Join-Path $($outputPath) 'ExampleConfiguration.mof')){
  rm (Join-Path $($outputPath) 'ExampleConfiguration.mof')
}
Rename-Item -Path (Join-Path $($outputPath) 'dsc-box2.mof') -NewName 'ExampleConfiguration.mof'

Import-Module -Name "$($env:ProgramFiles)\WindowsPowerShell\Modules\DSCPullServerSetup\PublishModulesAndMofsToPullServer.psm1"

$moduleList = @("xWebAdministration", "xPSDesiredStateConfiguration")
Publish-DSCModuleAndMOF -Source $PSScriptRoot -ModuleNameList $moduleList

