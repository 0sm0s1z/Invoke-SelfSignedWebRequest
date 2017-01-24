function Disable-NetSSLValidation
{
<#
.SYNOPSIS
    Configures internal .NET settings to disable SSL certificate validation
.DESCRIPTION
    Configures internal .NET settings to disable SSL certificate validation via useUnsafeHeaderParsing
 
    Author: Matthew Toussain (@0sm0s1z)
    License: BSD 3-Clause
	
.EXAMPLE
	 . .\Disable-NetSSLValidation.ps1
	 Disable-NetSSLValidation
	
.LINK
    https://github.com/0sm0s1z/Invoke-SelfSignedWebRequest
#>
	[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

	$netAssembly = [Reflection.Assembly]::GetAssembly([System.Net.Configuration.SettingsSection])

	if($netAssembly)
	{
		$bindingFlags = [Reflection.BindingFlags] "Static,GetProperty,NonPublic"
		$settingsType = $netAssembly.GetType("System.Net.Configuration.SettingsSectionInternal")

		$instance = $settingsType.InvokeMember("Section", $bindingFlags, $null, $null, @())

		if($instance)
		{
			$bindingFlags = "NonPublic","Instance"
			$useUnsafeHeaderParsingField = $settingsType.GetField("useUnsafeHeaderParsing", $bindingFlags)

			if($useUnsafeHeaderParsingField)
			{
			  $useUnsafeHeaderParsingField.SetValue($instance, $true)
			}
		}
	}
}
