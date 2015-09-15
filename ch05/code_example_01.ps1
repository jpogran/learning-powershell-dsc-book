Configuration SetupAllTheThings
{
  Import-DscResource -Module PSDesiredStateConfiguration
  Node "localhost"
  {
    File CreateFile
    {
      Ensure          = "Present"
      DestinationPath = "c:\test.txt"
      Contents        = "Wakka"
    }
  }
}

SetupAllTheThings -OutputPath ([IO.Path]::Combine($PSScriptRoot, "SetupAllTheThings"))
