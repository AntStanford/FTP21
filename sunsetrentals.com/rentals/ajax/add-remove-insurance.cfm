<!---
This file might need to be modified based on the PMS; for Escapia, use the same 'booknow' function, but passing in the url.useraction value.

Options are: add_insurance or remove_insurance
--->


<cfif isdefined('url.propertyid') and isdefined('url.strcheckin') and isdefined('url.strcheckout') and isdefined('url.useraction') and isdefined('url.chargetemplateid') and settings.booking.pms eq 'Escapia'>
	
	<cfif isdefined('url.promocode')>
		<cfset thePromoCode = url.promocode>
	<cfelseif isdefined('url.hiddenPromoCode')>
		<cfset thePromoCode = url.hiddenPromoCode>
	<cfelse>
		<cfset thePromoCode = ''>		
	</cfif>
	
	<!--- propertyID, arrival date, departure date, travel insurance (add_insurance,remove_insurance), promo code, charge template id --->
	<cfset apiresponse = application.bookingObject.booknow(url.propertyid,url.strcheckin,url.strcheckout,url.useraction,thePromoCode,url.chargetemplateid)>
	
	<cfoutput>#apiresponse#</cfoutput>

<cfelseif isdefined('url.useraction') and isdefined('url.leaseID') and isdefined('url.serviceID') and settings.booking.pms eq 'Barefoot'>

	<cfset apiresponse = application.bookingObject.selectOptionalServices(url.useraction,url.leaseID,url.serviceID)>
	
	<cfoutput>#apiresponse#</cfoutput>
	
<cfelseif isdefined('url.propertyid') and isdefined('url.strcheckin') and isdefined('url.strcheckout') and isdefined('url.useraction') and settings.booking.pms eq 'Homeaway'>

	<cfset apiresponse = application.bookingObject.booknow(url.propertyid,url.strcheckin,url.strcheckout,url.useraction)>
	
	<cfoutput>#apiresponse#</cfoutput>
	
</cfif>