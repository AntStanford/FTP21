<cfif 
	isdefined('form.strcheckin') and isdate( form.strcheckin ) and
	isdefined('form.strcheckout') and isdate( form.strcheckout ) and
	isdefined('form.propertyid') and len( form.propertyid )>
	
	<cfif cgi.remote_host eq '172.110.82.184' or cgi.remote_host eq '99.1.177.220'>
		<cfset apiresponse = application.bookingObject.getDetailRatesNew( form.propertyid, form.strcheckin, form.strcheckout ) />
	<cfelse>
		<cfset apiresponse = application.bookingObject.getDetailRates(form.propertyid,form.strcheckin,form.strcheckout)>
	</cfif>

<cfelse>
	<cfset apiresponse = 'One or more required parameters is missing. Please try again.'>
</cfif>

<cfoutput>#apiresponse#</cfoutput>