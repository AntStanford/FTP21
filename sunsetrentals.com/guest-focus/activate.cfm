<!---
When users create an account, they are sent an email with an activation link.

That link points to this file and attempts to match the token passed in the URL string
--->

<cfif isdefined('url.token')>
	
	<cfquery name="searchForUser" dataSource="#settings.dsn#">
		select id from guest_focus_users where token = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.token#">
	</cfquery>
	
	<cfif searchForUser.recordcount gt 0>
		
		<!--- We clear out the token in case someone tries to use it later on --->
		<cfquery dataSource="#settings.dsn#">
			update guest_focus_users 
			set activated = 'Yes',token = '' 
			where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#searchForUser.id#">
		</cfquery>
		
		<!--- Now that the user has been activated, take all the units they favorited and add them to the database --->
		<cfif isdefined('cookie.favorites') and listlen(cookie.favorites)>
			<cfloop list="#cookie.favorites#" index="i">
				<cfquery dataSource="#settings.dsn#">
					insert into guest_focus_favs(propertyid,userid) 
					values(
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#i#">,
						<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#searchForUser.id#">
					)
				</cfquery>
			</cfloop>
		</cfif>
		
		<cflocation addToken="no" url="index.cfm?activated">
		
	<cfelse>
		
		<cflocation addToken="no" url="index.cfm?error=notoken">
		
	</cfif>
	
</cfif>