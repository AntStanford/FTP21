<cfset table = 'cms_featured_properties'>

<cfif isdefined('url.propertyid')>

   <cfquery name="propCheck" dataSource="#settings.dsn#">
      select strpropid from cms_featured_properties where strpropid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.propertyid#">
   </cfquery>

   <!--- property exists, delete it --->
   <cfif propCheck.recordcount gt 0>

      	<cfquery name="Delete" datasource="#settings.dsn#">
      		delete from cms_featured_properties
      		where strpropid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.propertyid#">
      	</cfquery>

   <cfelse>

         <!--- property does not exist, add it --->
      	<cfquery dataSource="#settings.dsn#">
      		insert into cms_featured_properties (strpropid)
      		values(<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.propertyid#">)
      	</cfquery>

   </cfif>

</cfif>