<!--- On page variables --->
<cfset table = 'guest_loyalty_manual_points'>

<cfif form.labelOther neq ''>
	<cfset label = form.labelOther>
</cfif>

<cfquery datasource="#dsn#">
	INSERT INTO guest_loyalty_manual_points (PointsToAdd, email, comments, label)
	VALUES(
	<cfqueryparam CFSQLType="CF_SQL_NUMERIC" value="#form.PointsToAdd#">,
	<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#email#">,
	<cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#comments#">,
	<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#label#">
	)
</cfquery>

<cflocation addToken="no" url="view-points.cfm?email=#email#&successAddingPoints">
