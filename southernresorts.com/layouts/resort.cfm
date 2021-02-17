<!---
<cfquery name="getResort" dataSource="#settings.dsn#">
	select * from cms_resorts_old where slug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cgi.query_string#">
</cfquery>
---> 

<cfquery name="getResort" dataSource="#settings.dsn#">
    select ts.*,nds.parentid as destid, nds.typeid as parenttypeid, nds.id as pid from track_nodes ts
	inner join track_nodes nds on nds.id = ts.parentid
	where (ts.typeName = 'Complex/Neighborhood')
    AND Replace(Replace(Replace(Replace(Replace(ts.Name, ' ',''),'(',''),')',''),'&',''),'\'','') = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cgi.query_string#">
</cfquery>

<cfif getResort.parenttypeid EQ 3>
	<cfset resortdestID = getresort.pid>
<cfelse>
	<cfset resortdestID = getresort.destID>
</cfif>

<!--- <cfif ListFind('216.99.119.254', CGI.REMOTE_ADDR)>
  <cfif structKeyExists(session,"booking.resort") AND isDefined("form.strcheckin")>
    <cfset structclear(session.booking.resort)>
  </cfif>
<cfelse>
  <cfif structKeyExists(session,"booking") AND isDefined("form.strcheckin")>
    <cfset structclear(session.booking)>
  </cfif>
</cfif> --->
<!---  <cfif structKeyExists(session,"booking.resort") AND isDefined("form.strcheckin")>
  <cfset structclear(session.booking.resort)>
</cfif> --->


<!--- If user is coming from search results, bring over some parts of search to filter properties --->
<cfif isdefined('session.booking.must_haves') and LEN(session.booking.must_haves) and !isdefined('form.must_haves')>
  <cfset form.must_haves = session.booking.must_haves>
</cfif>

<cfif isdefined('session.booking.amenities') and LEN(session.booking.amenities) and !isdefined('form.amenities')>
  <cfset form.amenities = session.booking.amenities>
</cfif>
<cfif isdefined('session.booking.sleeps') and LEN(session.booking.sleeps) and !isdefined('form.sleeps')>
  <cfset form.sleeps = session.booking.sleeps>
</cfif>
<cfif isdefined('session.booking.amenities') and LEN(session.booking.amenities) and !isdefined('form.amenities')>
  <cfset form.amenities = session.booking.amenities>
</cfif>
<cfif isdefined('session.booking.bedrooms') and LEN(session.booking.bedrooms) and !isdefined('form.bedrooms')>
  <cfset form.bedrooms = session.booking.bedrooms>
</cfif>
<cfif isdefined('session.booking.strcheckin') and LEN(session.booking.strcheckin) and !isdefined('form.strcheckin')>
  <cfset form.xxxxxxx = session.booking.strcheckin>
</cfif>
<cfif isdefined('session.booking.strcheckout') and LEN(session.booking.strcheckout) and !isdefined('form.strcheckout')>
  <cfset form.strcheckout = session.booking.strcheckout>
</cfif>



 <cfif structKeyExists(session,"booking") and structKeyExists(session.booking,"resort") AND isDefined("form.strcheckin")>
  <cfset structclear(session.booking.resort)>
</cfif>


<!--- <cfif !ListFind('216.99.119.254', CGI.REMOTE_ADDR)><cfset session.booking.neighborhoods = getResort.Id></cfif> --->
<cfset session.booking.resort.neighborhoods = getResort.Id>

<cfif isDefined("form.strcheckin")>
<!--- 	<cfif !ListFind('216.99.119.254', CGI.REMOTE_ADDR)><cfset session.booking.strcheckin = form.strcheckin></cfif> --->
  <cfset session.booking.resort.strcheckin = form.strcheckin>
