<cfset table = 'guest_focus_users'>

<cfif isdefined('url.id') and isdefined('url.delete')> <!--- delete statement --->

	<cfquery dataSource="#application.dsn#">
    	delete from guest_focus_users where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  	</cfquery>

  	<cflocation addToken="no" url="index.cfm?success">

<cfelseif isdefined('form.id')> <!--- update statement --->

  <cfquery dataSource="#application.dsn#">
		update guest_focus_users set
		firstname = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.firstname#">,
		lastname = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.lastname#">,
		email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">,
		address = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.address#">,
		city = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.city#">,
		state = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.state#">,
		zip = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.zip#">,
		password = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.password#">,
		phone = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.phone#">
		where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">
  </cfquery>

  <cflocation addToken="no" url="form.cfm?id=#form.id#&success">

<cfelse>  <!---insert statement--->

  <cfquery dataSource="#application.dsn#">
		insert into guest_focus_users(firstname,lastname,email,phone,address,city,state,zip,password)
		values(
		<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.firstname#">,
		<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.lastname#">,
		<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">,
		<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.phone#">,
		<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.address#">,
		<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.city#">,
		<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.state#">,
		<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.zip#">,
		<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.password#">
	    )
  </cfquery>

  <cflocation addToken="no" url="form.cfm?success">

</cfif>