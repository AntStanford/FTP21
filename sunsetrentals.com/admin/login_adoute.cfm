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

      <!--- If we found a user and the hashed password from the db matches the hashed password from the user, start the token process --->
      <cfif (loginQuery.recordcount gt 0 and passwordHashFromUser eq loginQuery.password)>

        <!--- Create a 16 character mostly unpredictable token --->
        <cfset token = mid(hash(createUUID(),'MD5'), randRange(0, 15), 16) />

        <!---delete any old lingering entries associated with this email address--->
        <cfquery dataSource="booking_clients">
          DELETE FROM twofactorauthenication
          WHERE email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">
          AND site = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cgi.HTTP_HOST#">
        </cfquery>

        <!---add one hour and then in my query when authenicating against this table make sure less than one hour--->
        <cfset OneHourAhead = "#dateadd('h','1',now())#">

        <cfquery dataSource="booking_clients">
          INSERT INTO twofactorauthenication (
              email, token, site, onehourahead
            ) VALUES (
              <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">,
              <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#token#">,
              <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cgi.HTTP_HOST#">,
              DATE_ADD(NOW(),INTERVAL 1 HOUR)
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

        <cfset sendEmail(form.email,emailbody,"Login token from #cgi.http_host#")>

        <!---start: show token form--->
        <div id="loginbox">
          <form id="loginform" class="form-vertical" method="post" action="login_adoute.cfm">
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

        <cfinclude template="components/footer.cfm">
        <script src="/admin/bootstrap/js/unicorn.login.js"></script>

        <cfabort>

      <cfelse><!--- (loginQuery.recordcount gt 0 and passwordHashFromUser eq loginQuery.password) if --->
        <!--- email not found or passwrod doesn't match... --->
        <cfset message = 'User not found, please try again.'>
      </cfif>

    <cfelse><!--- loginQuery.recordcount gt 0 --->
      <cfset message = 'User not found, please try again.'>
    </cfif>

  <cfelseif isDefined('form.email') and len(form.email) and isDefined('form.TheToken') and len(form.TheToken)><!--- isdefined('form.email') and len(form.email) and isdefined('form.password') and len(form.password) --->

    <!--- we have an email & a token --->
    <cfquery name="CheckToken" dataSource="booking_clients">
      SELECT  email
      FROM    twofactorauthenication
      WHERE   email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">
      AND     token = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.TheToken#">
      AND     site = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cgi.HTTP_HOST#">
      AND     now() <= OneHourAhead
    </cfquery>

    <cfif CheckToken.recordcount gt 0>
      <!--- good login - get user info --->
      <cfquery name="loginQuery" dataSource="booking_clients">
        SELECT  cms_users_ICND.*
        FROM    cms_users_ICND
        WHERE   email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">
      </cfquery>
      <cfset icnduser = true />

      <cfif loginQuery.recordcount is 0>
        <!--- no ICND login, check for normal login --->
        <cfset icnduser = false />
        <cfquery name="loginQuery" dataSource="#dsn#">
          SELECT * FROM cms_users WHERE email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">
        </cfquery>
      </cfif>

      <cfset cleandomain = replace(settings.website,'www.','','all')>
      <cfcookie name="tinymce_domain" value="#cleandomain#" expires="Never">

      <cfcookie name="LoggedInID"  expires="NOW">
      <cfcookie name="LoggedInName"  expires="NOW">
      <cfcookie name="LoggedInRole"  expires="NOW">

      <cfset session.loggedInUserStruct = {}>
      <cfset session.loggedInUserStruct.LoggedInID = loginQuery.id>
      <cfset session.loggedInUserStruct.LoggedInName = loginQuery.name>
      <cfset session.loggedInUserStruct.LoggedInRole = loginQuery.role>

      <!--- attennpt to Update 'user' table --->
      <cfif !icnduser>
        <cfquery dataSource="#dsn#">
          UPDATE cms_users SET lastLoggedIn = now() WHERE email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">
        </cfquery>
      </cfif>

      <meta http-equiv="REFRESH" content="0; url=dashboard.cfm">

    <cfelse><!--- CheckToken.recordcount gt 0 --->
      <cfset message = 'User not found, please try again.'>
    </cfif>

  <cfelse>
    <cfset message = 'Email and Password are required fields.'>
  </cfif>

</cfif><!--- submit if --->

<!--- User has logged out --->
<cfif isdefined('logout')>

  <cfcookie name="LoggedInID"  expires="NOW">
  <cfcookie name="LoggedInName"  expires="NOW">
  <cfcookie name="LoggedInRole"  expires="NOW">

  <cfset StructDelete(session, "loggedInUserStruct") />

  <cfset message = 'You have successfully logged out.'>

</cfif>

<div id="loginbox">
  <form id="loginform" class="form-vertical" method="post" action="login_adoute.cfm">
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