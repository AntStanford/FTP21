<!---
<cfset form.parentID = 556>
<cfset form.thisid = 557>
<cfset form.dir = 'up'>
--->

<!--- get current order --->
<cfquery name="getSubPages" dataSource="#settings.dsn#">
	select id, subsort from cms_pages where parentID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.parentID#"> order by subsort, id
</cfquery>

<!--- put all items in an array --->
<cfset variables.items = arraynew(1) />
<cfset i = 1 />

<cfloop query="getSubPages">
	<cfset variables.items[i] = getSubPages.id />
	<cfset i += 1 />
</cfloop>

<!--- Get the items current place --->
<cfloop from="1" to="#arraylen(variables.items)#" index="i">
	<cfif variables.items[i] is form.thisId>
		<cfset variables.currentSort = i />
		<cfbreak>
	</cfif>
</cfloop>

<!--- Re-arrange array --->
<cfif form.dir is 'up'>
	<!--- get the id of the one above (lower number) --->
	<cfset variables.above = variables.currentSort - 1 />
	<cfset variables.otherId = variables.items[variables.above]>

	<!--- Build new array, with the new order --->
	<cfset variables.updateItems = arrayNew(1) />
	<cfset variables.firstPartEnd = variables.above - 1 />
	<cfset variables.secondPartStart = variables.currentSort + 1 />

	<cfloop from="1" to="#variables.firstPartEnd#" index="i">
		<cfset variables.updateItems[i] = variables.items[i] />
	</cfloop>

	<!--- Add the record that moved up, then the one that got moved down --->
	<cfset variables.updateItems[variables.above] = form.thisId />
	<cfset variables.updateItems[variables.currentSort] = variables.otherId />

	<!--- Add the rest of the records --->
	<cfloop from="#variables.secondPartStart#" to="#arraylen(variables.items)#" index="i">
		<cfset variables.updateItems[i] = variables.items[i] />
	</cfloop>

<cfelse><!--- down --->

	<!--- get the id of the one below (higher number) --->
	<cfset variables.below = variables.currentSort + 1 />
	<cfset variables.otherId = variables.items[variables.below]>

	<!--- Build new array, with the new order --->
	<cfset variables.updateItems = arrayNew(1) />
	<cfset variables.firstPartEnd = variables.currentSort - 1 />
	<cfset variables.secondPartStart = variables.currentSort + 2 />

	<cfloop from="1" to="#variables.firstPartEnd#" index="i">
		<cfset variables.updateItems[i] = variables.items[i] />
	</cfloop>

	<!--- Add the record that moved up, then the one that got moved down --->
	<cfset variables.updateItems[variables.currentSort] = variables.otherId />
	<cfset variables.updateItems[variables.below] = form.thisId />

	<!--- Add the rest of the records --->
	<cfloop from="#variables.secondPartStart#" to="#arraylen(variables.items)#" index="i">
		<cfset variables.updateItems[i] = variables.items[i] />
	</cfloop>

</cfif>

<!--- loop through the array, updating all the subsort values --->
<cfloop from="1" to="#arrayLen(variables.updateItems)#" index="i">
	<cfquery datasource="#settings.dsn#">
		UPDATE 	cms_pages 
		SET 	subsort = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#"> 
		WHERE 	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#variables.updateItems[i]#">
	</cfquery>
</cfloop>

