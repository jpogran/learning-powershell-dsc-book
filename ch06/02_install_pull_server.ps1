############################################################################################
##
## From Learning PowerShell DSC (Packt)
## by James Pogran (https://www.packtpub.com/networking-and-servers/learning-powershell-dsc)
##
############################################################################################

$dataScript = ([IO.Path]::Combine($PSScriptRoot, 'wmf5_config_data.ps1'))
$configData = &$dataScript

c:\vagrant\book\ch06\wmf5_pull_server.ps1 -OutputPath ([IO.Path]::Combine($PSScriptRoot, 'WMF5PullServer')) -ConfigData $configData

Start-DscConfiguration -Path ([IO.Path]::Combine($PSScriptRoot, 'WMF5PullServer')) -Wait -Verbose -Force

