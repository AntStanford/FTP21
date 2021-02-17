<cfif isdefined('url.typeclick') and len(url.typeclick)>

	<cfquery datasource="#settings.dsn#">
	    INSERT INTO cart_abandonment_tracker_footer (typeclick) 
	    VALUES(
	    <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#url.typeclick#">)
	</cfquery>
	
	<cfcookie name="ClickedCartAbandonmentFooterLink"  expires="NEVER">
	
	<cfif url.typeclick is "BookNow">
		
		<!--- adjust this per PMS/website --->
		<cflocation url="http://#cgi.HTTP_HOST#/#settings.booking.dir#/book-now.cfm?propertyid=#cookie.CartAbandonmentFooter#&strcheckin=#cookie.CartAbandonmentFooterCheckIn#&strcheckout=#cookie.CartAbandonmentFooterCheckOut#" addtoken="No">
	
	<cfelseif url.typeclick is "DetailPage">
		
		<!--- adjust this per PMS/website --->
		<cflocation url="http://#cgi.HTTP_HOST#/#settings.booking.dir#/#url.seoPropertyName#" addtoken="No">
	
	</cfif>

</cfif>



