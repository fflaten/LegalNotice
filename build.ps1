#Install nuget provider
#Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
#Install modules
Install-Module Pester -Force -SkipPublisherCheck -Scope CurrentUser -AllowClobber

#Run tests
$TestFile = "$PSScriptRoot\TestResults.xml"
Invoke-Pester -PassThru -OutputFormat NUnitXml -OutputFile $testFile