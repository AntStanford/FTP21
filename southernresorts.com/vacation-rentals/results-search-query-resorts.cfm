<!--- User came from refine search and picked a property, so direct them to the detail page --->
<cfif isdefined('form.propertyid') and len(form.propertyid)>
	<cfset property = application.bookingObject.getProperty(form.propertyid)>
	<cflocation addToken="no" url="/#settings.booking.dir#/#property.seoPropertyName#">
</cfif>

<!--- record user visits --->
<cfinvoke component="components.usertracker" method="insertuser">
     <cfinvokeargument name="dsn" value="#settings.dsn#">
</cfinvoke>

<!--- How many people are on the site right now? --->
<cfinvoke component="components.usertracker" method="getnumvisitors" returnVariable="numvisitors">
     <cfinvokeargument name="dsn" value="#settings.dsn#">
</cfinvoke> 



<cfif isdefined('form.camefromsearchform') and !StructKeyExists(url,'scroll') and not isDefined("request.resortid")>

	<!--- clear out booking session --->
	<cfif StructKeyExists(session,'booking.resort')>
		<cfset structClear(session.booking.resort)>
		<cfset session.mapMarkerID ="0">
	</cfif>

	<!--- Put all form variables in the session.booking scope --->
	<cfloop index="thefield" list="#form.fieldnames#">
		<cfset session.booking.resort[theField] = form[theField]>
	</cfloop>

	<cfset url.loopStart = 1>
	<cfset url.loopEnd = 12>

<cfelseif isdefined('url.all_properties') and url.all_properties eq 'true' and !StructKeyExists(url,'scroll')>

  <!--- Clear the session when the user clicks on the All Properties link in the navigation --->
  <cfif StructKeyExists(session,'booking.resort')>
    <cfset structClear(session.booking.resort)>
  </cfif>

</cfif>

<cfparam name="session.booking.resort.searchByDate" default="false">
<cfparam name="session.booking.resort.strcheckin" default="">
<cfparam name="session.booking.resort.strcheckout" default="">
<cfparam name="session.booking.resort.strSortBy" default="rand()">
<cfparam name="url.loopStart" default="1">
<cfparam name="url.loopEnd" default="12">
<cfparam name="cookie.numResortResults" default="0">
<cfparam name="session.booking.resort.unitCodeList" default="">
<cfparam name="session.booking.resort.mapPropIdList" default="">
<cfparam name="session.booking.resort.priceRangeMin" default="0">
<cfparam name="session.booking.resort.priceRangeMax" default="5000">

<cfif
  session.booking.resort.strcheckin neq '' and
  session.booking.resort.strcheckout neq '' and
  session.booking.resort.strcheckin neq session.booking.resort.strcheckout and
  isValid('date',session.booking.resort.strcheckin) and
  isValid('date',session.booking.resort.strcheckout)
  >
  <cfset session.booking.resort.searchByDate = true>
</cfif>
<cfif isDefined("slug")>
<cfset session.booking.resort.weddingproperties = ((slug eq 'gulf-coast-weddings') ? 1 : 0)>
	</cfif>
<cfif !StructKeyExists(url,'scroll')>
	<cfset application.bookingObject.getSearchResultsResorts()>
</cfif>


<cfinclude template="/#settings.booking.dir#/results-search-query-booked.cfm">

