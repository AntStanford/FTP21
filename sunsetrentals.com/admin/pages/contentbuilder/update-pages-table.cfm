<cfabort>

<cfquery name="getPages" dataSource="#settings.dsn#">
  select * from cms_pages order by name
</cfquery>

<cfloop query="getPages">
  <cfoutput>
    <p>#name#</p>
  </cfoutput>
  <cfsavecontent variable="newbody">
    <cfoutput>#getPages.body#</cfoutput>
  </cfsavecontent>
  <cfquery dataSource="#settings.dsn#">
    update cms_pages set `body` = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#newbody#">
    where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getPages.id#">
  </cfquery>
</cfloop>
...done