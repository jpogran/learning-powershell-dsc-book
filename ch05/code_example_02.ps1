Configuration SetupAllTheThings
{
  Import-DscResource -Module PSDesiredStateConfiguration
  Node ($AllNodes).NodeName
  {
    File CreateFile
    {
      Ensure          = 'Present'
      DestinationPath = 'c:\test.txt'
      Contents        = 'Wakka'
    }
  }
}

$dataFile   = [IO.Path]::Combine($PSScriptRoot, 'data_example_01.psd1')
$OutputPath = [IO.Path]::Combine($PSScriptRoot, 'SetupAllTheThings')
SetupAllTheThings -ConfigurationData $dataFile -OutputPath $OutputPath
