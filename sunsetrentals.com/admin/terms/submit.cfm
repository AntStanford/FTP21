<cfif isdefined('form.submit')>
	
	<cfquery dataSource="#application.dsn#">
		update cms_terms set terms = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.terms#">
		where id = 1
	</cfquery>
	
	<cflocation addToken="no" url="form.cfm?success">
	
</cfif>