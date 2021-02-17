<cfparam name="url.sortOrder" type="string">

<cfset order = 0>

<cfloop list="#url.sortOrder#" index="item">
	
	<cfset sort_id = Val(ListLast(item, "_"))>
	
	<cfset order = order+1>
	
	<!--- change table name as needed per site specs --->
	<cfquery dataSource="#dsn#">
		UPDATE cms_assets
		SET sort = <cfqueryparam value="#order#" cfsqltype="cf_sql_integer">
		WHERE id = <cfqueryparam value="#sort_id#" cfsqltype="cf_sql_integer">
		and section = 'Long Term Rental'
	</cfquery>
		
</cfloop>