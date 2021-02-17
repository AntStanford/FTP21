<cfinclude template="/vacation-rentals/components/header.cfm">

<div class="i-content" style="margin:20px">
  <div class="container">
  	<div class="row">
  		<div class="col-lg-12">
       	<h2>Whoops!</h2>
		<cfif isDefined("session.errormessage") AND (session.errorMessage CONTAINS "Mobile phone is in use" OR session.errorMessage CONTAINS "Primary email address")>	
       	<p>We are sorry to be experiencing difficulties, but recognize you as a valued guest. Please call to book with a sweet Southern discount. Thank you!</p>
		<cfelse>
			<p>There was a problem with your request.</p>
			<cfif isdefined('session.errorMessage')>
			<p><b><cfoutput>#session.errorMessage#</cfoutput></b></p>
       		</cfif>
		</cfif>
  		</div>
  	</div>
  </div>
</div>

<cfinclude template="/vacation-rentals/components/footer.cfm">
	

<cfif isDefined("session.errormessage") AND (session.errorMessage CONTAINS "Mobile phone is in use" OR session.errorMessage CONTAINS "Primary email address")>	
<cfsavecontent variable="emailbody">
<cfoutput>
	#session.errormessage#<br>
	<!---
	unitId: #form.propertyId#<br>
    arrivalDate: #formattedCheckin#<br>
    departureDate: #formattedCheckout#<br>
                    
                   
	firstName: #form.firstname#<br>
	lastName: #form.lastname#<br>
	streetAddress: #form.address1#<br>
	locality: #form.city#<br>
	region: #form.state#<br>
	postal: #form.zip#<br>
	country: US"
	primaryEmail: #form.email#<br>
	cellPhone: #form.phone#<br>
     --->               
</cfoutput>
</cfsavecontent>
<cfset sendEmail(to="GuestServices@GoSouthern.com",emailbody=emailbody,subject="Duplicate Booking Error Encountered")>
</cfif>
