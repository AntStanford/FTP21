<!--- Flush the cache if it exists --->
<cftry> 
     <cfcache action="flush" key="cms_testimonials">
     <cfcatch></cfcatch> 
</cftry>

<cfset table = 'cms_testimonials'>

<cfif isdefined('url.id') and isdefined('url.delete')> <!--- delete statement --->
	
  <cfquery dataSource="#application.dsn#">
  	delete from #table# where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#"> 
  </cfquery>
  
  <cflocation addToken="no" url="index.cfm?success">
  	
<cfelseif isdefined('form.id')> <!--- update statement --->
  
  <cfquery dataSource="#application.dsn#">
    update #table# set 
    user = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.user#">,
    body = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.body#">
    where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">
  </cfquery>  
  
  <cflocation addToken="no" url="form.cfm?id=#form.id#&success">

<cfelse>  <!---insert statement--->
  
  <cfquery dataSource="#application.dsn#">
    insert into #table#(user,body) 
    values(<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#user#">,<cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#body#">)
  </cfquery>
  
  <cflocation addToken="no" url="form.cfm?success">
  
</cfif>