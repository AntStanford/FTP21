<cfparam name="url.pets" default="0" />
<cfparam name="url.addons" default="" />
<cfparam name="url.travelInsuranceSelected" default="">

<cfset apiresponse = application.bookingObject.booknow(url.propertyid,url.strcheckin,url.strcheckout,'',url.pets,url.addons,url.travelInsuranceSelected)>

<cfoutput>#apiresponse#</cfoutput>