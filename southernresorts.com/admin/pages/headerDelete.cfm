<cfif isdefined('url.id')>
  <cfquery name="getPropInfo" dataSource="#application.dsn#">
  SELECT *
  FROM cms_pages
  WHERE id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>
	<cfif getPropInfo.headerimage neq ''>
      <cffile action="delete" file="e:\inetpub\wwwroot\domains\#cgi.http_host#\htdocs\images\header\#getPropInfo.headerimage#">
      <cfquery datasource="#application.dsn#">
      UPDATE cms_pages
      SET headerimage = ''
      WHERE id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
      </cfquery>
  </cfif>
</cfif>