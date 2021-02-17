<cfif isdefined('form.submit') and cgi.HTTP_USER_AGENT does not contain 'bot'>

<cfset propertyResults = application.bookingObject.getSearchResultsProperty(form.searchterm)>

<div role="tabpanel">

  <!-- Nav tabs -->
  <ul class="nav nav-tabs" role="tablist">
    <li role="presentation" class="active"><a href="#PropResults" aria-controls="home" role="tab" data-toggle="tab">Property Results</a></li>
    <li role="presentation"><a href="#PageResults" aria-controls="profile" role="tab" data-toggle="tab">Page Results</a></li>
  </ul>

  <!-- Tab panes -->
  <div class="tab-content">
    <div role="tabpanel" class="tab-pane active" id="PropResults">
	<br>
	<h3>Property Results</h3>

	<cfif propertyResults.recordcount eq 0>

	<p>Your search <strong><cfoutput>#form.SearchTerm#</cfoutput></strong> did not produce any results in the property portion of our site.</p>

	  <cfelse>

	<cfoutput query="propertyResults">
	  <p><a href="/vacation-rentals/#seoDestinationName#/#seoPropertyName#"><strong>#propertyname#</strong></a> #mid(propertydesc,1,300)#...</p>
	</cfoutput>

	</cfif>

	</div>

    <div role="tabpanel" class="tab-pane" id="PageResults">
	<br>
		<h3>Page Results</h3>

	<CFQUERY DATASOURCE="#settings.dsn#" NAME="GetSearchResultsPages">
	  SELECT *
	  FROM cms_pages
	  where name like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#form.SearchTerm#%">
	  or body like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#form.SearchTerm#%">
	  or h1 like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#form.SearchTerm#%">
	  or metatitle like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#form.SearchTerm#%">
	  or metadescription like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#form.SearchTerm#%">
	</CFQUERY>

	<cfif GetSearchResultsPages.recordcount eq 0>

	<p>Your search <strong><cfoutput>#form.SearchTerm#</cfoutput></strong> did not produce any results in the pages portion of our site.</p>

	  <cfelse>

	<cfoutput query="GetSearchResultsPages">
	  <p><a href="/#slug#">#name#</a></p>
	</cfoutput>

	</cfif>



	</div>
  </div>

</div>

	<!---log this search--->
	<cfquery datasource="#settings.dsn#">
	    INSERT INTO sitesearchtracking (<cfif isdefined('Cookie.TrackingEmail')>TrackingEmail<cfelse>UserTrackerValue</cfif>,SearchTerm,PropertyResultsReturned,PagesResultsReturned)
	    VALUES(
	    <cfif isdefined('Cookie.TrackingEmail')>
		  <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cookie.TrackingEmail#">
		<cfelse>
		  <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cookie.UserTrackingCookie#">
		 </cfif>,
	    <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#SearchTerm#">,
		<cfqueryparam value="#propertyResults.recordcount#" cfsqltype="CF_SQL_NUMERIC">,
		<cfqueryparam value="#GetSearchResultsPages.recordcount#" cfsqltype="CF_SQL_NUMERIC">)
    </cfquery>


</cfif>