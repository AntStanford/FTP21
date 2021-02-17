<cfset table = 'cms_autoresponder'>

<cfif isdefined('url.id') and isdefined('url.delete')> <!--- delete statement --->
	
  <cfquery dataSource="#application.dsn#">
  	delete from #table# where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#"> 
  </cfquery>
  
  <cflocation addToken="no" url="index.cfm?success">
  
<cfelseif isdefined('form.id')> <!--- update statement --->
  
  <cfif form.active eq 1>
    <cfquery dataSource="#application.dsn#">
      update #table# set 
       active = <cfqueryparam cfsqltype="tinyint" value="0">
    </cfquery>  
  </cfif>

  <cfquery dataSource="#application.dsn#">
    update #table# set 
     subject = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.subject#">
    ,body = <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.body#">
    ,active = <cfqueryparam cfsqltype="tinyint" value="#form.active#">
    where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">
  </cfquery>  
  
  <cflocation addToken="no" url="form.cfm?id=#form.id#&success">

<cfelse>  <!---insert statement--->

  <cfif form.active eq 1>
    <cfquery dataSource="#application.dsn#">
      update #table# set 
       active = <cfqueryparam cfsqltype="tinyint" value="0">
    </cfquery>  
  </cfif>

  
  <cfquery dataSource="#application.dsn#">
    insert into #table#(subject,body,active) 
    values(
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.subject#">,
      <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.body#">,
      <cfqueryparam cfsqltype="tinyint" value="#form.active#">
      )
  </cfquery>

  
  <cflocation addToken="no" url="form.cfm?success">
  
</cfif>

































