<!--- ref: http://wiki.icnd.net/doku.php?id=how_to_integrate_with_mailchimp --->

<!--- Mail Chimp Info --->
<cfset mc_api.key = 'bf2fc1d635800a8aa13f0985bd1350fa-us14'> <!--- change this, have PM request from client --->
<cfset mc_api.server = 'us14'> <!--- this comes from the api key above, grab the last 4 numbers --->
<cfset mc_api.listId = '837be3ae49'> <!--- change this, have PM request this from client --->

<cfif isdefined('form.email') and LEN(form.email)>

  <cfset theurl="https://" & mc_api.server & ".api.mailchimp.com/2.0/lists/subscribe.json?apikey=" & mc_api.key & "&id=" & mc_api.listId & "&email[email]="
  & form.email>

  <cfif isdefined('form.firstname')>
    <cfset theurl = theurl & '&merge_vars[FNAME]=' & form.firstname>
  </cfif>

  <cfif isdefined('form.lastname')>
    <cfset theurl = theurl & '&merge_vars[LNAME]=' & form.lastname>
  </cfif>

  <cfset theurl = theurl & '&double_optin=false&send_welcome=false'>

<cftry>

    <cfhttp url="#theurl#" method="post" result="ChimpResponse">
      <cfhttpparam type="formfield" name="" value="">
    </cfhttp>

   <cfcatch type="any">

   	<cfif isdefined("ravenClient")>
			<cfset ravenClient.captureException(cfcatch)>
		</cfif>

   </cfcatch>

</cftry>

</cfif>


