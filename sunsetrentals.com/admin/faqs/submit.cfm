<!--- Flush the cache if it exists --->
<cftry>
     <cfcache action="flush" key="cms_faqs">
     <cfcatch></cfcatch>
</cftry>

<cfset table = 'cms_faqs'>

<cfif isdefined('url.id') and isdefined('url.delete')> <!--- delete statement --->

  <cfquery dataSource="#application.dsn#">
    delete from cms_faqs where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>

  <cflocation addToken="no" url="index.cfm?success">

<cfelseif isdefined('form.id')> <!--- update statement --->

  <cfquery dataSource="#application.dsn#">
    update cms_faqs set
    question = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.question#">,
    answer = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.answer#">
    where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">
  </cfquery>

  <cflocation addToken="no" url="form.cfm?id=#form.id#&success">

<cfelse>  <!---insert statement--->

  <!--- Get current sort values --->
  <cfquery name="getSort" dataSource="#dsn#">
    select max(sort) as maxSort from cms_faqs
  </cfquery>

  <cfif getSort.recordcount gt 0 and len(getSort.maxSort)>
    <cfset sortValue = getSort.maxSort + 1>
  <cfelse>
    <cfset sortValue = 1>
  </cfif>

  <cfquery dataSource="#application.dsn#">
    insert into cms_faqs(question,answer,sort)
    values(
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#question#">,
      <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#answer#">,
      <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#sortValue#">
      )
  </cfquery>

  <cflocation addToken="no" url="form.cfm?success">

</cfif>