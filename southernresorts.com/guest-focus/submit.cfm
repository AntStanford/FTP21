<!--- User is attempting to log into guest focus --->
<cfif isdefined('form.action') and form.action eq 'login'>

	<cfif form.email neq '' and form.password neq ''>

		<cfquery name="loginQuery" dataSource="#settings.dsn#">
			select id,firstname,lastname from guest_focus_users where email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">
			and password = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.password#">
			and activated = 'yes'
		</cfquery>

		<cfif loginQuery.recordcount gt 0>

			<cfcookie name="GuestFocusLoggedInID" value="#loginQuery.id#">
			<cfcookie name="GuestFocusLoggedInEmail" value="#form.email#">
			<cfcookie name="GuestFocusLoggedInName" value="#loginQuery.firstname# #loginQuery.lastname#">

        <cfquery dataSource="#settings.dsn#">
          update guest_focus_users set lastLoggedIn = now() where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#loginQuery.id#">
        </cfquery>

			<cflocation addToken="no" url="dashboard.cfm">

		<cfelse>

			<cflocation addToken="no" url="index.cfm?error=user">

		</cfif>

	<cfelse>

		<cflocation addToken="no" url="index.cfm?error=form">

	</cfif>


<!--- User is attempting to create a new guest focus account --->
<cfelseif isdefined('form.action') and form.action eq 'createaccount'>

	<!--- Check and make sure this account does not already exist --->
	<cfquery name="dupUserCheck" dataSource="#settings.dsn#">
		select ID from guest_focus_users where email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">
	</cfquery>

	<cfif dupUserCheck.recordcount gt 0>

		<cflocation addToken="no" url="index.cfm?error=dup">

	<cfelse>

		<cfset token = randString('alphanum',36)>

		<cfif isdefined('form.optin') and form.optin eq 'Yes'>
			<cfset userOptin = 'Yes'>
		<cfelse>
			<cfset userOptin = 'No'>
		</cfif>

		<cfquery dataSource="#settings.dsn#">
			insert into
			guest_focus_users(firstname,lastname,email,password,token,optin)
			values(
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#firstname#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#lastname#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#email#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#password#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#token#">,
				<cfqueryparam CFSQLType="CF_SQL_CHAR" value="#userOptin#">
			)
		</cfquery>

	</cfif>

	<!--- send confirmation email --->
	<cfsavecontent variable="emailbody">
	<cfoutput>
	<p>Hello #form.firstname#!</p>
	<p>Please click the link below to confirm your account on #settings.website#</p>
	<p><a href="http://cms2.icnd.net/guest-focus/activate.cfm?token=#token#">Verify Your Email Address</a></p>
	</cfoutput>
	</cfsavecontent>

	<cfset sendEmail(form.email,emailbody,"Please confirm your account with #cgi.http_host#","","","patriciah@gosouthern.com")>

	<cflocation addToken="no" url="index.cfm?confirmaccount">

	<!---
	- associate users favs with this account
	- send welcome email
	- force them to authenticate with email link before logging in?
	--->


<!--- User is attempting to update their guest focus profile --->
<cfelseif isdefined('form.action') and form.action eq 'updateprofile'>

	<cfquery dataSource="#settings.dsn#">
		update guest_focus_users set
		firstname = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.firstname#">,
		lastname = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.lastname#">,
		phone = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.phone#">,
		address = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.address#">,
		city = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.city#">,
		state = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.state#">,
		zip = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.zip#">,
		`password` = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.password#">
		where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#cookie.GuestFocusLoggedInID#">
	</cfquery>

	<cflocation addToken="no" url="profile.cfm?success">


<!--- User is attempting to send a question to the PM via guest focus --->
<cfelseif isdefined('form.action') and form.action eq 'sendquestiontopm'>

	<cfsavecontent variable="emailbody">
	<cfoutput>
	<p>
	<b>Subject:</b> #form.subject#<br />
	<b>Comments:</b> #form.comments#
	</p>
	<p><small><i>This email was submitted from the Guest Focus contact form.</i></small></p>
	</cfoutput>
	</cfsavecontent>

	<cfset sendEmail(settings.clientEmail,emailbody,"Question from #cookie.GuestFocusLoggedInName#")>

	<cflocation addToken="no" url="send-questions-to-pm.cfm?success">


