#Invoke-SelfSignedWebRequest

For InfoSec work, using HTTPS is an incredibly handy mechanism for C2 and maneuver within target network space. Further PowerShell is an amazing productivity tool that can help an operator achieve dynamic results. A natural next conclusion is to combine the C2 channel (HTTPS) with the effects generator (PowerShell). Just spawn up a quick self-signed cert and life is hunky dory, right? Unfortunately, as it turns out Microsoft (and by extension PowerShell) really doesn't like SSL connections secured by certificates that can't be validated. They go out of their way to PREVENT these connections by throwing heinous levels of ERROR messaging.
This repo exists as a quick and dirty arsenal of methods and scripts to subvert those security focused features and press on with the hack!

My intent is to add on new methods as the come to mind. Pull requests welcome!

##Methods:
*Invoke-SelfSignedWebRequest - Loads the target URI's SSL certificate into the local certificate store and wraps Invoke-WebRequest. Removes certificate upon completion of insecure WebRequest invocation. Aliased to wget-ss
*Disable-CertificateValidation - Disables SSL certificate validation through the System.Net.ServicePointManager endpoint by manually configuring the ServerCertificateValidationCallback to return $true. Allows (New-Object System.Net.WebClient).DownloadFile() to connect to self-signed SSL domains.
*Disable-NetSSLValidation - Configures internal .NET settings to disable SSL certificate validation via useUnsafeHeaderParsing


Author: Matthew Toussain (@0sm0s1z)
License: BSD 3-Clause
	
