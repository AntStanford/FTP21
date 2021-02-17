<cfset table = 'cms_alerts'>

<cfif isdefined('url.id') and isdefined('url.delete')> <!--- delete statement --->
	
  <cfquery dataSource="#application.dsn#">
  	delete from #table# where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#"> 
  </cfquery>
  
  <cflocation addToken="no" url="index.cfm?success">
  	
<cfelseif isdefined('form.id')> <!--- update statement --->
  
  <cfquery dataSource="#application.dsn#">
    update #table# set 
    heading = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.heading#">,
    subheading = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.subheading#"> 
    where id = #form.id#
  </cfquery>  
  
  <cflocation addToken="no" url="form.cfm?id=#form.id#&success">

<cfelse>  <!---insert statement--->
  
  <cfquery dataSource="#application.dsn#">
    insert into #table#(heading,subheading) 
    values(
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#heading#">,
      <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#subheading#">
      )
  </cfquery>
  
  <cflocation addToken="no" url="form.cfm?success">
  
</cfif>