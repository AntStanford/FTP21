<cfif isdefined('url.token')>

<cfinclude template="../guest-focus/components/header.cfm">

<div class="logo-wrap text-center">
  <img src="../guest-focus/images/layout/icnd-logo.png">
</div>

<div class="login-wrap" style="padding:16px">
	
	<!--- User has forgotten their password and requested a new one--->
			
	<cfquery name="searchForUser" dataSource="#settings.dsn#">
		select id from guest_focus_users where token = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.token#">
		and activated = 'yes'
	</cfquery>
	
	<cfif searchForUser.recordcount gt 0>
		
		<cfset newPassword = randString('alphanum',8)>
		
		<!--- Update the user's password and reset the token so it can't be used later on --->
		<cfquery dataSource="#settings.dsn#">
			update guest_focus_users set `password` = '#newPassword#', token = '' 
			where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#searchForUser.id#">
		</cfquery>
				
		<p>Your new password is: <b><cfoutput>#newPassword#</cfoutput></b></p>
		
		<p>Please write that down and record it in a safe location; click the link below to login.</p>
		
		<p><a href="index.cfm" class="btn btn-info btn-block">Log Me In</a></p>
		
	<cfelse>
		
		<p>Sorry, we could not find your account.</p>
		
	</cfif>	

</div>

<cfinclude template="../guest-focus/components/footer.cfm">

</cfif>