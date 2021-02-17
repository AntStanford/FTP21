<cfset table = 'cms_training_videos'>

<cfif isdefined('url.id') and isdefined('url.delete')> <!--- delete statement --->

  <cfquery dataSource="booking_clients">
    delete from cms_training_videos where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>

  <cflocation addToken="no" url="index.cfm?success">

<cfelseif isdefined('form.id')> <!--- update statement --->

  <cfquery dataSource="booking_clients">
    update cms_training_videos set
    title = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.title#">,
    description = <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.description#">,
	link = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.link#">
    where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">
  </cfquery>

  <cflocation addToken="no" url="form.cfm?id=#form.id#&success">

<cfelse>  <!---insert statement--->

  <!--- Get current sort values --->
  <cfquery name="getSort" dataSource="booking_clients">
    select max(sort) as maxSort from cms_training_videos
  </cfquery>

  <cfif getSort.recordcount gt 0 and len(getSort.maxSort)>
    <cfset sortValue = getSort.maxSort + 1>
  <cfelse>
    <cfset sortValue = 1>
  </cfif>

  <cfquery dataSource="booking_clients">
    insert into cms_training_videos(title,link,description,sort)
    values(
	  <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#title#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#link#">,
      <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#description#">,
      <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#sortValue#">
      )
  </cfquery>

  <cflocation addToken="no" url="form.cfm?success">

</cfif>