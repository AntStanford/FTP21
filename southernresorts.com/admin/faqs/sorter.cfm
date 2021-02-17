<!--- Flush the cache if it exists --->
<cftry> 
     <cfcache action="flush" key="cms_faqs">
     <cfcatch></cfcatch> 
</cftry>
<cfparam name="url.sortOrder" type="string">

<cfset order = 0>

<cfloop list="#url.sortOrder#" index="item">
	
	<cfset sort_id = Val(ListLast(item, "_"))>
	
	<cfset order = order+1>
	
	<!--- change table name as needed per site specs --->
	<cfquery dataSource="#application.dsn#">
		UPDATE cms_faqs
		SET sort = <cfqueryparam value="#order#" cfsqltype="cf_sql_integer">
		WHERE id = <cfqueryparam value="#sort_id#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfoutput>#sort_id#</cfoutput>
	
</cfloop>