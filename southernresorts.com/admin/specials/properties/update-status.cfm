<cfif isdefined('url.unitcode') and isdefined('url.specialid')>
	
	<cfquery name="propCheck" dataSource="#settings.dsn#">
		select unitcode from cms_specials_properties where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.unitcode#">
		and specialid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.specialid#">
	</cfquery>

	<cfif url.status eq true>
		<cfset myActive = 'yes'>
	<cfelse>
		<cfset myActive = 'no'>
	</cfif>
	
	<cfif propCheck.recordcount eq 0>
		
		<cfquery dataSource="#settings.dsn#">
			insert into cms_specials_properties(specialid,unitcode,active) 
			values(
				<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.specialid#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.unitcode#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#myActive#">
				) 
		</cfquery>

	<cfelse>
		
		<cfquery dataSource="#settings.dsn#">
			update cms_specials_properties set
			active = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#myActive#">
			where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.unitcode#">
			and specialid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.specialid#">
		</cfquery>
		
	</cfif>
	
</cfif>