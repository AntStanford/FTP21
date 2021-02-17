<cfif StructKeyExists(session,'booking')>
    <cfset structClear(session.booking)>
</cfif>

<cfif isdefined('url.area')>

    <cfquery name="getAreaIdName" dataSource="#settings.dsn#">
        SELECT id, name FROM cms_reunions_retreats_locations WHERE slug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.area#">
    </cfquery>

    <cfquery name="getPropertyId" dataSource="#settings.dsn#">
        SELECT propertyID FROM cms_reunions_retreats WHERE AreaID = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getAreaIdName.id#">
    </cfquery>

    <!--- We're setting the area in the session for the search-params feature... --->
    <cfset session.booking.area = getAreaIdName.name>

    <!--- <cfset session.booking.reunions_retreats = ValueList(getPropertyId.propertyID)> --->

    <cflocation addToken="no" url="/vacation-rentals/results.cfm">

</cfif>
