<cfif isdefined('form.submit') and cgi.HTTP_USER_AGENT does not contain 'bot'>

<cfset propertyResults = application.bookingObject.getSearchResultsProperty(form.searchterm)>

  <div class="site-search-wrap">
    <ul class="nav nav-tabs">
      <li class="nav-item"><a class="nav-link active" id="prop-results" data-toggle="tab" href="#PropResults" role="tab" aria-controls="PropResults" aria-selected="true">Property Results</a></li>
      <li class="nav-item"><a class="nav-link" id="page-results" data-toggle="tab" href="#PageResults" role="tab" aria-controls="PageResults" aria-selected="false">Page Results</a></li>
    </ul>

    <div class="tab-content" id="siteSearchContent">
      <div class="tab-pane show active" id="PropResults" role="tabpanel" aria-labelledby="prop-results">
        <div class="card">
          <div class="card-body">
          	<h3>Property Results</h3>

          	<cfif propertyResults.recordcount eq 0>
            	<p>Your search <strong><cfoutput>#form.SearchTerm#</cfoutput></strong> did not produce any results in the property portion of our site.</p>
        	  <cfelse>
            	<cfoutput query="propertyResults">
            	  <p><a href="/rentals/#seoPropertyName#"><strong>#propertyname#</strong></a> #mid(propertydesc,1,300)#...</p>
            	</cfoutput>
          	</cfif>
          </div>
        </div>
    	</div>

      <div class="tab-pane" id="PageResults" role="tabpanel" aria-labelledby="page-results">
        <div class="card">
          <div class="card-body">
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