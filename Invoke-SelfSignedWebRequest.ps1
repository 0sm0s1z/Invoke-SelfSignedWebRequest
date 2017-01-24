function Invoke-SelfSignedWebRequest
{
<#
.SYNOPSIS
    Performs web requests without certificate validation
.DESCRIPTION
    Loads the target URI's SSL certificate into the local certificate store and wraps Invoke-WebRequest. Removes certificate upon completion of insecure WebRequest invocation. Aliased to wget-ss
 
    Author: Matthew Toussain (@0sm0s1z)
    License: BSD 3-Clause
	
.EXAMPLE
	Invoke-SelfSignedWebRequest https://spectruminfosec.com/nc.exe "-outfile nc.exe"
	wget-ss https://spectruminfosec.com/index.php
	
.LINK
    https://github.com/0sm0s1z/Invoke-SelfSignedWebRequest
#>

	[CmdletBinding()]
    param(
        [uri][string]$url,
		[string]$cmdstr
    )

	Set-StrictMode -Version 3

	if($url.Scheme -ne "https") {
		#Direct to WebRequest
		$newWebRequest = "Invoke-WebRequest $url $cmdstr"
		IEX $newWebRequest
	} else {
	
		[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
		
		#Grab target SSL Certificate
		$webRequest = [System.Net.HttpWebRequest]::Create($url)
		try { $webRequest.GetResponse().Dispose() } catch {}
		$cert = $webRequest.ServicePoint.Certificate
		$bytes = $cert.Export([Security.Cryptography.X509Certificates.X509ContentType]::Cert)
		$fname = $url.host
		$savePath = "$pwd\$fname.key"
		set-content -value $bytes -encoding byte -path $savePath
		
		#Save to disk
		$importCert = new-object System.Security.Cryptography.X509Certificates.X509Certificate2
		$importCert.import($savePath)
		
		#Load into local CurrentUser Store
		$store = Get-Item "cert:\CurrentUser\My"
		$store.open("MaxAllowed")
		$store.add($importCert)
		$store.close()
	
		#Wrap Invoke-WebRequest
		$newWebRequest = "Invoke-WebRequest $url $cmdstr"
		IEX $newWebRequest
		
		#Remove Cert & Clear Validation Callback
		Get-ChildItem -Path "cert:\CurrentUser\My" -DnsName $fname | Remove-Item -force -confirm:0
		[System.Net.ServicePointManager]::ServerCertificateValidationCallback = $null
	}
}
New-Alias wget-ss Invoke-SelfSignedWebRequest
