<!--- Flush the cache if it exists --->
<cftry>
     <cfcache action="flush" key="cms_amenities">
     <cfcatch></cfcatch>
</cftry>

<!--- On page variables --->
<cfset table = 'cms_amenities'>

<!--- Delete --->
<cfif isdefined('url.id') and isdefined('url.delete')>

  <cfquery dataSource="#dsn#">
    delete from cms_amenities where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>

  <cflocation addToken="no" url="index.cfm?delete">

</cfif>





