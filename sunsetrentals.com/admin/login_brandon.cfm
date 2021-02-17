<cfif !isdefined('url.logout') AND checkLoggedInUserSecurity()>
   <cflocation addToken="no" url="/admin/dashboard.cfm">
 </cfif>


<cfinclude template="components/header.cfm">

<link rel="stylesheet" href="/admin/bootstrap/css/_options/unicorn.login.css">

<cfparam name="message" default="">

<!--- User has submitted form	  --->
<cfif isdefined('form.submit')>

<!---added the isdefined twofactor to get past this section--->
  <cfif (isdefined('form.email') and len(form.email) and isdefined('form.password') and len(form.password)) and isdefined('twofactor') is "No">

    <!--- Check for ICND logins first --->
    <!--- NOTE: Add any 'special' columns as constants in this query as needed --->
    <cfquery name="loginQuery" dataSource="booking_clients">
      SELECT  cms_users_ICND.*
      FROM    cms_users_ICND 
      WHERE   email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">
    </cfquery>

    <cfif loginQuery.recordcount is 0>
      <!--- no ICND login, check for normal login --->
      <cfquery name="loginQuery" dataSource="#dsn#">
        SELECT * FROM cms_users WHERE email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">
      </cfquery>
    </cfif>
	

	<!---valid user so create and email token--->
	<cfif loginQuery.recordcount gt 0>
	
			<!---delete any old lingering entries associated with this email address--->
		  <cfquery dataSource="booking_clients">
		  	delete from twofactorauthenication where email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#"> 
			and site = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cgi.HTTP_HOST#">
		  </cfquery>
  
	
	 		<!---add one hour and then in my query when authenicating against this table make sure less than one hour--->
		    <cfset OneHourAhead = "#dateadd('h','1',now())#">
	
			<cfquery dataSource="booking_clients">
		          insert into twofactorauthenication(email,token,site,onehourahead) 
		          values(                        
		            <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">,            
		            <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cfid##cftoken#">, 
		            <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cgi.HTTP_HOST#">,
					<cfqueryparam value="#OneHourAhead#" cfsqltype="CF_SQL_TIMESTAMP">
		               )
		      </cfquery>
			
			<!---email client that is logging in--->
			<cfsavecontent variable="emailbody">
	        <cfoutput>
	        <cfinclude template="/components/email-template-top.cfm">       
	         <p>Thank you #form.email#</p>
			 <p>Please return to the site and enter the following token: #cfid##cftoken#</p>
			 <p>Thank you!</p>
			 <p>Team ICND!</p>
	         <cfinclude template="/components/email-template-bottom.cfm">
	        </cfoutput>
	        </cfsavecontent>
	        
	         <cfset sendEmail(form.email,emailbody,"New contact from #cgi.http_host#")> 
			
			<!---start: show token form--->
		<div id="loginbox">
		  <form id="loginform" class="form-vertical" method="post" action="login.cfm">
		  <cfoutput>
		<input id="user-email" maxlength="100" name="email" type="hidden" value="#form.email#"  />
		</cfoutput>
		<input type="hidden" name="twofactor" value="">
		
		    <div class="control-group">
		      <div class="controls">
		        <div class="input-prepend">
		          <span class="add-on"><i class="icon-lock"></i></span><input id="user-password" maxlength="25" name="TheToken" type="password" value="" placeholder="Token" />
		        </div>
		      </div>
		    </div>
		    <div class="form-actions">
		      <span class="pull-left"><!--- <a href="#" class="flip-link" id="to-recover">Lost password?</a> ---></span>
		      <span class="pull-right"><input name="submit" type="Submit" class="btn btn-inverse" value="Login" /></span>
		    </div>
		  </form>  
		</div>
