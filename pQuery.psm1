<#
	pQuery - powerShell Web automation simplified! Inspired by jQuery's ease of use
	
	Author: Gil Ferreira 
	gitHub: github.com/misterGF
	Created: 06/11/2014
	
	Import-Module pQuery
#>

#Create pQuery Variable
	$global:pQuery = New-Object -TypeName 'System.Management.Automation.PSObject' -Property @{ Version=1.0; Description='pQuery - powerShell Web automation simplified! Inspired by jQuery''s ease of use'; validElements = ("button","div","form","textField","link","radioButton"); URL=$null }
	
	#Define functions
	$init = {

	<#	Starts web autiomation by creating browser object. This function will create a browser object	#>
		
		$ErrorActionPreference = "STOP"	
		
		try
		{	
			[System.Reflection.Assembly]::LoadFrom("$PSScriptRoot\SimpleBrowser.dll")
			$global:pQueryBrowser = New-Object SimpleBrowser.Browser $null,$null
		}
		catch
		{
			Write-Host "Unable to create browser object. Error: $_" -ForegroundColor:Red
		}
	}
	
	$end = {
		<# End pQuery browser isntance. #>		
		$pQueryBrowser.Close()		
	}
	
	$navigate = {
	<#
	    Navigate to a specific URI.
		
	    C:\PS> $pQuery.navigate("http://github.com/misterGF")
	#>
		param([Parameter(Mandatory=$True)][URI]$Site)
			
		#Make sure site is URI
		if(!$Site.IsAbsoluteUri)
		{	
			Write-Host "$site is not a valid URI. Make sure to include the http:// part!" -ForegroundColor:Red
			return
		}	
		
		#Make sure browser was initialized
		if($pQueryBrowser)
		{
			$nav = $pQueryBrowser.Navigate($Site)
			
			if($nav)
			{
				Write-Host "Navigated to $site" -ForegroundColor:Green
				$pQuery.Url = $pQueryBrowser.Url.ToString()
			}
			else
			{
				Write-Host "Unable to navigate to $site" -ForegroundColor:Red
			}
		}
		else
		{
			Write-Host "Browser not initalized. Try running $pQuery.init() first." -ForegroundColor:Red
		}
	}
	
	$select = {
		<#
			Selecting!
				Types can be button, div, form, textField, link or radioButton.

				$pQuery.Select("button") //By Type

				$pQuery.Select("#button") //By ID

				$pQuery.Select(".button") //By Class
		#>	
	
		param([Parameter(Mandatory=$True)][string]$selector)
		
		$firstChar = $selector[0]
		
		if( (".","#") -contains $firstChar)
		{
			$selector = $selector.Substring(1)
		}
		
		switch($firstChar)
		{
			"." {				
					#Searching by Class
					foreach($type in $pQuery.validElements)
					{
						$pQueryBrowser.Find($type,[SimpleBrowser.FindBy]::Class,$selector)																	
					}				
				}
				
			"#" {
					#Searching by ID										
					foreach($type in $pQuery.validElements)
					{
						$pQueryBrowser.Find($type,[SimpleBrowser.FindBy]::Id,$selector)												
					}
				}
				
			default 
				{
					#Looking for an element
					if($pQuery.validElements -contains $selector)
					{
						$pQueryBrowser.FindAll($selector)								
					}
					else
					{ 
						$invalid = "$selector is an invalid type. Type one of these {0}" -f ($pQuery.validElements -join ",")
						Write-Host $invalid -ForegroundColor:Red
					}													
				}		
		}	
	}
	
	
	$getText = {
		<#
			Getting Text!

				$pQuery.getText("button") //By Type

				$pQuery.getText("#button") //By ID

				$pQuery.getText(".button") //By Class
		#>
		param([Parameter(Mandatory=$True)][string]$selector)
		
		$firstChar = $selector[0]
		
		if( (".","#") -contains $firstChar)
		{
			$selector = $selector.Substring(1)
		}
		
		switch($firstChar)
		{
			"." {
					#Searching by Class
					foreach($type in $pQuery.validElements)
					{
						$raw = $pQueryBrowser.Find($type,[SimpleBrowser.FindBy]::Class,$selector)
						
						foreach($element in $raw)
						{
							if($element.value)
							{
								Write-Host $element.value
							}
							else
							{
								#Grab location of tags
								$tagClose = $raw.IndexOf(">") + 1
								$tagCloseStart = $raw.IndexOf("</")
								$strLenght = $tagCloseStart - $tagClose
								
								$value = ($element.XElement.SubString($tagClose, $strLength)).trim()
								Write-Host $value
							}
						}
					}									
				}
				
			"#" {
					#Searching by ID					
					$pQueryBrowser.Element($selector) | Select Value,Text, OuterText, OuterHtml
				}
				
			default 
				{
					#Looking for an element
					if($pQuery.validElements -contains $selector)
					{
						$selectorMethod = $selector + "s"
						$pQueryBrowser.$selectorMethod | Select Value,Text, OuterText, OuterHtml											
					}
					else
					{ 
						$invalid = "$selector is an invalid type. Type one of these {0}" -f ($pQuery.validElements -join ",")
						Write-Host $invalid -ForegroundColor:Red
					}
													
				}		
		}		
	
	}
	
	
	$setText = {
		<#
			Setting Text!
			
				$pQuery.setText("button","My Modified Text") //By Type

				$pQuery.setText("#button","My Modified Text") //By ID

				$pQuery.setText(".button","My Modified Text") //By Class
		#>	
	
	}
	
	$click = {
		<#
			Clicking!
			
				$pQuery.click("#button") //By ID

				$pQuery.click(".button") //By Class
		#>		
	}
	
	$submit = {
		<#
			Submit!
			
				$pQuery.submit("#button") //By ID

				$pQuery.submit(".button") //By Class
		#>		
	
	}
		
	#Add Functions
	Add-Member -InputObject $pQuery -MemberType ScriptMethod -Name 'Init' -Value $init
	Add-Member -InputObject $pQuery -MemberType ScriptMethod -Name 'End' -Value $end
	Add-Member -InputObject $pQuery -MemberType ScriptMethod -Name 'Navigate' -Value $navigate
	Add-Member -InputObject $pQuery -MemberType ScriptMethod -Name 'Select' -Value $select
	Add-Member -InputObject $pQuery -MemberType ScriptMethod -Name 'getText' -Value $getText
	Add-Member -InputObject $pQuery -MemberType ScriptMethod -Name 'setText' -Value $setText
	Add-Member -InputObject $pQuery -MemberType ScriptMethod -Name 'Click' -Value $click
	Add-Member -InputObject $pQuery -MemberType ScriptMethod -Name 'Submit' -Value $submit