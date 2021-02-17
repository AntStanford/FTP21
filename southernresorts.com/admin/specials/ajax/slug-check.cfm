<!--- <cfsetting enablecfoutputonly="true"> --->

<!--- This checks if a slug exists.  Returns 1 if it does, 0 if it does not --->
<cfparam name="url.slug" default="">

<cfif trim(url.slug) is '' or trim(url.slug) is 'undefined'>
	<!--- Return true if the slug is blank --->
	<cfset variables.retVal = 1 />
<cfelse>
	<!--- Check if the slug exists --->
	<cfquery name="getPagesSlug" dataSource="#application.dsn#">
		SELECT id FROM cms_pages WHERE slug = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.slug#">
	</cfquery>

	<cfquery name="getSpecialsSlug" dataSource="#application.dsn#">
		SELECT id FROM cms_specials WHERE slug = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.slug#">
	</cfquery>
	
	<cfif getPagesSlug.recordcount gt 0 or getSpecialsSlug.recordcount gt 0>
		<cfset variables.retVal = 1 />
	<cfelse>
		<cfset variables.retVal = 0 />
	</cfif>
</cfif>

<cfoutput>#variables.retVal#</cfoutput>