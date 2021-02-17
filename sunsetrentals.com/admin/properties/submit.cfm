<cfset table = 'cms_property_enhancements'>

<cfif isdefined('form.id')> <!--- update statement --->

	<cfquery name="Delete" datasource="#application.dsn#">
		Delete from cms_property_enhancements
		Where strpropid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.id#">
	</cfquery>

	<cfquery dataSource="#application.dsn#">
		insert into cms_property_enhancements (strpropid,virtualTour,videolink)
		values(
			<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.id#">,
			<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.virtualTour#">,
			<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.videolink#">
		)
	</cfquery>

	<cfquery name="qry_Property" datasource="#application.dsn#">
		SELECT shortName 
		  FROM track_properties
		 WHERE id = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.id#">
	</cfquery>

	<cflocation addToken="no" url="form.cfm?id=#url.id#&success&name=#qry_Property.shortName#">

</cfif>