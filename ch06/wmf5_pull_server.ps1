############################################################################################
##
## From Learning PowerShell DSC (Packt)
## by James Pogran (https://www.packtpub.com/networking-and-servers/learning-powershell-dsc)
##
############################################################################################
[CmdletBinding()]
param(
  $configData,
  $outputPath = ([IO.Path]::Combine($PSScriptRoot, 'WMF5PullServer'))
)

$configData.AllNodes.CertificateThumbPrint

Configuration WMF5PullServer
{
  Import-DSCResource -ModuleName xPSDesiredStateConfiguration

  Node $AllNodes.Where({ $_.Roles -contains 'PullServer'}).NodeName
  {
    WindowsFeature DSCServiceFeature
    {
      Ensure = 'Present'
      Name   = 'DSC-Service'
    }

    File RegistrationKeyFile
    {
      Ensure          = 'Present'
      DestinationPath = (Join-Path $Node.RegistrationKeyPath $Node.RegistrationKeyFile)
      Contents        = $Node.RegistrationKey
      DependsOn       = @("[WindowsFeature]DSCServiceFeature")
    }

    xDscWebService PSDSCPullServer
    {
      Ensure                       = "Present"
      EndpointName                 = $Node.PullServerEndpointName
      Port                         = $Node.PullServerPort
      PhysicalPath                 = $Node.PullServerPhysicalPath
      CertificateThumbPrint        = $Node.CertificateThumbPrint
      ModulePath                   = $Node.ModulePath
      ConfigurationPath            = $Node.ConfigurationPath
      RegistrationKeyPath          = $Node.RegistrationKeyPath
      AcceptSelfSignedCertificates = $true
      State                        = "Started"
      DependsOn                    = @("[WindowsFeature]DSCServiceFeature","[File]RegistrationKeyFile")
    }

    xDscWebService PSDSCComplianceServer
    {
      Ensure                = "Present"
      EndpointName          = $Node.ComplianceServerEndpointName
      Port                  = $Node.ComplianceServerPort
      PhysicalPath          = $Node.CompliancePhysicalPath
      CertificateThumbPrint = "AllowUnencryptedTraffic"
      IsComplianceServer    = $true
      State                 = "Started"
      DependsOn             = @("[WindowsFeature]DSCServiceFeature")
    }

    File CopyPackagedModules
    {
      Ensure          = "Present"
      Type            = "Directory"
      SourcePath      = $Node.PackagedModulePath
      DestinationPath = $Node.ModulePath
      Recurse         = $true
      DependsOn       = "[xDscWebService]PSDSCPullServer"
    }
  }
}

WMF5PullServer -ConfigurationData $configData -OutputPath $outputPath
