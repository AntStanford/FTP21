<cfif NOT isdefined('form.strCheckin')>Check-In not defined<cfabort></cfif>
<cfif NOT isdefined('form.strCheckout')>Check-Out not defined<cfabort></cfif>
<cfif NOT isdefined('form.propertyid')><!---you are a bot--->Propertyid is required.<cfabort></cfif>
<cfif isdefined('form.strcheckin') and !isValid('date',form.strcheckin)>Check-In date not valid.<cfabort></cfif>
<cfif isdefined('form.strcheckout') and !isValid('date',form.strcheckout)>Check-Out date not valid.<cfabort></cfif>

<!--- checking availability to prevent refiring of the same reservation --->
<cfif isdefined('form.propertyid') and LEN(form.propertyid) and isdefined('form.strcheckin') and LEN(form.strcheckin) and isdefined('form.strcheckout') and LEN(form.strcheckout)>
	<cfset request.checkAvailability = application.bookingObject.getDetailRates(form.propertyid,form.strcheckin,form.strcheckout)>
	<cfif request.checkAvailability does not contain 'detailBookBtn'>Property not available.<cfabort></cfif>
</cfif>


<!--- query to check availability and get pricing info --->
<cfset request.reservationCode = application.bookingObject.checkout(form)>
<!--- Send the confirmation email --->
<!--- <cfinclude template="/#settings.booking.dir#/_confirm-email.cfm"> --->

<cfinclude template="components/header.cfm">

<!---START: give cart abandonment email credit--->
<cfif isdefined('cookie.CartAbandonEmail') and isdefined('cookie.CartAbandonmentKey')>

	<cfquery NAME="UpdateQuery" DATASOURCE="#application.bcDSN#">
		UPDATE cart_abandonment SET 
		CookieAbandomentUnitCodeBooked = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.unitcode#">,
		CookieAbandonmentBooked = 'Yes'
		where TheKey = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cookie.CartAbandonmentKey#"> 
		and siteID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#settings.id#">
	</cfquery>
	   
	<cfcookie name="CartAbandonEmail" expires="NOW">
	<cfcookie name="CartAbandonmentKey" expires="NOW">

</cfif>
<!---END: give cart abandonment email credit--->

<!---START: give the return and book feature credit--->
<cfif isdefined('Cookie.ReturnAndBookedID')>
			
	<CFQUERY NAME="UpdateQuery" DATASOURCE="#settings.dsn#">
    	UPDATE cms_remindtobook
    	SET 
    	ReturnedAndBooked = 'Yes',
		FinalPropertyID = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.propertyID#">,
		FinalBookingValue = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#form.Total#">,
		FinalPropertyName = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.propertyName#">
    	where id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Cookie.ReturnAndBookedID#">
 	</cfquery>

</cfif>

<!---END: give the return and book feature credit--->

<!--- User has chosen to enroll in the Guest Loyalty Program --->
<cfif isdefined('form.enroll_user_glp') and form.enroll_user_gp eq 'yes'>
	<cfinclude template="_enroll_user_glp.cfm">
</cfif>

<div class="booking booking-confirm container">

  <div class="row clearfix">
    <div class="col-md-12">
      <div class="page-header">
        <p class="h3">Booking Confirmation</p>
      </div>
    </div>
  </div>

  <div class="row clearfix">
    <div class="col-md-12">
      <cfoutput>
				<p>Thank you <b>#form.firstname# #form.lastname#</b> for selecting your accommodations with <b>#cgi.http_host#</b>.</p>
				<p><strong>Your reservation code is: #request.reservationCode#</strong></p>
			</cfoutput>
    </div>

		<div class="col-md-6 col-sm-6 col-xs-12">
			<div class="panel panel-default">
				<div class="panel-body booking-panel">
					<p class="h3">User Information</p>
					<div>
						<cfoutput>
						<p>Name: #form.firstname# #form.lastname#</p>
						<p>Address: #form.address1# <cfif isdefined('form.address2') and len(form.address2)>#form.address2#</cfif></p>
						<p>#form.city#, #form.state# #form.zip#</p>
						
						<cfset totalguests = form.numAdults />

						<cfif isDefined('form.numChild')>
							<cfset totalguests += val(form.numChild) />
						</cfif>

						<p>Visitors: #totalguests#</p>
						
						<cfif isdefined('form.numPets') and form.numPets gt 0>
							<p>Num Pets: #form.numPets#</p>
						</cfif>
						
						<cfif isdefined('form.adultages')>
							<p>Adult Ages: #form.adultages#</p>
						</cfif>

						<cfif isdefined('form.childages')>
							<p>Child Ages: #form.childages#</p>
						</cfif>
						</cfoutput>
					</div>
				</div>
			</div>
		</div>

		<div class="col-md-6 col-sm-6 col-xs-12">
			<div class="panel panel-default">
				<div class="panel-body booking-panel">
					<p class="h3">Unit Information</p>
					<div>
						<cfoutput>
						<p>Name: #form.propertyName# - Unitcode: #form.propertyID#</p>
						<p>Check In: #form.strCheckin#</p>
						<p>Check Out: #form.strCheckout#</p>
						<p>Location: #form.propertyCity#, #form.propertyState#</p>
						</cfoutput>
					</div>
				</div>
			</div>
		</div>

		<div class="col-md-12 col-sm-12 col-xs-12">
			<div class="panel panel-default">
				<div class="panel-body booking-panel">
					<p class="h3">Summary of Charges</p>
					<div>
						<cfoutput>																	
							
							<cfif isdefined('form.travelInsurance') and form.travelInsurance is "true">
								<p>Total Amount for Reservation: #DollarFormat(form.TotalWithInsurance)#</p>
								<p>You purchased travel insurance for #DollarFormat(form.tripinsuranceamount)#</p>
							<cfelse>
								<p>Total Amount for Reservation: #DollarFormat(form.Total)#</p>
							</cfif>

						</cfoutput>
					</div>
				</div>
			</div>
		</div>

	</div>

</div><!-- END booking container -->

<cfinclude template="components/footer.cfm">