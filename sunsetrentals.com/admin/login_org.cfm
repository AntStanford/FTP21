<cfif !isdefined('url.logout') AND checkLoggedInUserSecurity()>
   <cflocation addToken="no" url="/admin/dashboard.cfm">
  
</cfif>

<cfinclude template="components/header.cfm">

<link rel="stylesheet" href="/admin/bootstrap/css/_options/unicorn.login.css">

<cfparam name="message" default="">

<!--- User has submitted form	  --->
<cfif isdefined('form.submit')>

  <cfif isdefined('form.email') and len(form.email) and isdefined('form.password') and len(form.password)>

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

    <cfif loginQuery.recordcount gt 0>

            <!--- Step 1: Get the key from text file; we will use this to decrypt the encryptedSalt from the db --->
            <cfset authKeyLocation = expandpath('../../auth/key.txt')>
            <cffile action="read" file="#authKeyLocation#" variable="authkey">


            <!--- Step 2: Decrypt the encrypted salt from the db --->
            <cfset decryptedSalt = decrypt(loginQuery.encryptedSalt, authKey, 'AES','Base64')>


            <!--- Step 3: Hash the password from the user using the decrypted salt --->
            <cfset passwordHashFromUser = Hash(form.password & decryptedSalt, 'SHA-512') />

            <!--- If we found a user and the hashed password from the db matches the hashed password from the user, log them in --->
            <cfif (loginQuery.recordcount gt 0 and passwordHashFromUser eq loginQuery.password)
                <!--- or cgi.remote_addr eq '66.87.133.245' ---> <!--- WHY IS THIS HERE!!! --->
            >
              
              <cfset cleandomain = replace(settings.website,'www.','','all')>
              <cfcookie name="tinymce_domain" value="#cleandomain#" expires="Never">

                <cfcookie name="LoggedInID"  expires="NOW">
                <cfcookie name="LoggedInName"  expires="NOW">
                <cfcookie name="LoggedInRole"  expires="NOW">

                <cfset session.loggedInUserStruct = {}>
                <cfset session.loggedInUserStruct.LoggedInID = loginQuery.id>
                <cfset session.loggedInUserStruct.LoggedInName = loginQuery.name>
                <cfset session.loggedInUserStruct.LoggedInRole = loginQuery.role>


              <meta http-equiv="REFRESH" content="0; url=dashboard.cfm">

              <!--- Update 'user' table --->
              <cfquery dataSource="#dsn#">
                update cms_users set lastLoggedIn = now() where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#loginQuery.id#">
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
