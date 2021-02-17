<!--- User came from refine search and picked a property, so direct them to the detail page --->
<cfif isdefined('form.propertyid') and len(form.propertyid)>
	<cfset property = application.bookingObject.getProperty(form.propertyid)>
	<cflocation addToken="no" url="/#settings.booking.dir#/#property.seoPropertyName#">
</cfif>

<cfif isdefined('form.camefromsearchform') and !StructKeyExists(url,'scroll')>

	<!--- clear out booking session --->
	<cfif StructKeyExists(session,'booking')>
		<cfset structClear(session.booking)>
		<cfset session.mapMarkerID ="0">
	</cfif>

	<!--- Put all form variables in the session.booking scope --->
	<cfloop index="thefield" list="#form.fieldnames#">
		<cfset session.booking[theField] = form[theField]>
	</cfloop>

	<cfset url.loopStart = 1>
	<cfset url.loopEnd = 12>

<cfelseif isdefined('url.all_properties') and url.all_properties eq 'true' and !StructKeyExists(url,'scroll')>

  <!--- Clear the session when the user clicks on the All Properties link in the navigation --->
  <cfif StructKeyExists(session,'booking')>
    <cfset structClear(session.booking)>
  </cfif>

</cfif>

<cfparam name="session.booking.searchByDate" default="false">
<cfparam name="session.booking.strcheckin" default="">
<cfparam name="session.booking.strcheckout" default="">
<cfparam name="session.booking.strSortBy" default="bedrooms asc">
<cfparam name="url.loopStart" default="1">
<cfparam name="url.loopEnd" default="12">
<cfparam name="cookie.numResults" default="0">
<cfparam name="session.booking.unitCodeList" default="">
<cfparam name="session.booking.mapPropIdList" default="">
<cfparam name="session.booking.priceRangeMin" default="0">
<cfparam name="session.booking.priceRangeMax" default="5000">

<cfif
  session.booking.strcheckin neq '' and
  session.booking.strcheckout neq '' and
  session.booking.strcheckin neq session.booking.strcheckout and
  isValid('date',session.booking.strcheckin) and
  isValid('date',session.booking.strcheckout)
  >
  <cfset session.booking.searchByDate = true>
</cfif>

<cfif !StructKeyExists(url,'scroll')>
	<cfset application.bookingObject.getSearchResults()>
</cfif>

<!--- <cfinclude template="/#settings.booking.dir#/results-search-query-booked.cfm"> --->