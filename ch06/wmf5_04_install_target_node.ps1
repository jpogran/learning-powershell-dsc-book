$outputPath = ([IO.Path]::Combine($PSScriptRoot, 'WMF5TargetNodeLCM'))
$dataScript = ([IO.Path]::Combine($PSScriptRoot, 'wmf5_config_data.ps1'))
$configData = &$dataScript

C:\vagrant\book\ch06\wmf5_target_node.ps1 -configdata $configData -output $outputPath
Set-DscLocalConfigurationManager -Path $outputPath -Verbose
  
