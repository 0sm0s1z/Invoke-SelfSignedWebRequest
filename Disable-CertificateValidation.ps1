function Disable-CertificateValidation
{
<#
.SYNOPSIS
    Disables SSL certificate validation through the ServicePointManager
.DESCRIPTION
    Disables SSL certificate validation through the System.Net.ServicePointManager endpoint by manually configuring the ServerCertificateValidationCallback to return $true. Allows (New-Object System.Net.WebClient).DownloadFile() to connect to self-signed SSL domains.
 
    Author: Matthew Toussain (@0sm0s1z)
    License: BSD 3-Clause
	
.EXAMPLE
	 Disable-CertificateValidation
	
.LINK
    https://github.com/0sm0s1z/Invoke-SelfSignedWebRequest
#>
	[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

}
Disable-CertificateValidation
