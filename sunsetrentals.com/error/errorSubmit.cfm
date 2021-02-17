<cfif 
	isdefined('form.firstname') and len(form.firstname) and isdefined('form.comments') and len(form.comments)>
	
	<cfsavecontent variable="emailBody">
		<h3>Please visit the Sentry for more details</h3>
		<h4>FORM</h4>
		<cfdump var="#form#">
		<h4>CGI</h4>
		<cfloop collection="#cgi#" item="key">
			<cfoutput><p><b>#key#</b>: #cgi[key]#</p></cfoutput>
		</cfloop>
	</cfsavecontent>
	
	<cfset sendEmail('support@icoastalnet.com',emailbody,"Error Template from #cgi.http_host#")>
	
	<cfinclude template="/components/header.cfm">
	<p>Thank you for submitting the error report.</p> <p>Our support team has been notified!</p>
	<cfinclude template="/components/footer.cfm">
	
<cfelse>

	<p>Name and comments are required. Please <a href="javascript:window.history.back();">go back</a> and try again.</p>

</cfif>