<!--- User is attempting to send the list of favs to a friend via guest focus --->
<cfelseif isdefined('form.action') and form.action eq 'sendFavsToFriend'>

	<cfquery name="getFavs" dataSource="#settings.dsn#">
		select propertyid from guest_focus_favs where userid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#cookie.GuestFocusLoggedInID#">
	</cfquery>

		<cfsavecontent variable="emailbody">
	   <cfoutput>
		<cfinclude template="/components/email-template-top.cfm">
		<table>

			<cfloop query="getFavs">

				<cfset property = application.bookingObject.getProperty(getFavs.propertyid)>

				<tr>
					<td align="left" valign="top"><img src="https://img.trackhs.com/200x150/#property.defaultPhoto#" align="left" width="200" height="150" border="0" style="padding-right:10px"></td>
					<td valign="top">
						<p style="font-family:'Helvetica Neue', helvetica, alrial, sans-serif; font-size:20px; color:##878a93;"><a href="http://#cgi.http_host#/#settings.booking.dir#/#property.seoPropertyName#/#getFavs.propertyid#">Click here to view #property.name#</a></p>
					</td>
				</tr>

			</cfloop>

		</table>
		<cfinclude template="/components/email-template-bottom.cfm">
		</cfoutput>
	</cfsavecontent>

	<cfset sendEmail(form.friendsemail,emailbody,"Check out these properties I found on #cgi.http_host#",form.youremail,"","patriciah@gosouthern.com")>

	<cflocation addToken="no" url="dashboard.cfm?success">




<!--- User is attempting to submit the 'request to redeem points' form --->
<cfelseif isdefined('form.action') and form.action eq 'requestToRedeemPoints'>

	<cfsavecontent variable="emailbody">
   <cfoutput>
	<cfinclude template="/components/email-template-top.cfm">
	<p>
		Name: #cookie.GuestFocusLoggedInName#<br />
		Email: #cookie.GuestFocusLoggedInEmail#<br />
		Arrival Date: #form.ArrivalDate#<br />
		Departure Date: #form.DepartureDate#<br />
		Pet Friendly: #form.PetFriendly#<br />
		Number of guests in party: #form.NumberOfGuests#<br />
		Reason: #form.reason#<br />
	</p>
	<cfinclude template="/components/email-template-bottom.cfm">
	</cfoutput>
	</cfsavecontent>

	<cfset sendEmail(settings.clientEmail,emailbody,"Request to Redeem Points",cookie.GuestFocusLoggedInEmail)>

	<!--- Insert request into the db --->
	<cfquery dataSource="#settings.dsn#">
		insert into
			guest_loyalty_redemption_request(GuestID,GuestName,GuestEmail,ArrivalDate,DepartureDate,PetFriendly,NumberofGuests,reason)
			values(
				<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#cookie.GuestFocusLoggedInID#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cookie.GuestFocusLoggedInName#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cookie.GuestFocusLoggedInEmail#">,
				<cfqueryparam CFSQLType="CF_SQL_DATE" value="#form.arrivalDate#">,
				<cfqueryparam CFSQLType="CF_SQL_DATE" value="#form.departureDate#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.PetFriendly#">,
				<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.NumberOfGuests#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.reason#">
			)
	</cfquery>

	<cflocation addToken="no" url="guest-loyalty.cfm?success">


<!--- User has forgotten their password and wants to reset it --->
<cfelseif isdefined('form.action') and form.action eq 'forgotPassword'>

	<!--- First, try and find the user --->
	<cfquery name="getUser" dataSource="#settings.dsn#">
		select ID from guest_focus_users where email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">
	</cfquery>

	<cfif getUser.recordcount gt 0>

		<!--- First, generate a new, temporary token --->
		<cfset tempToken = randString('alphanum',36)>

		<cfquery dataSource="#settings.dsn#">
			update guest_focus_users set token = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#tempToken#">
			where email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">
		</cfquery>

	   <cfsavecontent variable="emailbody">
		<cfoutput>
		<cfinclude template="/components/email-template-top.cfm">
		<p>You have requested a new password with #cgi.http_host#; please click the link below to reset your password:</p>
		<p><a href="http://#cgi.http_host#/guest-focus/reset-password.cfm?token=#tempToken#">Reset My Password</a></p>
		<cfinclude template="/components/email-template-bottom.cfm">
		</cfoutput>
		</cfsavecontent>

		<cfset sendEmail(form.email,emailbody,"Password Reset from #cgi.http_host#","","","patriciah@gosouthern.com")>

	</cfif>

</cfif>




