<cfif isdefined('url.unitcode') and isdefined('url.specialid')>
	
	<cfquery name="propCheck" dataSource="#settings.dsn#">
		select unitcode from cms_specials_properties where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.unitcode#">
	</cfquery>
	
	<cfif propCheck.recordcount eq 0>
		
		<cfquery dataSource="#settings.dsn#">
			insert into cms_specials_properties(specialid,unitcode,pricewas,pricereducedto) 
			values(
				<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.specialid#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.unitcode#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.pricewas#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.priceis#">
				) 
		</cfquery>
		
	<cfelse>
		
		<cfquery dataSource="#settings.dsn#">
			update cms_specials_properties set
			pricewas = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.pricewas#">,
			pricereducedto = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.priceis#">
			where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.unitcode#">
			and specialid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.specialid#">
		</cfquery>
		
	</cfif>
	
</cfif>