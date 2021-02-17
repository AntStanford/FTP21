<!--- On page variables --->
<cfset table = 'guest_loyalty_point_value'>

<cfquery dataSource="#application.dsn#">
	update guest_loyalty_point_value set
	pointvalue = <cfqueryparam CFSQLType="CF_SQL_NUMERIC" value="#form.pointvalue#">
	where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">
</cfquery>

<cflocation addToken="no" url="index.cfm?id=#id#&success">