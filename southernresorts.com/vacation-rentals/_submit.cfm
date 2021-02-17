<cfset Cffp = CreateObject("component","cfformprotect.cffpVerify").init() />

<cfif Cffp.testSubmission(form)>


<!---START: reminder to return and book property--->
   <cfif isdefined('form.ReturnAndBookReminder')>

   		<cfquery dataSource="#settings.dsn#">
         insert into cms_remindtobook(ReminderEmail,ReminderHours,SendAt,ReminderURL,propertyId,propertyName,CameFrom<cfif isdefined('CameFrom') and CameFrom is "Checkout">,strCheckin,strCheckout<cfif IsDefined('form.BookingValue') AND Len(form.BookingValue)>,BookingValue</cfif></cfif>)
         values(
		 	<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.ReminderEmail#">,
			<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.ReminderHours#">,
			DATE_ADD(NOW(), INTERVAL #ReminderHours# HOUR),
			<cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.ReminderURL#">,
            <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.propertyId#">,
			<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.propertyName#">,
			<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.CameFrom#">
			<cfif isdefined('CameFrom') and CameFrom is "Checkout">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.strCheckin#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.strCheckout#">
                <cfif IsDefined('form.BookingValue') AND Len(form.BookingValue)>
		            ,<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.BookingValue#">
                </cfif>
			</cfif>
            )
      </cfquery>

	  	<cflocation url="#ReminderURL#&ReminderHours=#ReminderHours#" addtoken="No">

   </cfif>
   <!---END: reminder to return and book property--->


   <!---START: store quote from the property detail page--->
   <cfif isdefined('form.requestQuoteForm')>

      <cfquery dataSource="#settings.ltDSN#">
         insert into lt_quotes(siteID,comments,camefrom,propertyid,mapphoto,total,SpecialistEmail,SpecialistName,QuoteNumber,LeadEmail<cfif isdefined('form.strCheckin') and LEN('form.strCheckin') and IsDate(form.strCheckin)>,arrivaldate</cfif><cfif isdefined('form.strCheckout') and LEN('form.strCheckout') and IsDate(form.strCheckout)>,departuredate</cfif>)
         values(
            <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#settings.id#">,
            <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.comments#">,
            <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.camefrom#">,
            <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.unitcode#">,
            <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.mapPhoto#">,
            <cfqueryparam CFSQLType="CF_SQL_DOUBLE" value="#form.total#">,
            <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.SpecialistEmail#">,
            <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.SpecialistName#">,
            <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.QuoteNumber#">,
            <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.LeadEmail#">
            <cfif isdefined('form.strCheckin') and LEN('form.strCheckin') and IsDate(form.strCheckin)>,<cfqueryparam value="#form.strCheckin#" cfsqltype="cf_sql_date"></cfif>
            <cfif isdefined('form.strCheckout') and LEN('form.strCheckout') and IsDate(form.strCheckout)>,<cfqueryparam value="#form.strCheckout#" cfsqltype="cf_sql_date"></cfif>
         )
      </cfquery>

   </cfif>
   <!---END: store quote from the property detail page--->


	<!--- Contact form on property detail page --->
	<cfif isdefined('form.requestMoreInfoForm')>

		<!--- Google reCaptcha starts ---->
      <cfset recaptcha = "">
      <cfif structKeyExists(FORM,"g-recaptcha-response")>
        <cfset recaptcha = FORM["g-recaptcha-response"]>
      </cfif>
	   <cfset isHuman = false>

		<cfif len(recaptcha)>

			<!--- POST to google and verify submission --->
			<cfset googleUrl = "https://www.google.com/recaptcha/api/siteverify">
			<cfset secret = settings.google_recaptcha_secretkey>
			<cfset ipaddr = CGI.REMOTE_ADDR>
			<cfset request_url = googleUrl & "?secret=" & secret & "&response=" & recaptcha & "&remoteip" & ipaddr>

			<cfhttp url="#request_url#" method="get" timeout="10">

			<cfset response = deserializeJSON(cfhttp.filecontent)>
			<cfif response.success eq "true">
				<cfset isHuman = true>
			</cfif>
		</cfif>
		<!--- Google reCaptcha ends --->

		<cfif isHuman is true>
			<cfif len(form.email)>
				<cfset variables.encEmail = encrypt(form.email, application.contactInfoEncryptKey, 'AES')>
			<cfelse>
				<cfset variables.encEmail = ''>
			</cfif>

			<cfif len(form.phone)>
				<cfset variables.encPhone = encrypt(form.phone, application.contactInfoEncryptKey, 'AES')>
			<cfelse>
				<cfset variables.encPhone = ''>
			</cfif>

			<cfsavecontent variable="emailbody">
			<cfoutput>
			<cfinclude template="/components/email-template-top.cfm">
			<p>Property: #form.property_name#</p>
			<p>Property ID: #form.property_id#</p>
			<p>First Name: #firstname#</p>
			<p>Last Name: #lastname#</p>
			<p>Email: #email#</p>
			<cfif isdefined('phone') and LEN(phone)><p>Telephone: #phone#</p></cfif>
			<p>Comments: #comments#</p>
			<cfif isdefined('form.hiddenstrcheckin') and len(form.hiddenstrcheckin)>
				<p>Arrival Date: #form.hiddenstrcheckin#</p>
			</cfif>
			<cfif isdefined('form.hiddenstrcheckout') and len(form.hiddenstrcheckout)>
				<p>Departure Date: #form.hiddenstrcheckout#</p>
			</cfif>
<!---
			<cfif isdefined('form.optin') and form.optin eq 'Yes'>
				<p>Opt-in: Yes</p>
			<cfelse>
				<p>Opt-in: No</p>
			</cfif>
--->
			<cfinclude template="/components/email-template-bottom.cfm">
			</cfoutput>
			</cfsavecontent>

			<cfif settings.environment EQ "production">
				<cfset toEmail = 'svr-cpdqjliyw@email.trackhs.com'>
			<cfelse>
				<cfset toEmail = 'svr-cpdqjliyw@email.trackhs.com'>
			</cfif>

			<cfset sendEmail("#toEmail#",emailbody,"New contact from #cgi.http_host# about #form.property_name#","","","patriciah@gosouthern.com")>
			
			<cfset autoresponderTo = "matticnd@gmail.com">
			<cfinclude template="/components/autoresponder.cfm">

			<!--- <cfif isdefined('form.optin') and form.optin eq 'Yes'> --->

				<cfquery dataSource="#settings.dsn#">
					insert into cms_contacts(optin,firstname,lastname,email,comments,camefrom,property,unitcode<cfif isdefined('form.hiddenstrcheckin') and len(form.hiddenstrcheckin)>,arrivalDate</cfif><cfif isdefined('form.hiddenstrcheckout') and len(form.hiddenstrcheckin)>,departureDate</cfif>,phone)
					values(
						'Yes',
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.firstname#">,
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.lastname#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.encEmail#">,
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.comments#">,
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="Request for More Info">,
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.property_name#">,
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.property_id#">
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.encPhone#">

						<cfif isdefined('form.hiddenstrcheckin') and len(form.hiddenstrcheckin)>
						  ,<cfqueryparam CFSQLType="CF_SQL_DATE" value="#form.hiddenstrcheckin#">
						</cfif>
						<cfif isdefined('form.hiddenstrcheckout') and len(form.hiddenstrcheckout)>
						  ,<cfqueryparam CFSQLType="CF_SQL_DATE" value="#form.hiddenstrcheckout#">
						</cfif>
					)
				</cfquery>

				<cfif settings.listrakEnabled is "Yes">
					<cfinclude template="/components/listrak.cfm">
				</cfif>

				<cfif settings.hasLeadtracker eq 'yes'>
					<cfinclude template="/components/leadtracker.cfm">
				</cfif>

				<cfinclude template="/#settings.booking.dir#/_user-tracking.cfm">

			<!--- </cfif> --->

			<!---START: THIS IS TO CLEAN UP THE RECEIVER - un-comment if client is using cart abandonment
			<CFQUERY DATASOURCE="#settings.bcDSN#" NAME="GetInfo">
				delete
				FROM cart_abandonment_detail_page
				where email =  <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">
				and siteID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#settings.id#">
			</CFQUERY>
			THIS IS TO CLEAN UP THE RECEIVER--->

			<cfset application.bookingObject.submitLeadToThirdParty(form)>

			<cfoutput>success</cfoutput>

		</cfif>

	</cfif>

	<!--- Review form on property detail page --->
	<cfif isdefined('form.submitReview')>

	 	<!--- reCaptcha ---->
      <cfset recaptcha = "">
      <cfif structKeyExists(FORM,"g-recaptcha-response")>
        <cfset recaptcha = FORM["g-recaptcha-response"]>
      </cfif>
	   <cfset isHuman = false>

		<cfif len(recaptcha)>

			<!--- POST to google and verify submission --->
			<cfset googleUrl = "https://www.google.com/recaptcha/api/siteverify">
			<cfset secret = settings.google_recaptcha_secretkey>
			<cfset ipaddr = CGI.REMOTE_ADDR>
			<cfset request_url = googleUrl & "?secret=" & secret & "&response=" & recaptcha & "&remoteip" & ipaddr>

			<cfhttp url="#request_url#" method="get" timeout="10">

			<cfset response = deserializeJSON(cfhttp.filecontent)>
			<cfif response.success eq "true">
				<cfset isHuman = true>
			</cfif>
		</cfif>
		<!--- end reCaptcha --->

		<cfif isHuman IS true>

			<cfsavecontent variable="emailbody">
			<cfoutput>
				<cfinclude template="/components/email-template-top.cfm">
				<p>#firstname# #lastname# has submitted a new review for #form.property_name#</p>
				<p><a href="http://#cgi.http_host#/admin/login.cfm">Log into your admin area</a> to approve the review.</p>
				<cfif isdefined('form.optin') and form.optin eq 'Yes'>
					<p>Opt-in: Yes</p>
				<cfelse>
					<p>Opt-in: No</p>
				</cfif>
				<cfinclude template="/components/email-template-bottom.cfm">
			</cfoutput>
			</cfsavecontent>

			<cfset sendEmail(settings.clientEmail,emailbody,"New review from #cgi.http_host# about #form.property_name#")>

		 	<cfif isdefined('form.optin') and form.optin eq 'Yes'>

				<cfquery dataSource="#settings.dsn#">
					insert into be_reviews(firstname,lastname,email,checkInDate,checkOutDate,title,review,unitcode,rating,hometown)
					values(
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.firstname#">,
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.lastname#">,
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">,
						<cfqueryparam CFSQLType="CF_SQL_DATE" value="#form.checkInDate#">,
						<cfqueryparam CFSQLType="CF_SQL_DATE" value="#form.checkOutDate#">,
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.title#">,
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.review#">,
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.property_id#">,
						<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.rating#">,
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.hometown#">
					)
				</cfquery>

				<cfinclude template="/#settings.booking.dir#/_user-tracking.cfm">

			<cfelse>

				<cfquery dataSource="#settings.dsn#">
					insert into be_reviews(firstname,lastname,email,checkInDate,checkOutDate,title,review,unitcode,rating,hometown)
					values(
						'Anonymous',
						'User',
						'',
						<cfqueryparam CFSQLType="CF_SQL_DATE" value="#form.checkInDate#">,
						<cfqueryparam CFSQLType="CF_SQL_DATE" value="#form.checkOutDate#">,
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.title#">,
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.review#">,
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.property_id#">,
						<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.rating#">,
						''
					)
				</cfquery>

			</cfif>

			<cfoutput>success</cfoutput>

		</cfif>

	</cfif>

	<!--- Q and A form on property detail page --->
	<cfif isdefined('form.submitQandA')>

		<!--- reCaptcha ---->
      <cfset recaptcha = "">
      <cfif structKeyExists(FORM,"g-recaptcha-response")>
        <cfset recaptcha = FORM["g-recaptcha-response"]>
      </cfif>
	   <cfset isHuman = false>

		<cfif len(recaptcha)>

			<!--- POST to google and verify submission --->
			<cfset googleUrl = "https://www.google.com/recaptcha/api/siteverify">
			<cfset secret = settings.google_recaptcha_secretkey>
			<cfset ipaddr = CGI.REMOTE_ADDR>
			<cfset request_url = googleUrl & "?secret=" & secret & "&response=" & recaptcha & "&remoteip" & ipaddr>

			<cfhttp url="#request_url#" method="get" timeout="10">

			<cfset response = deserializeJSON(cfhttp.filecontent)>
			<cfif response.success eq "true">
				<cfset isHuman = true>
			</cfif>
		</cfif>
		<!--- end reCaptcha --->

		<cfif isHuman IS true>

			<cfsavecontent variable="emailbody">
			<cfoutput>
				<cfinclude template="/components/email-template-top.cfm">
				<p>Property: #form.property_name#</p>
				<p>First Name: #firstname#</p>
				<p>First Name: #lastname#</p>
				<p>Email: #email#</p>
				<p>Question: #comments#</p>
				<cfif isdefined('form.optin') and form.optin eq 'Yes'>
					<p>Opt-in: Yes</p>
				<cfelse>
					<p>Opt-in: No</p>
				</cfif>
				<cfinclude template="/components/email-template-bottom.cfm">
			</cfoutput>
			</cfsavecontent>

			<cfset sendEmail(settings.clientEmail,emailbody,"New Q and A from #cgi.http_host# about #form.property_name#")>
			
			<cfset autoresponderTo = "matticnd@gmail.com">
			<cfinclude template="/components/autoresponder.cfm">

			<cfquery dataSource="#settings.dsn#">
				insert into be_questions_and_answers_properties (firstname,lastname,email,question,property,propertyid)
				values(
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.firstname#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.lastname#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">,
				<cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.comments#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.property_name#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.property_id#">
				)
			</cfquery>

			<cfif isdefined('form.optin') and form.optin eq 'Yes'>

					<cfinclude template="/#settings.booking.dir#/_user-tracking.cfm">

					<cfif settings.listrakEnabled is "Yes">
						<cfinclude template="/components/listrak.cfm">
					</cfif>

					<cfif settings.hasLeadtracker eq 'yes'>
						<cfinclude template="/components/leadtracker.cfm">
					</cfif>

					<cfif settings.booking.pms eq 'Escapia'>
						<cfset application.bookingObject.submitLeadToThirdParty(form)>
					</cfif>

			</cfif>

			<cfoutput>success</cfoutput>

		</cfif>

	</cfif>

	<!--- Send to Friend form on the compare favs page --->
	<cfif isdefined('form.sendToFriendCompare')>

		<!--- Google reCaptcha starts ---->
      <cfset recaptcha = "">
      <cfif structKeyExists(FORM,"g-recaptcha-response")>
        <cfset recaptcha = FORM["g-recaptcha-response"]>
      </cfif>
	   <cfset isHuman = false>

		<cfif len(recaptcha)>

			<!--- POST to google and verify submission --->
			<cfset googleUrl = "https://www.google.com/recaptcha/api/siteverify">
			<cfset secret = settings.google_recaptcha_secretkey>
			<cfset ipaddr = CGI.REMOTE_ADDR>
			<cfset request_url = googleUrl & "?secret=" & secret & "&response=" & recaptcha & "&remoteip" & ipaddr>

			<cfhttp url="#request_url#" method="get" timeout="10">

			<cfset response = deserializeJSON(cfhttp.filecontent)>
			<cfif response.success eq "true">
				<cfset isHuman = true>
			</cfif>
		</cfif>
		<!--- Google reCaptcha ends --->

		<!--- Just in case a spammer tries to put more than one email in the form field --->
		<cfset string = form.friendsemail>
		<cfset substring = '@'>

		<cfset occurrences = ( Len(string) - Len(Replace(string,substring,'','all'))) / Len(substring)>

      <cfif occurrences eq 1 and isHuman is true>

			<cfsavecontent variable="emailbody">
			<cfoutput>
			<cfinclude template="/components/email-template-top.cfm">
				<table>
					<cfset counter = 1>
					<cfloop list="#cookie.favorites#" index="i">
					<cfset getProperty = application.bookingObject.getProperty(i)>
					<tr>
						<td align="left" valign="top"><img src="https://img.trackhs.com/200x100/#getProperty.defaultPhoto#" align="left" width="200" height="150" border="0" style="padding-right:10px"></td>
						<td valign="top">
							<p style="font-family:'Helvetica Neue', helvetica, alrial, sans-serif; font-size:20px; color:##878a93;"><a href="http://#cgi.http_host#/#settings.booking.dir#/#getProperty.seoPropertyName#">Click here to view #getProperty.name#</a></p>
							<p style="font-family:'Helvetica Neue', helvetica, alrial, sans-serif; font-size:20px; color:##878a93;">Message from your friend: #Evaluate('comments_for_'&counter)#</p>
						</td>
					</tr>
					<cfset counter = counter + 1>
					</cfloop>
				</table>
				<cfinclude template="/components/email-template-bottom.cfm">
			</cfoutput>
			</cfsavecontent>

			<cfset sendEmail(form.friendsemail,emailbody,"Check out these properties I found on #cgi.http_host#",form.youremail,"","patriciah@gosouthern.com")>

			<!--- We also want to save the email address of the person who sent the form --->
			<cftry>
				<cfif len(form.youremail)>
					<cfset variables.yourencEmail = encrypt(form.youremail, application.contactInfoEncryptKey, 'AES')>
				<cfelse>
					<cfset variables.yourencEmail = ''>
				</cfif>

				<cfif isdefined('form.optin') and form.optin eq 'Yes'>

					<cfquery dataSource="#settings.dsn#">
						insert into cms_contacts(email,camefrom,optin)
						values(
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.yourencEmail#">,
							'Send to A Friend Compare',
							'Yes'
						)
					</cfquery>

				</cfif>

				<cfcatch>
					<cfif isdefined("ravenClient")>
			   		<cfset ravenClient.captureException(cfcatch)>
					</cfif>
				</cfcatch>

			</cftry>

			<cfoutput>success</cfoutput>

		<cfelse>
			You are spam, go away
		</cfif>

</cfif>


<!--- This is the form that appears when a user does a search and gets no results --->
<cfif isdefined('form.noResultsContactForm')>

	<cfsavecontent variable="emailbody">
		<cfoutput>
		<cfinclude template="/components/email-template-top.cfm">
		<p>First Name: #firstname#</p>
		<p>Last Name: #lastname#</p>
		<p>Phone: #phone#</p>
		<p>Email: #email#</p>
		<p>Number of Bedrooms: #numberOfBeds#</p>
		<p>Budget: #budget#</p>
		<p>Arrival Date: #form.arrivalDate#</p>
		<p>Departure Date: #form.departureDate#</p>
		<p>Num Adults: #form.numAdults#</p>
		<p>Num Children: #form.numChildren#</p>
		<p>I am looking for... #comments#</p>
		<cfif isdefined('form.optin') and form.optin eq 'Yes'>
			<p>Opt-in: Yes</p>
		<cfelse>
			<p>Opt-in: No</p>
		</cfif>
		<cfinclude template="/components/email-template-bottom.cfm">
		</cfoutput>
	</cfsavecontent>

	<cfset sendEmail(settings.clientEmail,emailbody,"New contact from #cgi.http_host#",'')>

	<cfset autoresponderTo = "matticnd@gmail.com">
	<cfinclude template="/components/autoresponder.cfm">

   <cfif isdefined('form.optin') and form.optin eq 'Yes'>
   		<cfif len(form.email)>
			<cfset variables.encEmail = encrypt(form.email, application.contactInfoEncryptKey, 'AES')>
		<cfelse>
			<cfset variables.encEmail = ''>
		</cfif>

		<cfif len(form.phone)>
			<cfset variables.encPhone = encrypt(form.phone, application.contactInfoEncryptKey, 'AES')>
		<cfelse>
			<cfset variables.encPhone = ''>
		</cfif>

		<cfquery dataSource="#settings.dsn#">
	     insert into cms_contacts(optin,firstname,lastname,email,comments,camefrom,phone,optin<cfif isdefined('form.arrivalDate') and len(form.arrivalDate)>,arrivalDate</cfif><cfif isdefined('form.departureDate') and len(form.departureDate)>,departureDate</cfif>)
				values(
					'Yes',
					<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.firstname#">,
					<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.lastname#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.encEmail#">,
					<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.comments#">,
					<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="No Results Contact Form">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.encPhone#">,
					'Yes'
					<cfif isdefined('form.arrivalDate') and len(form.arrivalDate)>
					  ,<cfqueryparam CFSQLType="CF_SQL_DATE" value="#form.arrivalDate#">
					</cfif>
					<cfif isdefined('form.departureDate') and len(form.departureDate)>
					  ,<cfqueryparam CFSQLType="CF_SQL_DATE" value="#form.departureDate#">
					</cfif>
			)
	    </cfquery>

    </cfif>

    <cfoutput>success</cfoutput>

</cfif>

</cfif><!--- end of <cfif Cffp.testSubmission(form)> --->