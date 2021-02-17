<cfif ICNDeyesOnly>
<cfelse>
	<cfparam name="url.propertyid" default="0"> 
	<cfoutput>#application.bookingObject.getAjaxPriceBasedOnDates(url.propertyid,session.booking.strcheckin,session.booking.strcheckout)#</cfoutput>
</cfif>