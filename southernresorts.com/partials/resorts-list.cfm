<cfif isDefined ("page")>
	<cfset customSearchJsonStruct = DeserializeJson(page.customsearchJson)/>
</cfif>

<cfquery name="getInfo" dataSource="#settings.dsn#">
	select *, (SELECT original FROM track_nodes_images WHERE nodeid = southernresorts.track_nodes.id LIMIT 1) as resortimage from southernresorts.track_nodes where typeName = 'Complex/Neighborhood'
	AND id in (select nodeid from track_properties)

	<cfif isDefined("customSearchJsonStruct") and structKeyExists(customSearchJsonStruct, "RESORTS")>
		AND id in (<cfqueryparam list="true" value="#customSearchJsonStruct.RESORTS#" cfsqltype="cf_sql_integer" />)
	</cfif>

	order by name
</cfquery>



<!---
<cfquery name="getinfo" dataSource="#settings.dsn#">
	select * from cms_resorts_old order by name
</cfquery>
--->

<!---
<cfquery name="getinfo" dataSource="#settings.dsn#">
	select * from cms_resorts order by name
</cfquery>
--->

<cfoutput query="getInfo">
	<cfset Resname = reReplace(name, "[[:space:]]", "", "ALL") />
	<cfset Resname = replace(resname,'(','','All')>
					<cfset Resname = replace(resname,')','','All')>
	<cfset Resname = replace(resname,'&','','All')>
	<cfset Resname = replace(resname,"'","","ALL")>
	<cfset slug = Resname />
	
<!--- #name#<br> --->

<!--- #left(REReplaceNoCase(name, "<[^[:space:]][^>]*>", "", "ALL"), 195)#<br> --->

<!--- #Resname# --->
<!--- </cfoutput> --->

<div class="cms-resorts-option-2">
  <ul>
<!---     <cfloop query="getinfo"> --->
<!--- 	    <cfoutput> --->
<cfloop>
	    <li>
	      <div class="well">
	        <div class="row">
	          <div class="col-md-3 col-sm-4 col-xs-6">
		          
		          
		          <cfif isdefined('page.slug') and page.slug eq "index">
		          	<cfelse>
		          </cfif>
		          
		          
	            <cfif isdefined('resortimage')>
		          	<a href="/resort/#slug#"><img src="#resortimage#"></a>
		          <cfelse>
		          	<a href="/resort/#slug#"><img src="http://placehold.it/400x300&text=placeholder"></a>
		          </cfif>
	          </div>
	          <div class="col-md-9 col-sm-8 col-xs-6">
	            <div class="block">
	              <p class="h3"><!--- <a href="/resort/#slug#" class="site-color-1 site-color-1-lighten-hover">#name#</a> ---><a href="/resort/#Resname#" class="site-color-1 site-color-1-lighten-hover">#name#</a></p>
	              <p>#mid(shortDescription,1,200)#...</p>
	            </div>
	          </div>
	        </div>
	      </div>
	    </li>
</cfloop>
<!--- 	    </cfoutput> --->
<!---     </cfloop> --->
  </ul>
</div>
</cfoutput>