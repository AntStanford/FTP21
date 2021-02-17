<cfparam name="url.categoryid" default="">
<cfparam name="url.id" default="0">
<cfparam name="variables.thingsToDo" default="">

<cfquery name="getSubCategories" datasource="#dsn#">
SELECT * 
FROM cms_thingstodo_subcategories
WHERE categoryid=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.categoryid#">
ORDER BY title
</cfquery>

<cfquery name="getThingToDo" datasource="#dsn#">
SELECT subcatIDs
FROM cms_thingstodo
WHERE id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
</cfquery>
<cfoutput query="getThingToDo">
	<cfset variables.thingsToDo = getThingToDo.subcatIDs>
</cfoutput>

<cfoutput>
<cfloop query="getSubcategories">
<input type="checkbox" name="subcatIDs" value="#id#" <cfif ListFind(variables.thingsToDo,id)>checked="checked"</cfif>> #title# &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</cfloop>
</cfoutput>