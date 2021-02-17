<!--- Set a default slug --->
<cfif cgi.query_string is ''>
  <cfset slug = 'index'> 
<cfelse>
  
  <!--- Get first part --->
  <cfset temp = ListGetAt(cgi.query_string,1,'&')>
  
  <!--- This is needed for Google tracking URLs --->
  <cfif temp contains 'utm_source' or temp contains 'fbclid' or temp contains 'fbclid' or temp contains 'gclid' or temp contains 'phonalytics' or temp contains 'nck'>
    <cfset slug = 'index'>
	  	
		<cfif isdefined('utm_campaign') and utm_campaign is "cart-abandon-email">
			<cfcookie name="CartAbandonEmail" value="Yes" expires="30"> 
			<cfif isdefined('CAK')><cfcookie name="CartAbandonmentKey" value="#CAK#" expires="30"> </cfif>	
		</cfif>
		
  <cfelse>  
    <cfset slug = ListGetAt(cgi.query_string,1,'&')>
  </cfif>
  
</cfif>

<!--- Get the last character in the URL slug --->
<cfset lastCharInString = #right(slug,1)#>

<!---
If the last characer is a forward slash, then strip it and redirect user to same
slug without the /  
--->
<cfif lastCharInString is '/'>
  <cfset cleanSlug = #substr(slug,-1)#>
  <cflocation addToken="no" url="/#cleanSlug#" statuscode="301">
</cfif>

<!--- Try and find the page in the pages table, using a custom function --->
<cfset page = getPageText(slug)>

<cfif page.isCustomSearchPage eq 'Yes'>
	
	<cfinclude template="/layouts/full-booking.cfm">		

<cfelse>
	
	<cfinclude template="/components/header.cfm">
	
	<cfif page.recordcount gt 0>		   
	   
    <cfif len(page.layout)>
      <!--- Use a custom layout defined in the database --->
      <cfinclude template="/layouts/#page.layout#">    
    <cfelse>
      <!--- Use the default layout --->
      <cfinclude template="/layouts/default.cfm">
    </cfif>  
	
	<cfelse>    
  	<cfinclude template="/layouts/notfound.cfm">
	</cfif>
	
	<!--- Include a common footer --->
	<cfinclude template="/components/footer.cfm">
	
</cfif>
