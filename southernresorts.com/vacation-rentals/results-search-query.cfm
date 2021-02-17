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
<cfparam name="session.booking.strSortBy" default="rand()">
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
<cfif isDefined("slug")>
	<cfset session.booking.weddingproperties = ((slug eq 'gulf-coast-weddings') ? 1 : 0)>
</cfif>


<!--- Per client request, show Fort Morgan properties when search Gulf Shores --->
<cfif isdefined('session.booking.town') and LEN(session.booking.town) and session.booking.town contains "Gulf Shores">
	<cfset session.booking.town = listAppend(session.booking.town, 'Fort Morgan')>
</cfif>

<!--- Per client request, show Gulf Breeze properties when search Pensacola Beach --->
<cfif isdefined('session.booking.town') and LEN(session.booking.town) and session.booking.town contains "Pensacola Beach">
	<cfset session.booking.town = listAppend(session.booking.town, 'Gulf Breeze')>
</cfif>

<cfif isDefined('session.booking.type') and session.booking.type is 'condo'>
	<cfset session.booking.type = listAppend(session.booking.type,'townhome') />
</cfif>


<cfif !StructKeyExists(url,'scroll')>
	<cfif structKeyExists(form,'resorts') and listLen(form.resorts)>
		<cfset application.bookingObject.getSearchResults(resortfilterList = form.resorts)>
	<cfelse>
		<cfset application.bookingObject.getSearchResults()>
	</cfif>
</cfif>

<!--- <cfinclude template="/#settings.booking.dir#/results-search-query-booked.cfm"> --->