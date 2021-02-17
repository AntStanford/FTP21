
	
	<cfset returns = application.bookingObject.getDetailRates2(propertyid,checkin,checkout,resortproplist)>
		
	<cfset apiresponse = returns.apiresponse>
	<cfset total = returns.total>


<cfoutput>#apiresponse#</cfoutput>