<!---end: show token form--->
			
			<cfabort>
	<cfelse>
		<cfset message = 'User not found, please try again.'>
	</cfif>
	
	
	
	<cfelseif isdefined('twofactor')>
	<!---this is the final two way authenication--->
		
		
	<cfquery name="CheckToken" dataSource="booking_clients">
      SELECT  *
      FROM    twofactorauthenication 
      WHERE   email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#"> and token = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.TheToken#"> 		
			  and site = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cgi.HTTP_HOST#"> and now() <= OneHourAhead
    </cfquery>	 

	
    <cfif CheckToken.recordcount gt 0>
	
	<cfquery name="CheckSalt" dataSource="booking_clients">
      SELECT  cms_users_ICND.*
      FROM    cms_users_ICND 
      WHERE   email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">
    </cfquery>

    <cfif CheckSalt.recordcount is 0>
      <!--- no ICND login, check for normal login --->
      <cfquery name="CheckSalt" dataSource="#dsn#">
        SELECT * FROM cms_users WHERE email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">
      </cfquery>
    </cfif>


            <!--- Step 1: Get the key from text file; we will use this to decrypt the encryptedSalt from the db --->
            <cfset authKeyLocation = expandpath('../../auth/key.txt')>
            <cffile action="read" file="#authKeyLocation#" variable="authkey">


            <!--- Step 2: Decrypt the encrypted salt from the db --->
            <cfset decryptedSalt = decrypt(CheckSalt.encryptedSalt, authKey, 'AES','Base64')>


            <!--- Step 3: Hash the password from the user using the decrypted salt --->
			<!--- BS - NEED TO TALK TO ALLAN ABOUT THIS --->
            <!--- <cfset passwordHashFromUser = Hash(CheckSalt.password & decryptedSalt, 'SHA-512') /> --->
			<cfset passwordHashFromUser = CheckSalt.password />

            <!--- If we found a user and the hashed password from the db matches the hashed password from the user, log them in --->
            <cfif (CheckSalt.recordcount gt 0 and passwordHashFromUser eq CheckSalt.password)
                <!--- or cgi.remote_addr eq '66.87.133.245' ---> <!--- WHY IS THIS HERE!!! --->
            >
 
              <cfset cleandomain = replace(settings.website,'www.','','all')>
              <cfcookie name="tinymce_domain" value="#cleandomain#" expires="Never">

                <cfcookie name="LoggedInID"  expires="NOW">
                <cfcookie name="LoggedInName"  expires="NOW">
                <cfcookie name="LoggedInRole"  expires="NOW">

                <cfset session.loggedInUserStruct = {}>
                <cfset session.loggedInUserStruct.LoggedInID = CheckSalt.id>
                <cfset session.loggedInUserStruct.LoggedInName = CheckSalt.name>
                <cfset session.loggedInUserStruct.LoggedInRole = CheckSalt.role>


              <meta http-equiv="REFRESH" content="0; url=dashboard.cfm">

              <!--- Update 'user' table --->
              <cfquery dataSource="#dsn#">
                update cms_users set lastLoggedIn = now() where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#CheckSalt.id#">
              </cfquery>

            <cfelse>

              <cfset message = 'Incorrect User / Password Combination.  Try Again.'>

            </cfif>
     <cfelse>
      <cfset message = 'User not found, please try again.'>
     </cfif>


  <cfelse>

    <cfset message = 'Email and Password are required fields.'>

  </cfif>

</cfif>

<!--- User has logged out --->
<cfif isdefined('logout')>

  <cfcookie name="LoggedInID"  expires="NOW">
  <cfcookie name="LoggedInName"  expires="NOW">
  <cfcookie name="LoggedInRole"  expires="NOW">

    <cfset StructDelete(session, "loggedInUserStruct") />

  <cfset message = 'You have successfully logged out.'>
</cfif>

<div id="loginbox">
  <form id="loginform" class="form-vertical" method="post" action="login.cfm">
    <cfif len(message)>
      <p class="flash"><cfoutput>#message#</cfoutput></p>
    <cfelse>
      <p>Enter username and password to continue.</p>
    </cfif>
    <div class="control-group">
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><i class="icon-envelope"></i></span><input id="user-email" maxlength="100" name="email" type="text" value="" placeholder="Email Address" />
        </div>
      </div>
    </div>
    <div class="control-group">
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><i class="icon-lock"></i></span><input id="user-password" maxlength="25" name="password" type="password" value="" placeholder="Password" />
        </div>
      </div>
    </div>
    <div class="form-actions">
      <span class="pull-left"><!--- <a href="#" class="flip-link" id="to-recover">Lost password?</a> ---></span>
      <span class="pull-right"><input name="submit" type="Submit" class="btn btn-inverse" value="Login" /></span>
    </div>
  </form>
  <form id="recoverform" action="#" class="form-vertical">
    <p>Enter your e-mail address below and we will send you instructions how to recover a password.</p>
    <div class="control-group">
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><i class="icon-envelope"></i></span><input type="text" placeholder="E-mail address" />
        </div>
      </div>
    </div>
    <div class="form-actions">
      <span class="pull-left"><a href="#" class="flip-link" id="to-login">&lt; Back to login</a></span>
      <span class="pull-right"><input type="submit" class="btn btn-inverse" value="Recover" /></span>
    </div>
  </form>
</div>

<br>


<cfinclude template="components/footer.cfm">

<script src="/admin/bootstrap/js/unicorn.login.js"></script>
