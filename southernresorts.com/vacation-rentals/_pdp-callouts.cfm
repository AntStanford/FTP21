<cfquery name="getCallouts" dataSource="#settings.dsn#">
  select id,title,description,photo,link
  from cms_callouts
  order by sort
</cfquery>


<cfquery name="getDest" datasource="#settings.dsn#">
	select id,title from cms_destinations where nodeid = <cfif property.typeid3 EQ 3 ><cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#property.nodeid3#"><cfelseif property.typeid EQ 3 ><cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#property.nodeid#"><cfelse><cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#property.nodeid2#"></cfif>
		</cfquery>
	
	
	<cfquery name="getDestinationCallOuts" datasource="#settings.dsn#">
	SELECT Title, Description, Photo,link
	FROM cms_destinations_callouts
	WHERE destination_id = <cfif property.typeid3 EQ 3 ><cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#property.nodeid3#"><cfelseif property.typeid2 EQ 3><cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#property.nodeid2#">
		<cfelse> <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#property.nodeid#"> </cfif>
	</cfquery>
      <div class="row pdp-experience">
	    		<div class="col-lg-12">
						<div class="travel-callout-wrap"></div>
					<p class="h1 h1-header site-color-3">Experience <cfoutput>#getDest.title#</cfoutput></p>
	    		</div>
	    		<div class="experience-listings">
  <cfloop query="getDestinationCallOuts">
    <cfif Len(getDestinationCallOuts.Title)>
	    <cfif findnocase('http',link)>
		    <cfset newLink = link />
		  <cfelse>
		    <cfif cgi.server_name eq settings.devURL>
		      <cfset newLink = "http://#settings.devURL#/#link#" />
		    <cfelse>
		      <cfset newLink = "http://#settings.website#/#link#" />
		    </cfif>
		  </cfif>
	    <a href="<cfoutput>#newlink#</cfoutput>" target="_blank">
	    <div class="col-xs-12 col-sm-3 experience-listing">
          <img src="<cfif Len('getdestinationcallouts.photo')>/images/callouts/<cfoutput>#getDestinationCallOuts.Photo#</cfoutput><cfelse>//via.placeholder.com/728x90.png?text=</cfif>" >
          <div class="pdp-callout-text">
              <div class="h4 callout-category"><cfoutput>#getDestinationCallOuts.Title#</cfoutput></div>
          <div class="h5 callout-subtext"><cfoutput>#getDestinationCallOuts.Description#</cfoutput></div>
	      </div>
	    </div>
	    </a>
    </cfif>
  </cfloop>
</div>
<!--END experience-listings-->
	    		

	    	</div><!--END pdp-experience-->
     