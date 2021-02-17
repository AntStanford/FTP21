<!---
  	<cfquery name="getDestination" datasource="#settings.dsn#">
		SELECT cd.id,Title, bannerImage, canonicalLink, h1, metaTitle, metaDescription, description, nodeid, t.name as locality
		FROM cms_destinations cd left JOIN track_nodes t on t.id = cd.nodeid
		
		WHERE Slug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.slug#">
		</cfquery>
		  	<cfquery name="getDestinationCallOuts" datasource="#settings.dsn#">
		SELECT Title, Description, Photo,link
		FROM cms_callouts
		WHERE destination_id = <cfif getDestination.nodeid EQ 0 ><cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getDestination.id#"><cfelse><cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getDestination.nodeid#"></cfif>
		</cfquery>
--->
<!---
	per John
	
	pull from this table SELECT * FROM southernresorts.cms_destinations_callouts;
and show where link is not the current URL for hte page
  	
--->
<style>.i-content .h5.callout-subtext p { margin: 0; }</style>
<cfquery name="getCallouts" datasource="#settings.dsn#">
		SELECT * FROM southernresorts.cms_destinations_callouts
		where title <> <cfqueryparam value='#url.dest#' cfsqltype="cf_sql_vahchar"> AND destination_id = <cfqueryparam value="#getDestinations.nodeid#" cfsqltype="cf_sql_integer">
	order by rand()
		limit 3 
		</cfquery>

<!---
<cfquery name="getGulfCoastGuide" dataSource="#settings.dsn#">
	  select *
	  from cms_gulfcoast_guide_callouts
	  order by sort
</cfquery>
--->
<div class="<cfif isdefined('slug') and slug eq "index">container-fluid gcg-callouts-home<cfelse>container </cfif>callouts-wrapper gcg-callouts-wrapper">
	<div class="row">
		<div class="col-lg-12">
		  <cfif isdefined('page.slug') and page.slug eq "index">
			  <h3 class="header-subtext">Come &amp; Explore</h3>
			  <p class="h1 h1-header site-color-3">The Gulf Coast Guide</p>
	    <cfelse>
	    <p class="h1 h1-header site-color-3">Explore <cfoutput>#getdestinations.title#</cfoutput></p>
      </cfif>
			</div>
			<cfoutput query="getCallouts">
				<div class="col-xs-12 col-sm-4 nopadding gcg-callout">
		  		<a href="/#link#" <cfif lcase(left(link,4)) is 'http'>target="_blank"</cfif>>
				  	<div class="callout-text">
			    		<div class="h5 callout-subtext">#description#</div>
			    		<div class="h4 callout-category">#title#</div>
			    	</div>
					  <img src="<!--- /images/gc-guide-callouts/#photo# --->/images/callouts/#photo#" alt="">
				  </a>
				</div>
			</cfoutput>
	</div>
</div>
