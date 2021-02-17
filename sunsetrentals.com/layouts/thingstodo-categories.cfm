<cfquery name="getCategory" dataSource="#settings.dsn#">
	select * from cms_thingstodo_categories where slug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cgi.query_string#">
</cfquery>
<cfinclude template="/components/header.cfm">

<cfif getCategory.recordcount gt 0>
	<cfquery name="getThingstodo" dataSource="#settings.dsn#">
		select * from cms_thingstodo where catID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getCategory.id#">
	</cfquery>
	<cfquery name="getAllCategories" dataSource="#settings.dsn#">
		select title,slug from cms_thingstodo_categories order by title
	</cfquery>
	<div class="i-content int">
	  <div class="container">
	  	<div class="row">
	  		<div class="col">
	        <cfcache key="cms_thingstodo" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files">
            <cfoutput>
              <cfif len(getCategory.h1)>
                <h1 class="site-color-3">#getCategory.h1#</h1>
              <cfelse>
                <h1 class="site-color-3">#getCategory.title#</h1>
              </cfif>
            </cfoutput>

            <div class="i-quick-nav">
              <cfloop query="getAllCategories">
                <cfoutput><a href="/thingstodo/#slug#" class="btn site-color-1-bg site-color-2-bg-hover text-white">#title#</a></cfoutput>
              </cfloop>
            </div>
            <br>
            <cfif len(trim(getCategory.description)) GT 0>
            	<cfoutput>#getCategory.description#</cfoutput>
            </cfif>
	      		<div class="row i-ttd-wrap">
	        		<cfloop query="getThingstodo">
	        			<cfoutput>
    	      			<div class="col-sm-12 col-md-6 col-lg-4">
    	      				<div class="i-ttd-boxes site-color-1-bg site-color-1-lighten-bg-hover text-white">
    	      			    <cfif len(website)>
    		      			    <a href="#website#" target="_blank" rel="noopener">
    		      			    	<cfif len(photo)>
    		      			    		<img class="lazy" data-src="/images/thingstodo/#photo#" src="/images/layout/1x1.png" alt="Things To Do #photo#">
    		      			    	<cfelse>
    		      			    		<img class="lazy" data-src="http://placehold.it/359x177&text=No%20Image" src="/images/layout/1x1.png" alt="Things To Do Placeholder">
    		      			    	</cfif>
    		      			    </a>
    	      			    <cfelse>
    	      			    	<cfif len(photo)>
    	      			    		<img class="lazy" data-src="/images/thingstodo/#photo#" src="/images/layout/1x1.png" alt="Things To Do #photo#">
    	      			    	<cfelse>
    	      			    		<img class="lazy" data-src="http://placehold.it/359x177&text=No%20Image" src="/images/layout/1x1.png" alt="Things To Do Placeholder">
    	      			    	</cfif>
    	      			    </cfif>
    	      					<div class="box-info">
    	      						<p class="h4 text-white">#title#</p>
                        <p>
                          <cfif len(description) gt 250>
                            #left(description,250)#...
                          <cfelse>
                            #description#
                          </cfif>
                        </p>
    	      						<cfif len(website)>
    	      							<a href="#website#" target="_blank" class="btn site-color-2-bg site-color-3-bg-hover text-white details" rel="noopener">More Info</a>
    	      						</cfif>
    	      					</div>
    	      				</div>
    	      			</div>
  	      			</cfoutput>
	        		</cfloop>
	      		</div>
	  			</cfcache>
	  		</div>
	  	</div>
	  </div>
  </div><!-- END i-content -->
<cfelse>
	<div class="i-content int">
		<div class="container">
			<div class="row">
				<div class="col">
          <h1>Record Not Found</h1>
          <p>Sorry, that record was not found.</p>
				</div>
			</div>
  		<cfinclude template="/components/callouts.cfm">
		</div>
  </div><!-- END i-content -->
</cfif>

<cfinclude template="/components/footer.cfm">