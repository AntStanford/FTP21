<cfset table = 'cms_users'>
<cfset page.title ="Users">
<cfset module = 'user'>

<cfset variables.HasSpecialCharacters = false />
<cfset variables.HasNumbers = false />
<cfset variables.pwError = false />
<cfset variables.pwMessage = '' />

<cfif isdefined('form.password')>

  <!---check length--->
  <cfif #len(form.password)# lt 6>
    <cfset variables.pwError = true />
    <cfset variables.pwMessage &= 'Your password must be at least 6 characters in length.<br>' />
  </cfif>

  <!---check special character--->
  <cfloop index="i" list="!,@,$,%,^,(,),&,*">
    <cfif find(i,form.password)>
      <cfset variables.HasSpecialCharacters = true>
      <cfbreak>
    </cfif>
  </cfloop>

  <cfif variables.HasSpecialCharacters is false>
    <cfset variables.pwError = true />
    <cfset variables.pwMessage &= 'Your password must contain at least one these special characters !,@,$,%,^,(,),&,*<br>' />
  </cfif>

  <!---check number--->
  <cfloop index="i" list="1,2,3,4,5,6,7,8,9,0">
    <cfif find(i,form.password)>
      <cfset variables.HasNumbers = true>
      <cfbreak>
    </cfif>
  </cfloop>

  <cfif variables.HasNumbers is false>
    <cfset variables.pwError = true />
    <cfset variables.pwMessage &= 'Your password must contain at least one number.<br>' />
  </cfif>

</cfif>

<cfif variables.pwError>

  <cfif len(variables.pwMessage) is 0>
    <cfset variables.pwMessage = 'A password must be provided.' />
  </cfif>
  <cfinclude template="/admin/components/header.cfm">
  <p style="color: red; text-align: center;"><cfoutput>#variables.pwMessage#</cfoutput>
    <a href="javascript: window.history.go(-1)">Go Back</a>
  </p>
  <cfinclude template="/admin/components/footer.cfm">
  <cfabort>

</cfif>

<!--- Location of key used to encrypt the salt; stored outside of webroot --->
<cfset authKeyLocation = expandpath('../../../auth/key.txt')>
<cffile action="read" file="#authKeyLocation#" variable="authkey">

<cfif isdefined('url.id') and isdefined('url.delete')> <!--- delete statement --->

	<cfquery dataSource="#application.dsn#">
    	delete from cms_users where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  	</cfquery>

  	<cflocation addToken="no" url="index.cfm?success">

<cfelseif isdefined('form.id')> <!--- update statement --->

  <!--- Only do this if user provides a new password --->
  <cfif len(form.password)>

    <!--- Generate a salt --->
    <cfset theSalt = createUUID() />


    <!--- Hash the password with the salt in it's plain form--->
    <cfset passwordHash = Hash(form.password & theSalt, 'SHA-512') />


    <!--- The encrypted salt to store in the database, using the authKey--->
    <cfset encryptedSalt = encrypt(theSalt, authKey, 'AES','Base64')>

  </cfif>


  <cfquery dataSource="#application.dsn#">
    update cms_users set
    name = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.name#">,
    email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">
    <cfif len(form.password)>,password = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#passwordHash#"></cfif>
    <cfif len(form.password)>,encryptedSalt = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#encryptedSalt#"></cfif>
    where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">
  </cfquery>

  <cflocation addToken="no" url="form.cfm?id=#form.id#&success">

<cfelse>  <!---insert statement--->


  <!--- Generate a salt --->
  <cfset theSalt = createUUID() />


  <!--- Hash the password with the salt in it's plain form--->
  <cfset passwordHash = Hash(form.password & theSalt, 'SHA-512') />


  <!--- The encrypted salt to store in the database, using the authKey--->
  <cfset encryptedSalt = encrypt(theSalt, authKey, 'AES','Base64')>


  <cfquery dataSource="#application.dsn#">
    insert into cms_users(name,email,password,role,encryptedSalt)
    values(
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.name#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#passwordHash#">,
      'client',
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#encryptedSalt#">
    )
  </cfquery>

  <cflocation addToken="no" url="form.cfm?success">

</cfif>