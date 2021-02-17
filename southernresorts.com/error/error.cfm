<cfdump var="#error#" abort="true">
<cftry>
  <cfinclude template="/components/header.cfm">
  <cfcatch type="any"></cfcatch>
</cftry>

<link rel="stylesheet" type="text/css" href="/error/styles.css">
<div style="padding:20px;background-color:white;color:black;margin-top:150px">
<h3>Oops!</h3>
<p>Looks like we've got a few wires crossed.  Our team is working hard to get things fixed so we get back to helping you as soon as possible.</p>
<br>
<p>In the mean time, here's a few links that might help:<br>
Our <a href="/">homepage</a>
<br>or<br>
<a href="javascript:history.go(-1)">Go back to previous page</a>
</p>
<hr>

<cfoutput>
	
	<p><strong>Date:</strong> #dateformat(now(),'medium')#</p>
	<p><strong>Time:</strong> #timeformat(now(),'medium')#</p>
	<p><strong>Operating System and Browser:</strong> #error.browser#</p>	
	<p><strong>IP Address:</strong> #error.remoteAddress#</p>
	<p><strong>URL of Problem:</strong> <a href="#error.HTTPReferer#">#error.HTTPReferer#</a></p>
	
	<form role="form" method="post" class="error-form" id="errorform" action="/error/errorSubmit.cfm">
		<h4>Submit A Problem</h4>

		<div class="col-md-12 form-group">
			<label>NAME (Required)</label>
			<input type="text" name="firstname" placeholder="First Name" class="required">
	   	<input type="text" name="lastname" placeholder="Last Name" class="required">
		</div>

		<div class="col-md-12 form-group">
	   	<label>EMAIL ADDRESS (Optional)</label>
			<input type="email" name="email" placeholder="Enter your email address">
		</div>
		<div class="col-md-12 form-group">
	   	<label>PHONE NUMBER (Optional)</label>
			<input type="text" name="phone" placeholder="Best number to reach you?">
	   </div>

		<div class="col-md-12 form-group">
	   	<label>QUESTIONS OR COMMENTS (Required)</label>
			<textarea name="comments" placeholder="What were you trying to accomplish when you error happened? Please be descriptive as possible." class="required"></textarea>
	   </div>

		<div class="col-md-12 form-group">
			<input class="btn btn-primary" type="submit" value="SUBMIT" name="contactform">
		</div>
		<input type="hidden" name="error" value="#error.diagnostics#">
		<input type="hidden" name="datetime" value="#error.dateTime#">
		<input type="hidden" name="system" value="#error.browser#">
		<input type="hidden" name="remoteaddress" value="#error.remoteAddress#">
		<input type="hidden" name="referer" value="#error.HTTPReferer#">
		<input type="hidden" name="template" value="#error.template#">
		<input type="hidden" name="querystring" value="#error.queryString#">
		<input type="hidden" name="message" value="#error.message#">
		<input type="hidden" name="host" value="#cgi.host#">

	</form>
</div>
</cfoutput>


<cfif isdefined('ravenClient')>
	<cfset ravenClient.captureException(error)>
</cfif>

<cftry>
  <cfinclude template="/components/footer.cfm">
  <cfcatch type="any"></cfcatch>
</cftry>

<cfif Find('216.99.119.254',cgi.remote_host)>
  <p>ICND eyes only, filtered by IP address</p>
  <cfdump var="#error#">
</cfif>

