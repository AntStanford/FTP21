<cfset table = 'guest_loyalty_point_levels'>

<cfif isdefined('url.id') and isdefined('url.delete')> <!--- delete statement --->

	<cfquery dataSource="#application.dsn#">
    	delete from guest_loyalty_point_levels where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  	</cfquery>

  	<cflocation addToken="no" url="index.cfm?success">

<cfelseif isdefined('form.id')> <!--- update statement --->

  <cfquery dataSource="#application.dsn#">
    update guest_loyalty_point_levels set
    title = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.title#">,
    points = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.points#">
    where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">
  </cfquery>

  <cflocation addToken="no" url="form.cfm?id=#form.id#&success">

<cfelse>  <!---insert statement--->

  <cfquery dataSource="#application.dsn#">
    insert into guest_loyalty_point_levels(title,points)
    values(
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.title#">,
      <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.points#">
    )
  </cfquery>

  <cflocation addToken="no" url="form.cfm?success">

</cfif>