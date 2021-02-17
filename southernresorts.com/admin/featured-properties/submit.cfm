<cfset table = 'cms_featured_properties'>

<cfif isdefined('url.propertyid')> 
   
   <cfquery name="propCheck" dataSource="#settings.dsn#">
      select strpropid from #table# where strpropid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.propertyid#">
   </cfquery>
   
   <!--- property exists, delete it --->
   <cfif propCheck.recordcount gt 0>
   
      	<cfquery name="Delete" datasource="#settings.dsn#">
      		delete from #table#
      		where strpropid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.propertyid#">
      	</cfquery>
   
   <cfelse>
         
         <!--- property does not exist, add it --->
      	<cfquery dataSource="#settings.dsn#">
      		insert into #table# (strpropid) 
      		values(<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.propertyid#">)
      	</cfquery>

   </cfif>
   
</cfif>

