</cfif>
<cfif isDefined("form.strcheckout")>
<!--- 	<cfif !ListFind('216.99.119.254', CGI.REMOTE_ADDR)><cfset session.booking.strcheckout = form.strcheckout></cfif> --->
  <cfset session.booking.resort.strcheckout = form.strcheckout>
</cfif>
<cfif isDefined("form.sleeps")>
<!--- 	<cfif !ListFind('216.99.119.254', CGI.REMOTE_ADDR)><cfset session.booking.sleeps = form.sleeps></cfif> --->
  <cfset session.booking.resort.sleeps = form.sleeps>
</cfif>
<cfif isDefined("form.must_haves")>
<!--- 	<cfif !ListFind('216.99.119.254', CGI.REMOTE_ADDR)><cfset session.booking.must_haves = form.must_haves></cfif> --->
  <cfset session.booking.resort.must_haves = form.must_haves>
</cfif>
<cfif isDefined("form.amenities")>
<!--- 	<cfif !ListFind('216.99.119.254', CGI.REMOTE_ADDR)><cfset session.booking.amenities = form.amenities></cfif> --->
  <cfset session.booking.resort.amenities = form.amenities>
</cfif>
<cfif isDefined("form.bedrooms")>
<!--- 	<cfif !ListFind('216.99.119.254', CGI.REMOTE_ADDR)><cfset session.booking.bedrooms = form.bedrooms></cfif> --->
  <cfset session.booking.resort.bedrooms = form.bedrooms>
</cfif>
<cfset request.resortID = getResort.Id>
<cfquery name="getCmsResort" dataSource="#settings.dsn#">
	select * from cms_resorts where propertyid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#request.resortID#">
</cfquery>


<!---
<cfdump var="#getResort#">--->

<!--- <cfdump var="#cgi#"> --->

<cfset form.camefromsearchform = ''>
<cfset form.fieldnames = ''>

<!--- <cfset getResort.metaTitle = ''> --->
<cfoutput query="getResort">

	<cfset Resname = reReplace(name, "[[:space:]]", "", "ALL") />
	<cfset slug = Resname />
<!--- 	<cfset metaTitle = "#timezone#"> --->

  <cfsavecontent variable="request.resortContent">
  
<!---
    <cfif len(getResort.h1)>
    	<h1>#getResort.h1#</h1>
    <cfelse>
    	<h1>#getResort.name#</h1>
    </cfif> 
--->
    <cfinclude template="/#settings.booking.dir#/_resorts-gallery.cfm">
  </cfsavecontent>
</cfoutput>
    

<!---
    <div class="resorts-info-wrap">
      <ul>
        <cfif len(getResort.address)><li><strong>Address:</strong>#getResort.address#</li></cfif>
        <cfif len(getResort.area)><li><strong>Area:</strong> #getResort.area#</li></cfif>
        <cfif len(getResort.bedrooms)><li><strong>Beds:</strong> #getResort.bedrooms#</li></cfif>
        <cfif len(getResort.bathrooms)><li><strong>Baths:</strong> #getResort.bathrooms#</li></cfif>
        <cfif len(getResort.sleeps)><li><strong>Sleeps:</strong> #getResort.sleeps#</li></cfif>
      </ul>
      <p>#getResort.description#</p>
    </div>
---><!-- END resorts-info-wrap -->
<!---
  </cfsavecontent>
</cfoutput>
--->


<!--- <cfif ListFind('216.99.119.254', CGI.REMOTE_ADDR)><cfdump var="#url#"><cfdump var="#form#"><cfdump var="#session.booking.strcheckin#"><cfdump var="#session.booking.resort.strcheckin#"></cfif> --->
<a id="footerAnchor" style="height: 1px;"></a>
  <cfinclude template="/#settings.booking.dir#/results-resorts.cfm">
  <!--- <cfinclude template="/#settings.booking.dir#/results.cfm"> --->
<form id="refineForm">
  <input type="hidden" name="isresort" value="1">
  <input type="hidden" name="page" value="0">
</form>
