<!--- Send a confirmation email to the guest and BCC the client --->
<cfsavecontent variable="emailbody">
<cfoutput>
       
       <cfinclude template="/components/email-template-top.cfm">
       <p><strong>Thank you for booking with #cgi.http_host#!</strong></p>

       <p>Your reservation code is: #request.reservationCode#</p>

       <p><strong>User Information</strong></p>

       <table cellpadding="0" cellspacing="0">
   		<tr><th width="250" align="left">Name:</th><td>#form.firstname# #form.lastname#</td></tr>
   		<tr><th align="left">Address:</th><td>#form.address1#</td></tr>
   		<tr><th></th><td>#form.city#, #form.state# #form.zip#</td></tr>
   		<tr><th></th><td>Visitors: #form.numAdults#</td></tr>
   		<cfif isdefined('form.numPets') and form.numPets gt 0>
				<p>Num Pets: #form.numPets#</p>
			</cfif>
   		<!--- <tr><th></th><td>Children: #form.numChildren#</td></tr> --->
   	</table>

   	<p><strong>Unit Information</strong></p>

   	<table cellpadding="0" cellspacing="0">
   		<tr><th width="250" align="left">Name:</th><td>#form.propertyname# - Unit: #form.propertyid#</td></tr>
   		<tr><th align="left">Check In:</th><td>#form.strCheckin#</td></tr>
   		<tr><th align="left">Check Out:</th><td>#form.strCheckout#</td></tr>
   		<tr><th align="left">Location:</th><td>#form.propertyCity#, #form.propertyState#</td></tr>
   	</table>

   	<p><strong>Summary of Charges</strong></p>

   	<table cellpadding="0" cellspacing="0">   			
         
         <cfif isdefined('form.travelInsurance') and form.travelInsurance is "true">
         	<tr><th align="left">Total Amount for Reservation</th><td>#Dollarformat(form.TotalWithInsurance)#</td></tr>
         	<tr><th align="left">You purchased travel insurance for</th><td>#Dollarformat(form.tripinsuranceamount)#</td></tr>
         <cfelse>
         	<tr><th align="left">Total Amount for Reservation</th><td>#Dollarformat(form.Total)#</td></tr>
         </cfif>
         
   	</table>
   	
   	<cfif isdefined('form.comments') and len(form.comments)>
   		<p><strong>Comments</strong></p>
   		<p>#form.comments#</p>
   	</cfif>
   	
   	<cfinclude template="/components/email-template-bottom.cfm">

</cfoutput>
</cfsavecontent>

<cfset sendEmail(to=form.email,emailbody=emailbody,subject="Booking confirmation from #cgi.http_host#",cc=settings.clientEmail,bcc="patriciah@gosouthern.com")>
