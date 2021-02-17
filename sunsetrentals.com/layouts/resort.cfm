<cfquery name="getResort" dataSource="#settings.dsn#">
	select * from cms_resorts where slug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cgi.query_string#">
</cfquery>

<cfset form.camefromsearchform = ''>
<cfset form.fieldnames = ''>
<cfoutput query="getResort">
	<cfset form.fieldnames = 'complex'>
	<cfset form.complex = getResort.resort>
  <cfsavecontent variable="request.resortContent">
    <cfif len(getResort.h1)>
    	<h1>#getResort.h1#</h1>
    <cfelse>
    	<h1>#getResort.name#</h1>
    </cfif>

    <cfif len(trim(getResort.pdfmap)) GT 0>
      <a href="/images/resorts/#getResort.pdfmap#" target="_blank" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white map-btn">View Map</a>
    </cfif>
    <cfinclude template="/#settings.booking.dir#/_resorts-gallery.cfm">
    <div class="resorts-info-wrap">
      <ul>
        <cfif len(getResort.address)><li><strong>Address:</strong>#getResort.address#</li></cfif>
        <cfif len(getResort.area)><li><strong>Area:</strong> #getResort.area#</li></cfif>
      </ul>
      <p>#getResort.description#</p>
      Amenities: #getResort.amenities#
    </div><!-- END resorts-info-wrap -->
  </cfsavecontent>
</cfoutput>
<cfinclude template="/#settings.booking.dir#/results.cfm">