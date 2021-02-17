<!---
This file might need to be modified based on the PMS; for Escapia, use the same 'booknow' function, but passing in the promo code.

Options are: add_insurance or remove_insurance
--->


<cfif isdefined('url.propertyid') and isdefined('url.strcheckin') and isdefined('url.strcheckout') and isdefined('url.addInsurancePromoCode') and isdefined('url.promocode') and isdefined('url.chargetemplateid') and settings.booking.pms eq 'Escapia'>
		
	<!--- propertyID, arrival date, departure date, travel insurance (add_insurance,remove_insurance), promo code, charge template id --->
	<cfset apiresponse = application.bookingObject.booknow(url.propertyid,url.strcheckin,url.strcheckout,url.addInsurancePromoCode,url.promocode,url.chargetemplateid)>
	
	<cfoutput>#apiresponse#</cfoutput>
	
<cfelseif isdefined('url.leaseid') and isdefined('url.promocode') and isdefined('url.addInsurancePromoCode') and settings.booking.pms eq 'Barefoot'>

	<cfset apiresponse = application.bookingObject.addcoupon(url.leaseid,url.promocode,url.addInsurancePromoCode)>
	
	<cfoutput>#apiresponse#</cfoutput>
	
<cfelseif settings.booking.pms eq 'Track'>
	
	<cfset apiresponse = application.bookingObject.booknow(url.propertyid,url.strcheckin,url.strcheckout,url.promocode)>
	
	<cfoutput>#apiresponse#</cfoutput>
	
</cfif>