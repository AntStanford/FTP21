<!--- Specify url path --->
<cfset path = '/userfiles'>
<cfset fullPath = replace(cgi.cf_template_path,'admin\pages\contentbuilder\saveimage.cfm','userfiles')>

<!--- Read image --->
<cfset count = url.count>
<cfset b64str = #Evaluate('form.hidimg_'&url.count)#>
<cfset imgName = #Evaluate('form.hidname_'&url.count)#>
<cfset imgType = #Evaluate('form.hidtype_'&url.count)#>

<!--- Generate random file names  --->
<cfset randomString = randString('alphanum',8)>
<cfset currentDate = Dateformat(now(),'yyyymmdd')>
<cfset currentTime = Timeformat(now(),'HHnnss')>

<cfif imgType eq 'png' or imgType eq 'jpg'>
	<cfif imgType eq 'png'>
		<cfset theImage = imgName & '-' & randomString & '-' & currentDate & '-' & currentTime & '.png'>
	<cfelse>
		<cfset theImage = imgName & '-' & randomString & '-' & currentDate & '-' & currentTime & '.jpg'>
	</cfif>
	<!--- Creates a ColdFusion image from a Base64 string --->
	<cfset theDecodedImage = ImageReadBase64(b64str)>
	<!--- Create the image in the specified location on the server --->
	<cfimage source="#theDecodedImage#" destination="#fullPath#\#theImage#" action="write" overwrite = "yes">
	<cfoutput>
  	<html>
    	<body onload="parent.document.getElementById('img-#count#').setAttribute('src','#path#/#theImage#'); parent.document.getElementById('img-#count#').removeAttribute('id')">
      </body>
    </html>
  </cfoutput>
</cfif>