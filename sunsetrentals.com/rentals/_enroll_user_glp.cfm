<!--- First let's check and see if they are already enrolled. --->
<cfquery name="userCheck" dataSource="#settings.dsn#">
	select id,password 
	from guest_focus_users where email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">
</cfquery>

<cfif userCheck.recordcount gt 0>
	
	<!--- User already exists - send them a follow up email --->
	<cfsavecontent variable="welcomeglp">
		<cfoutput>
		<cfinclude template="/components/email-template-top.cfm">
		<p><b>Hi #form.firstname#, </b></p>
		<p>You recently indicated that you wanted to opt-into our Guest Loyalty Program but it looks like you already have an account with us.</p>
		<p>Use the link below to log into the Guest Loyalty app.</p>
		<p><a href="http://#cgi.http_host#/guest-focus/index.cfm">Click here to login now!</a></p>
		<p>In case you forgot, your login info is below:</p>
		<p>
			Email: #form.email#<br />
			Password: #userCheck.password#<br />
		</p>
		<cfinclude template="/components/email-template-bottom.cfm">
		</cfoutput>
	</cfsavecontent>
	
	<cfset sendEmail(form.email,welcomeglp,"Guest Loyalty Program - Follow Up")>
	
<cfelse>
	
	<!---
	User does not exist:	
	- auto create password and send them welcome email
	--->
	
	<cftry>
	
		<cfset newPassword = randString('alphanum',8)>
		
		<cfquery dataSource="#settings.dsn#">
			insert into guest_focus_users(firstname,lastname,email,phone,address,city,state,zip,password) 
			values(
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.firstname#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.lastname#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.phone#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.address1#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.city#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.state#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.zip#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#newPassword#">
			)
		</cfquery>
		
		<cfsavecontent variable="welcomeglp">
			<cfoutput>
			<cfinclude template="/components/email-template-top.cfm">
			<p><b>Hi #form.firstname#, welcome to the #settings.company# Guest Loyalty Program!</b></p>
			<p>Use the link below to log into the Guest Loyalty app.</p>
			<p><a href="http://#cgi.http_host#/guest-focus/index.cfm">Click here to login now!</a></p>
			<p>To gain access, use the following info:</p>
			<p>
				Email: #form.email#<br />
				Password: #newPassword#<br />
			</p>
			<cfinclude template="/components/email-template-bottom.cfm">
			</cfoutput>
		</cfsavecontent>
		
		<cfset sendEmail(form.email,welcomeglp,"Welcome to the #settings.company# Guest Loyalty Program!")>
	
	<cfcatch>
		
		<cfif isdefined("ravenClient")>
			<cfset ravenClient.captureException(cfcatch)>
		</cfif>
		
	</cfcatch>
	
	</cftry>
	
</cfif>
