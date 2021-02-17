<cfparam name="url.pets" default="0">
<cfset request.apiresponse = application.bookingObject.booknow(url.propertyid,url.strcheckin,url.strcheckout,'',url.pets)>
<cfoutput>#request.apiresponse#</cfoutput>