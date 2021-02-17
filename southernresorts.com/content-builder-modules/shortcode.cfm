<cfif isdefined('url.scodeID') and LEN(url.scodeID) and isValid('Integer', url.scodeID)>
	<cfquery datasource="#settings.dsn#" name="getModuleInfo">
		Select includeFile,externalID
		From cms_shortcodes
		Where id = <cfqueryparam value="#url.scodeID#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfif isdefined('getModuleInfo.includeFile') and LEN(getModuleInfo.includeFile)>
		<cfset variables.thisexternalID = getModuleInfo.externalID>
		<cfinclude template="#getModuleInfo.includeFile#">
	</cfif>
</cfif>