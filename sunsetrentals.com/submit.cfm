<cfset Cffp = CreateObject("component","cfformprotect.cffpVerify").init() />

<cfif Cffp.testSubmission(form)>

  <cfif isdefined('form.contactform')>
        
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
		
		<cfif isHuman>
		
	        <cfsavecontent variable="emailbody">
	        	<cfoutput>
	        	<cfinclude template="/components/email-template-top.cfm">        
	          <p>First Name: #firstname#</p>
	          <p>Last Name: #lastname#</p>
	          <p>Email: #email#</p>
	          <p>Phone Number: #phone#</p>
	          <p>Comments: #comments#</p>
	          <cfif isdefined('form.resort') and len(form.resort)>
	          	<p>This user has a question about: #form.resort#</p>
	          </cfif>
	          <cfif isdefined('form.longtermrental') and len(form.longtermrental)>
	          	<p>This user is interested in the following long term rental: #form.longtermrental#</p>
	          </cfif>
	          <cfif isdefined('form.optin') and form.optin eq 'Yes'>
	          	<p>Opt-in: Yes</p>
	          <cfelse>
	          	<p>Opt-in: No</p>
	          </cfif>
	          <cfinclude template="/components/email-template-bottom.cfm">
		     	</cfoutput>
	        </cfsavecontent>
	        
	        <cfset sendEmail(settings.clientEmail,emailbody,"New contact from #cgi.http_host#")> 
	        
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
		          insert into cms_contacts(firstname,lastname,email,comments,phone,camefrom,optin) 
		          values(
		            <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#firstname#">,
		            <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#lastname#">,
		            <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.encEmail#">,
		            <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#comments#">,
		            <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.encPhone#">,
		            'Contact Page',
		            'Yes'
		          )
		        </cfquery>
		        
		         <cfif settings.ListrakEnabled is "Yes">
						<cfinclude template="/components/listrak.cfm">
					</cfif>
				
		        <cfif settings.hasLeadtracker eq 'yes'>
				  		<cfinclude template="/components/leadtracker.cfm">
				  </cfif>
	        
	        </cfif>								
				
			  <cfoutput>success</cfoutput>
        
       </cfif>
  
  </cfif>
    
  <cfif isdefined('form.newsletterform')>
        
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
		
		<cfif isHuman>
		
	        <cfsavecontent variable="emailbody">
	        <cfoutput>
	        <cfinclude template="/components/email-template-top.cfm">       
	          <p>First Name: #form.firstname#</p>
	          <p>Last Name: #form.lastname#</p>
	          <p>Email: #email#</p> 
	          <cfif isdefined('form.optin') and form.optin eq 'Yes'>
	          	<p>Opt-in: Yes</p>
	          <cfelse>
	          	<p>Opt-in: No</p>
	          </cfif>
	          <cfinclude template="/components/email-template-bottom.cfm">
	        </cfoutput>
	        </cfsavecontent>
	        
	        <cfset sendEmail(settings.clientEmail,emailbody,"New contact from #cgi.http_host#")>
			  
			  <cfif isdefined('form.optin') and form.optin eq 'Yes'>
			  	<cfif len(form.email)>
					<cfset variables.encEmail = encrypt(form.email, application.contactInfoEncryptKey, 'AES')>
				<cfelse>
					<cfset variables.encEmail = ''>
				</cfif>

				<cfquery dataSource="#settings.dsn#">
		          insert into cms_contacts(email,camefrom,firstname,lastname,optin) 
		          values(                        
		            <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.encEmail#">,
		            'Newsletter Form',
		            <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.firstname#">, 
		            <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.lastname#">,
		            'Yes'
		          )
		        </cfquery>
				
		   		<cfif settings.ListrakEnabled is "Yes">
		   			<cfinclude template="/components/listrak.cfm">
		   		</cfif>
		   		
		   		<cfif settings.hasLeadtracker eq 'yes'>
				    <cfinclude template="/components/leadtracker.cfm">
		        </cfif>
	       
	       </cfif>
	       
	       <cfoutput>success</cfoutput>
       
       </cfif>
          
  </cfif>
  
    
    
</cfif> <!--- end of <cfif Cffp.testSubmission(form)> --->


<!--- add form processing for blog footer form here --->
