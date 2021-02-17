<!--- On page variables --->
<cfset table = 'guest_loyalty_redeem_points'>

<cfquery datasource="#dsn#">
    INSERT INTO guest_loyalty_redeem_points (pointsRedeemed,email,comments,property,userid,reason)
    VALUES(
		<cfqueryparam CFSQLType="CF_SQL_NUMERIC" value="#form.pointsRedeemed#">,
		<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#email#">,
		<cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#comments#">,
		<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.property#">,
		<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#session.loggedInUserStruct.LoggedInID#">,
		<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.reason#">
	)
</cfquery>

<cflocation addToken="no" url="view-points.cfm?email=#email#&successRedeemingPoints">
