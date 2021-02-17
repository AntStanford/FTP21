
<!---
Function index:

bookNow

checkout

getCalendarData

getCalendarDataForDatePickers

getCalendarRates

getDetailRates

getFeaturedProperties

getMinMaxAmenities

getMinMaxPrice

getProperty

getPropertyAmenities

getPropertyPhotos

getPropertyPriceRange

getPropertyRates

getPropertyReviews

getSearchResults

getSearchResultsProperty

setGoogleAnalytics

setMetaData

submitLeadToThirdParty

getDistinctTypes

getDistinctAreas

getDistinctViews

getRandomProperties

getSearchFilterCount

getPriceBasedOnDates
--->



<cfcomponent hint="Homeaway-Property Plus-v12 CFC">

    <cffunction name="init" access="public" output="false" hint="constructor">
      <cfargument name="settings" type="struct" required="true" hint="settings" />
      <cfset variables.settings = arguments.settings>
      <cfreturn this />
   </cffunction>

   <cffunction name="booknow" returnType="string" hint="Used in book-now_.cfm to check availability and get pricing for the checkout page">

		<cfargument name="params" required="true">

		<cfif isdefined('arguments.params.strcheckin')>
			<cfset var strcheckin = arguments.params.strcheckin>
		</cfif>

		<cfif isdefined('arguments.params.strcheckout')>
			<cfset var strcheckout = arguments.params.strcheckout>
		</cfif>

		<cfif isdefined('arguments.params.propertyid')>
			<cfset var propertyid = arguments.params.propertyid>
		</cfif>

		<cfif isdefined('arguments.params.numAdults')>
			<cfset var numAdults = arguments.params.numAdults>
		</cfif>

		<cfif isdefined('arguments.params.numChildren')>
			<cfset var numChildren = arguments.params.numChildren>
		</cfif>

		<cfif isdefined('arguments.params.useraction')>
			<cfset var useraction = arguments.params.useraction>
		<cfelse>
			<cfset var useraction = 'remove_insurance'>
		</cfif>

		<cfset travelinsuranceAmt = 0>
		<cfset intNights = DateDiff('d',strcheckin,strcheckout)>

		<cfprocessingdirective suppresswhitespace="yes">
		<cfsavecontent variable="XMLvar">
		<cfoutput>
		<?xml version="1.0" encoding="utf-8"?>
		<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
		  <soap12:Body>
		    <getReservationQuery xmlns="http://www.instantsoftware.com/SecureWeblinkPlusAPI">
		      <objResQueryInfo>
		        <strUserId>#settings.booking.strUserId#</strUserId>
		        <strPassword>#settings.booking.strPassword#</strPassword>
		        <strCOID>#settings.booking.strCOID#</strCOID>
		        <strCheckIn>#strCheckIn#</strCheckIn>
		        <intNights>#intNights#</intNights>
		        <strProperty>#propertyid#</strProperty>
		        <strFName>first name</strFName>
		        <strLName>last name</strLName>
		        <strAddress1>6649 Beach Drive SW</strAddress1>
		        <strAddress2></strAddress2>
		        <strCity>Ocean Isle Beach</strCity>
		        <strState>NC</strState>
		        <strZIP>28470</strZIP>
		        <strProvince></strProvince>
		        <strCountry>USA</strCountry>
		        <strHPhone>9105756095</strHPhone>
		        <strWPhone>9105756095</strWPhone>
		        <strEmail>9105756095</strEmail>
		        <strPromotionCode><cfif isdefined("form.promocode")>#form.promoCode#</cfif></strPromotionCode>
		        <intAdults>#numAdults#</intAdults>
		        <intChildren>#numChildren#</intChildren>
		        <strHowHeard></strHowHeard>
		        <blnSendMail>No</blnSendMail>
		        <strResType></strResType>
		        <cfif isdefined('useraction') and useraction eq 'add_insurance'>
		         <objInsuranceRequest>
		            <blnAcceptTravelInsurance>true</blnAcceptTravelInsurance>
		         </objInsuranceRequest>
		       <cfelse>
		         <objInsuranceRequest>
		            <blnAcceptTravelInsurance>false</blnAcceptTravelInsurance>
		         </objInsuranceRequest>
		       </cfif>
		      </objResQueryInfo>
		    </getReservationQuery>
		  </soap12:Body>
		</soap12:Envelope>
		</cfoutput>
		</cfsavecontent>
		</cfprocessingdirective>

		<cfset XMLVar = trim(XMLVar)>

		<cfsavecontent variable="HEADERS">
		<cfoutput>Content-Type: application/soap+xml; charset=utf-8#settings.booking.CRLF#Content-Length: #len(XMLVar)##settings.booking.CRLF#SOAPAction:getReservationQuery#settings.booking.CRLF#</cfoutput>
		</cfsavecontent>

		<cftry>

			<cfif cgi.HTTP_USER_AGENT does not contain 'bot'>

			   <cfhttp url="https://secure.instantsoftwareonline.com/StayUSA/ChannelPartners/wsWeblinkPlusAPI.asmx" method="post" result="httpResponse" timeout="20">
			      <cfhttpparam type="header" name="SOAPAction" value="http://www.instantsoftware.com/SecureWeblinkPlusAPI/getReservationQuery"/>
			      <cfhttpparam type="header" name="accept-encoding" value="no-compression" />
			      <cfhttpparam type="xml" value="#trim( xmlVar )#" />
			   </cfhttp>

			   <cfset res = httpresponse.filecontent>

			   <cfif isdefined('RES') and isXML(RES)>

			   	<cfset XMLString = XMLParse(RES)>

			   	<cfif isDefined('XMLString.Envelope.Body.Fault.Reason')>

						  <cfset insertAPILogEntry('Homeaway.cfc->booknow->'&cgi.script_name,xmlVar,XMLString)>
						  <cfset apiresponse = XMLString.Envelope.Body.Fault.Reason.Text.xmlText>

			   	<cfelseif isDefined('XMLString.envelope.body.getReservationQueryResponse')>

			   		<cfset insertAPILogEntry('Homeaway.cfc->booknow->'&cgi.script_name,xmlVar,XMLString)>

						<cfset dblTotalGoods = XMLString.Envelope.Body.getReservationQueryResponse.getReservationQueryResult.dblTotalGoods.XmlText>
						<cfset dblTotalTax = XMLString.Envelope.Body.getReservationQueryResponse.getReservationQueryResult.dblTotalTax.XmlText>
						<cfset dblTotalCost = XMLString.Envelope.Body.getReservationQueryResponse.getReservationQueryResult.dblTotalCost.XmlText>
						<cfset arrayOfCharges = XMLString.Envelope.Body.getReservationQueryResponse.getReservationQueryResult.arrCharges>
						<cfset arrayOfDeposits = XMLString.Envelope.Body.getReservationQueryResponse.getReservationQueryResult.arrPayments.clsPayment>
						<cfset dblrate = XMLString.Envelope.Body.getReservationQueryResponse.getReservationQueryResult.arrCharges.clsCharge[1].dblAmount.xmltext>
  						<cfset reservationResult = XMLString.Envelope.Body.getReservationQueryResponse.getReservationQueryResult />
					   <cfset blnHasCSA = XMLString.Envelope.Body.getReservationQueryResponse.getReservationQueryResult.blnHasCSA.XmlText />
					   <cfset dlbCSAAmount = XMLString.Envelope.Body.getReservationQueryResponse.getReservationQueryResult.dblCSAAmount.XmlText />

					  	<cfif blnHasCSA eq 'true' and dlbCSAAmount gt 0>
					  		<cfset travelinsuranceAmt = dlbCSAAmount>
					  	</cfif>

  						<cfsavecontent variable="APIResponse">
  						<cfoutput>
  							<table class="table table-striped">
								<cfif arraylen(reservationResult.arrCharges.clsCharge) gt 0>
									<cfloop from = "1" to ="#arraylen(reservationResult.arrCharges.clsCharge)#" index = "index">
										<cfset description = reservationResult.arrCharges.clsCharge[index].strDesc.XMLText>
										<cfset amount = reservationResult.arrCharges.clsCharge[index].dblAmount.XMLText>
										<tr>
											<th>#description#</th>
											<td align="right">#DollarFormat(amount)#</td>
										</tr>
										<cfif description contains 'insurance' or description contains 'red sky'>
											<cfset travelinsuranceAmt = amount>
										</cfif>
									</cfloop>
								</cfif>
								<cfif blnHasCSA eq 'true' and dlbCSAAmount gt 0 and isdefined('useraction') and useraction eq 'add_insurance'>
									<tr>
										<th>Travel Insurance</th>
										<td align="right">#DollarFormat(dlbCSAAmount)#</td>
									</tr>
								</cfif>
								 <tr>
							      <th>Sub-Total</th>
							      <td align="right">#DollarFormat(dblTotalGoods)#</td>
							    </tr>
							    <tr>
							      <th>Taxes</th>
							      <td align="right">#DollarFormat(dblTotalTax)#</td>
							    </tr>
							    <tr class="alert alert-success">
							      <th><strong>Total Amount</strong></th>
							      <td align="right" amount="#dblTotalCost#" id="totalfromapi"><strong>#DollarFormat(dblTotalCost)#</strong></td>
							    </tr>
							   </table>
							   <b>Deposits</b>
							   <table class="table table-striped">
								<cfif arraylen(arrayOfDeposits) gt 0>
					            <cfloop from="1" to="#arraylen(arrayOfDeposits)#" index="i">
					               <cfset tempDate = replace(xmlstring.envelope.body.getReservationQueryResponse.getReservationQueryResult.arrPayments.clsPayment[i].dtduedate.xmltext,'T00:00:00','')>
					               <tr>
					                  <td colspan="2">#DollarFormat(xmlstring.envelope.body.getReservationQueryResponse.getReservationQueryResult.arrPayments.clsPayment[i].dblAmount.xmltext)# is due on #DateFormat(tempDate,'mm/dd/yyyy')#</td>
					               </tr>
					            </cfloop>
          					</cfif>
  								</table>
  								<h3>Protect Your Trip</h3>
								<b>Travel Insurance</b> - Protect your payments should you have to cancel.
								<p><input type="radio" name="travel_insurance" value="add_insurance"    id="addinsurance"    data-serviceid="" data-tripinsuranceamount="#travelinsuranceAmt#" <cfif useraction is 'add_insurance'>CHECKED</cfif>> <label for="addinsurance">Add travel insurance for #DollarFormat(travelinsuranceAmt)#</label></p>
								<p><input type="radio" name="travel_insurance" value="remove_insurance" id="removeinsurance" data-serviceid="" data-tripinsuranceamount="#travelinsuranceAmt#" <cfif useraction is 'remove_insurance' or useraction eq ''>CHECKED</cfif> > <label class="nothanks" for="removeinsurance">No thanks, I am not interested in travel insurance</label></p>
  						</cfoutput>
  						</cfsavecontent>

			   	</cfif>

			   </cfif>

			</cfif>

		<cfcatch>

			<cfif isdefined("ravenClient")>
				<cfset ravenClient.captureException(cfcatch)>
			</cfif>

			<!--- <cfset insertAPILogEntry(cgi.script_name,xmlVar,"CFCATCH = #cfcatch.message#")> --->

			<cfset apiresponse = cfcatch.message>

		</cfcatch>

		</cftry>

		<!--- Let's make sure the user is not brining more guests than allowed --->
		<cfset totalGuests = numAdults + numChildren>

		<cfif totalGuests gt maxoccupancy>

			<cfset apiresponse = 'The total number of adults + children exceeds the max occupancy of this unit. Please update the form and try again.'>

		</cfif>

		<cfreturn apiresponse>

   </cffunction>



	<cffunction name="checkout" returnType="string" hint="Book and confirm the reservation">

   	<cfargument name="form" required="true">

   	<!--- Local variables --->
   	<cfparam name="reservationCode" default="">
		<cfparam name="form.couponcode" default="">

   	<!--- Info needed for HAPI --->
   	<cfset ServerUrl = settings.booking.hapiTokenURL>
		<cfset clientID = settings.booking.hapiTokenClientID>
		<cfset apiKey = settings.booking.hapiTokenApiKey>

		<cfif ServerUrl eq '' OR clientID eq '' or apiKey eq ''>
		   <cfset session.errormessage = 'HAPI settings are missing in the settings table.'>
		   <cflocation addToken="no" url="/#settings.booking.dir#/booking-error.cfm">
		</cfif>

		<!--- Time in milliseconds --->
		<cfset localTimeUTCSeconds = #DateDiff("s", "December 31 1969 19:00:00", now())#>
		<cfset timeinMilliseconds = localTimeUTCSeconds & '000'>

		<!--- digest is created by appending the time and api key and then encrypting it --->
		<cfset secureKey = GenerateSecretKey('AES')>
		<cfset digest = timeinMilliseconds & ApiKey>
		<cfset digest = Hash(digest,'SHA-256')>
		<cfset digest = Trim(digest)>
		<cfset digest = Lcase(digest)>
		<cfset finalUrl = "#ServerUrl#/tokens?time=#timeinMilliseconds#&digest=#digest#&clientId=#ClientId#">

		<cfprocessingdirective suppresswhitespace="yes">
		<cfsavecontent variable="mydata">
		<cfoutput>
			<tokenForm>
				<tokenType>CC</tokenType>
				<value>#form.ccnumber#</value>
			</tokenForm>
		</cfoutput>
		</cfsavecontent>
		</cfprocessingdirective>

		<cfset XMLVar = trim(mydata)>

		<cfsavecontent variable="HEADERS">
		<cfoutput>Content-Type: application/xml;charset=utf-8#settings.booking.CRLF#Content-Length:#len(XMLVar)##settings.booking.CRLF#</cfoutput>
		</cfsavecontent>

   	<cftry>

		   <CFX_HTTP METHOD="POST" URL="#finalUrl#" HEADERS=#HEADERS# BODY=#XMLvar# OUT="RES" SSL="5">

		   <cfif status eq 'ER'>

		      <cfset variables.e = errn & "--" & msg>
		      <cfif isdefined("ravenClient")>
		         <cfset ravenClient.captureMessage("Homeaway.cfc->checkout, location A. Error: #variables.e#")>
		      </cfif>
		      <cfset insertAPILogEntry(settings.id, cgi.server_name, 'Homeaway.cfc->checkout', XMLVarForApiLog, "API Error: #variables.e# ~ Location A")>

		      <cfset session.errorMessage = variables.e>
		      <cflocation addToken="no" url="/#settings.booking.dir#/booking-error.cfm">

		   </cfif>

		<cfcatch>

		  <cfif isdefined("ravenClient")>
		      <cfset ravenClient.captureMessage('Homeaway.cfc->checkout, location B. cfcatch =' & cfcatch.message)>
		  </cfif>
		  <cfset insertAPILogEntry(cgi.script_name,XMLVarForApiLog, "cfcatch: #cfcatch.message# ~ Location B")>
		  <cfset session.errorMessage = cfcatch.message>
		  <cflocation addToken="no" url="/#settings.booking.dir#/booking-error.cfm">
		</cfcatch>


		</cftry>


		<cfif isdefined('RES') and isXML(RES)>

		  <cfset XMLString = XMLParse(RES)>

		  <cfif isDefined("XMLString.error.msg.xmltext")>

		    <cfif isdefined("ravenClient")>
		      <cfset ravenClient.captureMessage('Homeway.cfc->checkout. location C. XMLString =' & XMLString)>
		    </cfif>

		    <cfset insertAPILogEntry(cgi.script_name,XMLVarForApiLog,"XMLString = " & XMLString & " ~ location C")>

		    <cfset session.errorMessage = XMLString.error.msg.xmltext>
		    <cflocation addToken="no" url="/#settings.booking.dir#/booking-error.cfm">

		  <cfelse>

		    <cfset MaskedCardNumber = xmlstring.token.maskedvalue.xmltext>
		    <cfset CardToken = xmlstring.token.xmlattributes.id>

		  </cfif>

		<cfelse>
		   <cfset insertAPILogEntry(cgi.script_name,XMLVarForApiLog,"RES was not defined ~ Locattion C")>
		   <cfset session.errorMessage = 'RES is not defined.'>
		   <cflocation addToken="no" url="/#settings.booking.dir#/booking-error.cfm">
		</cfif>

		<cfset numNights = DateDiff('d',form.strCheckin,form.strCheckout)>

   	<cfprocessingdirective suppresswhitespace="yes">
		<cfsavecontent variable="XMLvar">
		<cfoutput>
		<?xml version="1.0" encoding="utf-8"?>
		<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
		<soap12:Header>
		    <clsPartnerAuthentication xmlns="http://www.instantsoftware.com/SecureWeblinkPlusAPI">
		      <strUserID>#settings.booking.strUserId#</strUserID>
		      <strPassword>#settings.booking.strPassword#</strPassword>
		    </clsPartnerAuthentication>
		</soap12:Header>
		<soap12:Body>
		    <createBooking xmlns="http://www.instantsoftware.com/SecureWeblinkPlusAPI">
		      <objBookingRequest>
		        <strCOID>#settings.booking.strCOID#</strCOID>
		        <dtCheckIn>#DateFormat(form.strcheckin,'yyyy-mm-dd')#</dtCheckIn>
		        <intNights>#numNights#</intNights>
		        <strProperty>#form.propertyid#</strProperty>
		        <intAdults>#form.numAdults#</intAdults>
		        <intChildren>#form.numChildren#</intChildren>
		        <strResType>WebBooking</strResType>
		        <strPromotionCode>#form.hiddenPromoCode#</strPromotionCode>
		        <strTourOperator></strTourOperator>
		        <objGuestDetails>
		          <strFirstName>#form.firstname#</strFirstName>
		          <strLastName>#form.lastname#</strLastName>
		          <strMiddleInitial></strMiddleInitial>
		          <objAddress>
		            <strAddress1>#form.address1#</strAddress1>
		            <strAddress2>#form.address2#</strAddress2>
		            <strCity>#form.city#</strCity>
		            <strState>#form.state#</strState>
		            <strProvince></strProvince>
		            <strZip>#form.zip#</strZip>
		            <strCountry>#form.country#</strCountry>
		            <strHomePhone>#form.phone#</strHomePhone>
		            <strWorkPhone>#form.phone#</strWorkPhone>
		          </objAddress>
		          <strEmail>#form.email#</strEmail>
		        </objGuestDetails>
		        <objCreditCardDetails>
		          <strCCNumber></strCCNumber>
		          <strToken>#CardToken#</strToken>
		          <strCCType>#form.ccType#</strCCType>
		          <intExpMonth>#form.ccMonth#</intExpMonth>
		          <intExpYear>#form.ccYear#</intExpYear>
		          <strName>#form.ccFirstName# #form.ccLastName#</strName>
		          <objBillingAddress>
		            <strAddress1>#form.billingAddress#</strAddress1>
		            <strAddress2></strAddress2>
		            <strCity>#form.billingCity#</strCity>
		            <strState>#form.billingState#</strState>
		            <strProvince></strProvince>
		            <strZip>#form.billingZip#</strZip>
		            <strCountry>#form.billingCountry#</strCountry>
		            <strHomePhone>#form.phone#</strHomePhone>
		            <strWorkPhone>#form.phone#</strWorkPhone>
		          </objBillingAddress>
		          <strEmail>#form.email#</strEmail>
		        </objCreditCardDetails>
		        <cfif isdefined('form.addInsurance') and form.addInsurance eq 'true'>
		            <blnAcceptCSA>true</blnAcceptCSA>
		        <cfelse>
		            <blnAcceptCSA>false</blnAcceptCSA>
		        </cfif>
		        <dblCCAmount>#form.total#</dblCCAmount>
		        <dblForcedRent>0</dblForcedRent>
		        <blnCleaning>false</blnCleaning>
		        <strComments>#form.comments#</strComments>
		        <strMarketID></strMarketID>
		        <strOwnerCode></strOwnerCode>
		        <strMarketingCategory></strMarketingCategory>
		        <strMarketingSource></strMarketingSource>
		      </objBookingRequest>
		    </createBooking>
		  </soap12:Body>
		</soap12:Envelope>
		</cfoutput>
		</cfsavecontent>
		</cfprocessingdirective>

		<cfset XMLVar = trim(XMLVar)>

		<cfsavecontent variable="HEADERS">
		<cfoutput>Content-Type: application/soap+xml; charset=utf-8#settings.booking.crlf#Content-Length: #len(XMLVar)##settings.booking.crlf#SOAPAction:createBooking#settings.booking.crlf#</cfoutput>
		</cfsavecontent>

		<cftry>

			<cfhttp url="https://secure.instantsoftwareonline.com/StayUSA/ChannelPartners/wsWeblinkPlusAPI.asmx" method="post" result="httpResponse">
		      <cfhttpparam type="header" name="SOAPAction" value="http://www.instantsoftware.com/SecureWeblinkPlusAPI/createBooking"/>
		      <cfhttpparam type="header" name="accept-encoding" value="no-compression" />
		      <cfhttpparam type="xml" value="#trim(xmlVar)#" />
		   </cfhttp>

		   <cfset res = httpresponse.filecontent>

		   <cfif isdefined('RES') and isXML(RES)>

		   	<cfset insertAPILogEntry(cgi.script_name,xmlVar,RES)>

		   	<cfset XMLString = XMLParse(RES)>

		   	<cfif isDefined("XMLString.Envelope.Body.Fault.Reason")>

		         <cfif isdefined("ravenClient")>
		            <cfset ravenClient.captureMessage('function: checkout, location D. XMLString =' & XMLString)>
		         </cfif>

		         <cfset session.errorMessage = XMLString.Envelope.Body.Fault.Reason.Text.xmlText>
		         <cflocation addToken="no" url="/#settings.booking.dir#/booking-error.cfm">

				<cfelse>

					<cfset reservationCode  = XMLString.Envelope.Body.createBookingResponse.createBookingResult.strBookingNo.xmlText>

					<!--- Log the booking locally to use for reporting purposes --->
					<cfinclude template="/booking/_log-booking.cfm">

					<cfinclude template="/booking/_confirm-email.cfm">

				</cfif>

		   </cfif>

		  <cfcatch>

		      <cfif isdefined("ravenClient")>
		            <cfset ravenClient.captureMessage('function: checkout, location E. cfcatch =' & cfcatch.message)>
		      </cfif>

		      <cfset insertAPILogEntry(cgi.script_name,xmlVar,"CFCATCH.  #cfcatch.message#  #cfcatch.detail#, checkout function, location E.")>
		      <cfset session.errorMessage = cfcatch.message>
		      <cflocation addToken="no" url="/#settings.booking.dir#/booking-error.cfm">
		  </cfcatch>

		</cftry>

		<cfreturn reservationCode>

   </cffunction>



   <cffunction name="getCalendarData" returnType="string" hint="Used in _calendar-tab.cfm to get all the non-available dates">

   	<cfargument name="strpropid" required="true">
   	<cfset nonAvailList = ''>

		<cfquery name="nonavaildates" dataSource="#variables.settings.booking.dsn#">
			select dtfromdate,dttodate
			from pp_property_non_available_dates
			where strPropId = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.strPropId#">
		</cfquery>

		<cfloop query="nonavaildates">
			<cfset formattedStartDate = DateFormat(dtfromdate,'mm/dd/yyyy')>
			<cfset nonAvailList = ListAppend(nonAvailList,formattedStartDate)>

			<!--- Get the difference in num nights between start date and end date --->
			<cfset numNights = DateDiff('d',dtfromdate,dttodate)>

			<cfloop from="1" to="#numNights#" index="i">
				<cfset newDate = DateAdd('d',i,dtfromdate)>
				<cfset newDate = DateFormat(newDate,'mm/dd/yyyy')>
				<cfset nonAvailList = ListAppend(nonAvailList,newDate)>
			</cfloop>
		</cfloop>

		<cfreturn nonAvailList>

   </cffunction> <!--- end of getCalenderData function --->


   <cffunction name="getCalendarDataForDatePickers" returnType="string" hint="Used to produce smart date pickers on the PDP">

   	<cfargument name="strpropid" required="true">
   	<cfset nonAvailListForDatepicker = ''>
   	<cfset checkInOnlyList = "" />
		<cfset checkOutOnlyList = "" />

   	<cfquery name="nonavaildates" dataSource="#variables.settings.booking.dsn#">
			select dtfromdate,dttodate
			from pp_property_non_available_dates
			where strPropId = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.strPropId#">
		</cfquery>

		<cfloop from="1" to="#nonavaildates.recordcount#" index="i">

			<cfset myStartDate = DateFormat(nonavaildates['dtFromDate'][i],'mm/dd/yyyy')>
			<cfset myEndDate = DateFormat(nonavaildates['dtToDate'][i],'mm/dd/yyyy')>
			<cfset checkOutOnlyList = listAppend( checkOutOnlyList, myStartDate ) />
			<cfset checkInOnlyList = listAppend( checkInOnlyList, myEndDate ) />

			<!--- First record, go ahead and add 1 day to the startdate and add it to the list --->
			<cfif i eq 1>
				<cfset myStartDate = dateAdd('d',1,myStartDate)>
				<cfset myStartDate = DateFormat(myStartDate,'mm/dd/yyyy')>
				<cfset nonAvailListForDatepicker = ListAppend(nonAvailListForDatepicker,myStartDate)>

			<cfelse>

				<cfset prevRowEndDate = nonavaildates['dtToDate'][i-1]> <!--- Get the previous records's end date --->
				<cfset prevRowEndDate = DateFormat(prevRowEndDate,'mm/dd/yyyy')>

				<cfif myStartDate neq prevRowEndDate> <!--- if the current row's start date neq previous row's end date, add 1 --->
					<cfset myStartDate = dateAdd('d',1,myStartDate)>
					<cfset myStartDate = DateFormat(myStartDate,'mm/dd/yyyy')>
					<cfset nonAvailListForDatepicker = ListAppend(nonAvailListForDatepicker,myStartDate)>

				<cfelse> <!--- the current row's start date DOES equal the previous row's end date, DO NOT ADD 1, but add to the list --->

					<cfset nonAvailListForDatepicker = ListAppend(nonAvailListForDatepicker,myStartDate)>

				</cfif>
			</cfif>

			<cfset newEndDate = DateAdd('d',-1,myEndDate)> <!--- always subtract 1 from the end date --->
			<cfset numNights = DateDiff('d',myStartDate,newEndDate)> <!--- get the difference between start date and end date --->

			<cfloop from="1" to="#numNights#" index="i"> <!--- add i to the start date and add to the list --->
				<cfset newDate = DateAdd('d',i,myStartDate)>
				<cfset newDate = DateFormat(newDate,'mm/dd/yyyy')>
				<cfset nonAvailListForDatepicker = ListAppend(nonAvailListForDatepicker,newDate)>
			</cfloop>

		</cfloop>

		<cfreturn nonAvailListForDatepicker>

   </cffunction>


   <cffunction name="getCalendarRates" returnType="numeric" hint="Used in _calendar-tab.cfm to display weekly price on the calendar">

   	<cfargument name="strpropid" required="true">
   	<cfargument name="thedate" required="true">

   	<cfset var qryGetCalendarRates = "">

		<cfquery name="qryGetCalendarRates" dataSource="#variables.settings.booking.dsn#">
			select dblrate as theRate
			from pp_season_rates where strChargeBasis = 'Weekly'
			and strpropid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.strpropid#">
			and '#thedate#' between dtBeginDate and dtEndDate
		</cfquery>

		<cfif qryGetCalendarRates.recordcount gt 0 and qryGetCalendarRates.theRate gt 0>
			<cfreturn qryGetCalendarRates.theRate>
		<cfelse>
			<cfreturn 0>
		</cfif>

   </cffunction> <!--- end of getCalendarRates function --->



   <cffunction name="getDetailRates" returnType="string" hint="Used on the property detail page to check availability and retrieve summary of fees">

   	<cfargument name="strpropid" required="true">
   	<cfargument name="strcheckin" required="true">
   	<cfargument name="strcheckout" required="true">

   	<cfset variable.intNights = DateDiff('d',arguments.strcheckin,arguments.strcheckout)>

   	<cfprocessingdirective suppresswhitespace="yes">
		<cfsavecontent variable="XMLvar">
		<cfoutput>
		<?xml version="1.0" encoding="utf-8"?>
		<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
		  <soap12:Body>
		    <getReservationQuery xmlns="http://www.instantsoftware.com/SecureWeblinkPlusAPI">
		      <objResQueryInfo>
		        <strUserId>#settings.booking.strUserId#</strUserId>
		        <strPassword>#settings.booking.strPassword#</strPassword>
		        <strCOID>#settings.booking.strCOID#</strCOID>
		        <strCheckIn>#arguments.strcheckin#</strCheckIn>
		        <intNights>#variable.intNights#</intNights>
		        <strProperty>#strpropid#</strProperty>
		        <strFName>first name</strFName>
		        <strLName>last name</strLName>
		        <strAddress1>6649 Beach Drive SW</strAddress1>
		        <strAddress2></strAddress2>
		        <strCity>Ocean Isle Beach</strCity>
		        <strState>NC</strState>
		        <strZIP>28470</strZIP>
		        <strProvince></strProvince>
		        <strCountry>USA</strCountry>
		        <strHPhone>9105756095</strHPhone>
		        <strWPhone>9105756095</strWPhone>
		        <strEmail>9105756095</strEmail>
		        <intAdults>1</intAdults>
		        <intChildren>0</intChildren>
		        <strHowHeard></strHowHeard>
		        <blnSendMail>No</blnSendMail>
		        <strResType></strResType>
		      </objResQueryInfo>
		    </getReservationQuery>
		  </soap12:Body>
		</soap12:Envelope>
		</cfoutput>
		</cfsavecontent>
		</cfprocessingdirective>

		<cfset XMLVar = trim(XMLVar)>

		<cfsavecontent variable="HEADERS">
		<cfoutput>Content-Type: application/soap+xml; charset=utf-8#settings.booking.CRLF#Content-Length: #len(XMLVar)##settings.booking.CRLF#SOAPAction:getReservationQuery#settings.booking.CRLF#</cfoutput>
		</cfsavecontent>

		<cftry>

			<cfhttp url="https://secure.instantsoftwareonline.com/StayUSA/ChannelPartners/wsWeblinkPlusAPI.asmx" method="post" result="httpResponse" timeout="20">
				<cfhttpparam type="header" name="SOAPAction" value="http://www.instantsoftware.com/SecureWeblinkPlusAPI/getReservationQuery"/>
				<cfhttpparam type="header" name="accept-encoding" value="no-compression" />
				<cfhttpparam type="xml" value="#trim( xmlVar )#" />
			</cfhttp>

			<cfset res = httpresponse.filecontent>

			<cfif isdefined('RES') and isXML(RES)>

				<cfset XMLString = XMLParse(RES)>

				<cfif isDefined("XMLString.Envelope.Body.Fault.Reason")>

					 <cfsavecontent variable="APIResponse">
				      <cfoutput>
				         <div class="alert alert-danger">
				            <p>#XMLString.Envelope.Body.Fault.Reason.Text.xmlText#</p>
				         </div>
				      </cfoutput>
				   </cfsavecontent>

				<cfelse>

					<cfset dblTotalGoods = XMLString.Envelope.Body.getReservationQueryResponse.getReservationQueryResult.dblTotalGoods.XmlText>
					<cfset dblTotalTax = XMLString.Envelope.Body.getReservationQueryResponse.getReservationQueryResult.dblTotalTax.XmlText>
					<cfset dblTotalCost = XMLString.Envelope.Body.getReservationQueryResponse.getReservationQueryResult.dblTotalCost.XmlText>
					<cfset arrayOfCharges = XMLString.Envelope.Body.getReservationQueryResponse.getReservationQueryResult.arrCharges>
					<cfset arrayOfDeposits = XMLString.Envelope.Body.getReservationQueryResponse.getReservationQueryResult.arrPayments>
					<cfset dblrate = XMLString.Envelope.Body.getReservationQueryResponse.getReservationQueryResult.arrCharges.clsCharge[1].dblAmount.xmltext>
			  		<cfset reservationResult = XMLString.Envelope.Body.getReservationQueryResponse.getReservationQueryResult />

			  		<cfsavecontent variable="APIResponse">
			  			<cfoutput>
			  			<ul class="property-cost-list">
			  				<cfif arraylen(reservationResult.arrCharges.clsCharge) gt 0>
			  					<cfloop from = "1" to ="#arraylen(reservationResult.arrCharges.clsCharge)#" index = "index">
			  						<li>#reservationResult.arrCharges.clsCharge[index].strDesc.XMLText# <span class="text-right">#DollarFormat(reservationResult.arrCharges.clsCharge[index].dblAmount.XMLText)#</span></li>
			  					</cfloop>
			  				</cfif>
			  				<li>Sub-Total <span class="text-right">#DollarFormat(dblTotalGoods)#</span></li>
			  				<li>Taxes <span class="text-right">#DollarFormat(dblTotalTax)#</span></li>
			  				<li><strong>Total <span class="text-right">#DollarFormat(dblTotalCost)#</span></strong></li>
			  			</ul>
              <!-- BOOK NOW BUTTON -->
              <a id="detailBookBtn" class="btn detail-book-btn site-color-1-bg site-color-1-lighten-bg-hover text-white" href="#settings.booking.bookingURL#/#settings.booking.dir#/book-now.cfm?propertyid=#arguments.strpropid#&strcheckin=#arguments.strcheckin#&strcheckout=#arguments.strcheckout#"><i class="fa fa-check"></i> Book Now</a>
              <a id="splitCostCalc" class="btn site-color-2-bg site-color-2-lighten-bg-hover text-black" type="button" data-toggle="modal" data-target="##splitCostModal" href="/#settings.booking.dir#/_family-calculator.cfm?total=#dblTotalCost#&numnights=#variable.intNights#"><i class="fa fa-calculator"></i> Split Cost Calc</a>
              <input type="hidden" id="splitCalcTotalVal" name="splitCalcTotalVal" value="#dblTotalCost#">
              <input type="hidden" id="splitCalcNumNightVal" name="splitCalcNumNightVal" value="#variable.intNights#">
			  			</cfoutput>
			  		</cfsavecontent>

				</cfif>

			</cfif>

			<cfcatch>
				<cfsavecontent variable="APIResponse">
					<cfoutput>
					<div class="alert alert-danger">
						<p>#cfcatch.message#</p>
					</div>
					</cfoutput>
				</cfsavecontent>
			</cfcatch>

		</cftry>

		<cfreturn apiresponse>

   </cffunction>



   <cffunction name="getFeaturedProperties" returnType="query" hint="Returns the featured properties typically displayed on the homepage">

         <cfquery name="propertyCheck" dataSource="#variables.settings.dsn#">
            select strpropid from cms_featured_properties order by rand()
         </cfquery>

         <cfif propertyCheck.recordcount gt 0 and len(propertyCheck.strpropid)>

            <cfset var propList = ValueList(propertyCheck.strpropid)>

            <cfquery name="getProperties" dataSource="#variables.settings.booking.dsn#">
               select
                  strpropid as propertyid,
                  strname as name,
                  dblbeds as bedrooms,
                  dblbaths as bathrooms,
                  intoccu as sleeps,
                  defaultphoto as photo,
                  seopropertyname,
                  strAddress1 as address
               from pp_propertyinfo
               where strpropid IN (<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#propList#" list="yes">)
            </cfquery>

         <cfelse>

            <cfquery name="getProperties" dataSource="#variables.settings.booking.dsn#">
               select
                  strpropid as propertyid,
                  strname as name,
                  dblbeds as bedrooms,
                  dblbaths as bathrooms,
                  intoccu as sleeps,
                  defaultphoto as photo,
                  seopropertyname,
                  strAddress1 as address
               from pp_propertyinfo
               order by rand()
               limit 6
            </cfquery>

         </cfif>

         <cfreturn getProperties>

   </cffunction> <!--- end of getFeaturedProperties --->

   <cffunction name="getMinMaxAmenities" returnType="struct" hint="Returns min/max values for common amenities like bedrooms,bathrooms and occupancy, typically used on refine search sliders">

		<cfset var qryGetMinMaxAmenities = ''>

		<cfquery name="qryGetMinMaxAmenities" datasource="#variables.settings.booking.dsn#">
			SELECT
				min(dblbeds) as minBed,
				max(dblbeds) as maxBed,
				min(dblbaths) as minBath,
				max(dblbaths) as maxBath,
				min(intoccu) as minOccupancy,
				max(intoccu) as maxOccupancy
			FROM
				pp_propertyinfo
		</cfquery>

		<cfset localStruct = StructNew()>

		<cfset localStruct['minBed'] = qryGetMinMaxAmenities.minBed>
		<cfset localStruct['maxBed'] = qryGetMinMaxAmenities.maxBed>
		<cfset localStruct['minBath'] = qryGetMinMaxAmenities.minBath>
		<cfset localStruct['maxBath'] = qryGetMinMaxAmenities.maxBath>
		<cfset localStruct['minOccupancy'] = qryGetMinMaxAmenities.minOccupancy>
		<cfset localStruct['maxOccupancy'] = qryGetMinMaxAmenities.maxOccupancy>

		<cfreturn localStruct>

   </cffunction>



   <cffunction name="getMinMaxPrice" returnType="struct" hint="Returns min/max rates for the refine search price range slider">

		<cfargument name="strcheckin" type="date" required="false">
		<cfargument name="strcheckout" type="date" required="false">

		<cfset var qryGetMinMaxPrice = ''>
		<cfset var strChargeBasis = 'Weekly'>

		<cfif
			isdefined('arguments.strcheckin') and
			len(arguments.strcheckin) and
			isvalid('date',arguments.strcheckin) and
			isdefined('arguments.strcheckout') and
			len(arguments.strcheckout) and
			isvalid('date',arguments.strcheckout) and
			DateDiff('d',arguments.strcheckin,arguments.strcheckout) lt 7
			>

			<cfset strChargeBasis = 'Daily'>

		</cfif>

		<cfquery name="qryGetMinMaxPrice" datasource="#variables.settings.booking.dsn#">
			SELECT
				min(dblrate) as minPrice,
				max(dblrate) as maxPrice
			FROM
				pp_season_rates
			WHERE
				dtBeginDate >= '#DateFormat(now(),"YYYY")#-01-01'
		   AND
		      strChargeBasis = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#strChargeBasis#">
		</cfquery>

		<cfset localStruct = StructNew()>
		<cfset localStruct['minprice'] = int(qryGetMinMaxPrice.minPrice)>
		<cfset localStruct['maxprice'] = ceiling(qryGetMinMaxPrice.maxPrice)>

		<cfreturn localStruct>

   </cffunction>


   <cffunction name="getProperty" returnType="query" hint="Returns all the basic information for a given property">

   	<cfargument name="strpropid" required="false">
   	<cfargument name="slug" required="false">

		<cfset var qryGetProperty = ''>

   	<cfquery name="qryGetProperty" dataSource="#variables.settings.booking.dsn#">
			SELECT
			strname as name,
			strdesc as description,
			seopropertyname,
			strpropid as propertyid,
			defaultPhoto,
			defaultPhoto as largePhoto,
			strtype as type,
			strlocation as location,
			strlocation as view,
			intoccu as sleeps,
			dblbeds as bedrooms,
			dblbaths as bathrooms,
			strcity as city,
			strstate as state,
			'' as checkouttime,
			'' as checkintime,
			latitude,
			longitude,
			IF(featureList like '%Pet Friendly%','Pets Allowed','Pets Not Allowed') as petsallowed,
			'' as address
			from pp_propertyinfo
			<cfif len(arguments.strpropid)>
				where strpropid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.strpropid#">
			<cfelseif len(arguments.slug)>
				where seopropertyname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.slug#">
			</cfif>
		</cfquery>

		<cfif qryGetProperty.recordcount gt 0>

			<!--- take the default photo, find the image name, add the letter 'L' in front of it to produce the large version --->
			<!--- should this be moved to the import scripts eventually? --->
			<cfset smFilename = REMatchNoCase('[^/]+$',qryGetProperty.defaultPhoto)>
			<cfset smFilename = smFilename[1]>
			<cfset lgFilename = 'L' & smFilename>

			<cfset qryGetProperty.largePhoto = replace(qryGetProperty.defaultPhoto,smFilename,lgFilename)>

		</cfif>

		<cfif settings.booking.v12Client eq 'yes'>

			<!--- This query might change per client depending on how they setup pets info --->
			<cfquery name="petCheck" dataSource="#variables.settings.booking.dsn#">
				select attribute_value from pp_attributes where strpropid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.strpropid#">
				and attribute = 'Pets Allowed'
			</cfquery>

			<cfif petCheck.recordcount gt 0 and petCheck.attribute_value does not contain 'no'>
				<cfset qryGetProperty.petsallowed = 'yes'>
			</cfif>

		<cfelse>

			<!--- In this scenario, look in the featureList for the word 'Pet Friendly' to determine if this unit allows pets or not --->
			<cfquery name="petCheck" dataSource="#variables.settings.booking.dsn#">
				select strpropid from pp_propertyinfo where strpropid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.strpropid#">
				and featureList like '%Pet Friendly%'
			</cfquery>

			<cfif petCheck.recordcount gt 0>
				<cfset qryGetProperty.petsallowed = 'yes'>
			</cfif>

		</cfif>

		<cfreturn qryGetProperty>

   </cffunction> <!--- end of getProperty --->



   <cffunction name="getPropertyAmenities" returnType="struct" hint="Returns all the amenities for a given property">

   	<cfargument name="strpropid" required="true">

   	<cfset var qryGetPropertyAmenities = ''>
   	<cfset localStruct = StructNew()>

   	<cfif settings.booking.v12Client eq 'yes'>

   		<cfquery name="qryGetPropertyAmenities" dataSource="#variables.settings.booking.dsn#">
				select * from pp_attributes where strpropid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.strpropid#">
			</cfquery>

			<cfif qryGetPropertyAmenities.recordcount gt 0>

				<cfloop query="qryGetPropertyAmenities">
					<cfset StructInsert(localStruct,qryGetPropertyAmenities.attribute,qryGetPropertyAmenities.attribute_value,true)>
				</cfloop>

			</cfif>

   	<cfelse>

			<cfquery name="qryGetPropertyAmenities" dataSource="#variables.settings.booking.dsn#">
				select featurelist from pp_propertyinfo where strpropid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.strpropid#">
			</cfquery>

			<cfif len(qryGetPropertyAmenities.featurelist)>

				<cfloop list="#qryGetPropertyAmenities.featurelist#" index="i">
					<cfset StructInsert(localStruct,i,'',true)>
				</cfloop>

			</cfif>

		</cfif>

		<cfreturn localStruct>

   </cffunction> <!--- end of getPropertyAmenities --->



   <cffunction name="getPropertyPhotos" returnType="query" hint="Returns all the photos for a given property">

   	<cfargument name="strpropid" required="true">

   	<cfset var qryGetPropertyPhotos = ''>

		<cfquery name="qryGetPropertyPhotos" dataSource="#variables.settings.booking.dsn#">
			select picList
			from pp_propertyinfo
			where strpropid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.strpropid#">
		</cfquery>

		<cfscript>

			newQuery = QueryNew('original,large,thumbnail,caption');

			arr = ListToArray(qryGetPropertyPhotos.picList);

			queryAddRow(newQuery,ArrayLen(arr));

			for (i = 1; i <= ArrayLen(arr); i++)
			{
			    fieldName = arr[i];

			    //append the letter 'L' to the photo name for the large version
			    smFilename = REMatchNoCase('[^/]+$',fieldName);
				 smFilename = smFilename[1];
				 lgFilename = 'L' & smFilename;
				 lgImg = replaceNoCase(fieldName, smFilename, lgFilename);

			    QuerySetCell(newQuery,'large',lgImg,i);
			    QuerySetCell(newQuery,'original',fieldName,i);
			    QuerySetCell(newQuery,'thumbnail',fieldName,i);
			}

		</cfscript>

		<cfreturn newQuery>

   </cffunction> <!--- end of getPropertyPhotos --->



   <cffunction name="getPropertyPriceRange" returnType="string" hint="Returns the min/max price for a given property, used on results and PDP">

   	<cfargument name="unitcode" required="true" type="string">
   	<cfargument name="strcheckin" required="false">

		<cfset var qryGetPropertyPriceRange = ''>

		<cfquery name="qryGetPropertyPriceRange" dataSource="#variables.settings.booking.dsn#">
			select min(dblRate) as minPrice, max(dblRate) as maxPrice
			from pp_season_rates
			where strpropid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.unitcode#">
			and dtBeginDate >= '#DateFormat(now(),"YYYY")#-01-01'
			and strChargeBasis = 'Weekly'

			<cfif isdefined('arguments.strcheckin') and len(arguments.strcheckin)>
				and #createodbcdate(arguments.strcheckin)# between dtBeginDate and dtEndDate
			</cfif>

		</cfquery>

		<cfif qryGetPropertyPriceRange.recordcount gt 0 and len(qryGetPropertyPriceRange.minPrice) and len(qryGetPropertyPriceRange.maxPrice) and qryGetPropertyPriceRange.minPrice neq qryGetPropertyPriceRange.maxPrice>
		  <cfset tempReturn = DollarFormat(qryGetPropertyPriceRange.minPrice) & ' - ' & DollarFormat(qryGetPropertyPriceRange.maxPrice) & ' <small>Per Week</small>'>
		<cfelseif qryGetPropertyPriceRange.recordcount gt 0 and len(qryGetPropertyPriceRange.minPrice) and len(qryGetPropertyPriceRange.maxPrice) and qryGetPropertyPriceRange.minPrice eq qryGetPropertyPriceRange.maxPrice>
			<cfset tempReturn = DollarFormat(qryGetPropertyPriceRange.maxPrice) & ' <small>Per Week</small>'>
		<cfelse>
		  <cfset tempReturn = ''>
		</cfif>

		<cfreturn tempReturn>

   </cffunction>

   <cffunction name="getPropertyRates" returnType="query" hint="Returns all the rates for a given property">

   	<cfargument name="strpropid" required="true">

   	<cfset var qryGetPropertyRates = ''>

   	<cfquery name="qryGetPropertyRates" dataSource="#variables.settings.booking.dsn#">
			select dtBeginDate as start_date,dtEndDate as end_date,
			   (SELECT dblrate from pp_season_rates er2 where strpropid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.strpropid#"> and er2.dtBeginDate = pp_season_rates.dtBeginDate and strChargeBasis = 'Daily') as nightly_rate,
			   (SELECT dblrate from pp_season_rates er3 where strpropid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.strpropid#"> and er3.dtBeginDate = pp_season_rates.dtBeginDate and strChargeBasis = 'Weekly') as weekly_rate
			from
				pp_season_rates where
   			strpropid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.strpropid#">
			group by start_date
			order by start_date
		</cfquery>

		<cfreturn qryGetPropertyRates>

   </cffunction> <!--- end of getPropertyRates --->



    <cffunction name="getPropertyReviews" returnType="struct" hint="Returns reviews from be_reviews">

   	<cfargument name="strpropid" required="true">

   	<cfset var qryGetPropertyReviews = ''>

		<cfquery name="qryGetPropertyReviews" dataSource="#variables.settings.dsn#">
			select rvw.* , rsp.response, rsp.createdAt AS responseCreatedAt
			from be_reviews rvw
           left join be_responses_to_reviews rsp ON rvw.id = rsp.reviewID
			where rvw.unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.strpropid#">
			and rvw.approved = 'Yes'
			order by rvw.createdat
		</cfquery>

		<cfset reviewStruct = StructNew()>

		<cfloop query="qryGetPropertyReviews">

			<cfset localStruct = structnew()>

			<cfset localStruct.createdat = qryGetPropertyReviews.createdat>
			<cfset localStruct.title = qryGetPropertyReviews.title>
			<cfset localStruct.firstname = qryGetPropertyReviews.firstname>
			<cfset localStruct.lastname = qryGetPropertyReviews.lastname>
			<cfset localStruct.review = qryGetPropertyReviews.review>
			<cfset localStruct.rating = qryGetPropertyReviews.rating>
			<cfset localStruct.hometown = qryGetPropertyReviews.hometown>
			<cfset localStruct.response = qryGetPropertyReviews.response>
			<cfset localStruct.responseCreatedAt = qryGetPropertyReviews.responseCreatedAt>

			<cfset StructInsert(reviewStruct,qryGetPropertyReviews.id,localStruct)>

		</cfloop>

		<cfreturn reviewStruct>

   </cffunction> <!--- end of getPropertyReviews function --->



   <cffunction name="getSearchResults" hint="Runs a local query and returns search results based on user's chosen parameters">

    		<cfparam name="session.booking.strSortBy" default="rand()">

    		<cfset var qryGetSearchResults = ''>

    		<cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate>

	    			<cfset variable.numNights = DateDiff('d',session.booking.strCheckin,session.booking.strCheckout)>

					<cfset numberDayofWeek = dayOfWeek(session.booking.strcheckin)>

					<cfif numberDayofWeek eq 1>
						<!--- If Coldfusion returns Sunday, add 6 to match PP's Sunday value of 7 --->
						<cfset numberDayofWeek = numberDayofWeek + 6>
					<cfelse>
						<!--- Any day except Sunday, just subtract 1 to match PP --->
						<cfset numberDayofWeek = numberDayofWeek - 1>
					</cfif>

				  <!---

				  Coldfusion dayOfWeek function returns:

					  1 - Sunday
					  2 - Monday
					  3 -Tuesday
					  4 - Wednesday
					  5 -Thursday
					  6 -Friday
					  7 - Saturday

				  Property Plus turn days are as follows:

						0 - Any day of the week, no restriction
						1 - Monday
						2 - Tuesday
						3 - Wednesday
						4 - Thursday
						5 - Friday
						6 - Saturday
						7 - Sunday
					--->


    		</cfif>

    		<!--- You can't sort by price with no dates, so default sort by to bedrooms --->
			<cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate eq false and session.booking.strSortBy contains 'price'>
				<cfset session.booking.strSortBy = 'rand()'>
			</cfif>

    		<!--- Check and see if lat/long comes from API; if not, look for lat/long in the pp_propertyinfo_lat_long table  --->
			<cfquery name="latlongCheck" dataSource="#variables.settings.booking.dsn#">
			   SHOW COLUMNS FROM `pp_propertyinfo` LIKE 'latitude';
			</cfquery>

			<cfquery name="qryGetSearchResults" dataSource="#variables.settings.booking.dsn#">

				select
					SQL_CALC_FOUND_ROWS distinct pp_propertyinfo.*,
					pp_propertyinfo.strpropid as propertyid,
					strname as name,
					straddress1 as address,
					dblbeds as bedrooms,
					dblbaths as bathrooms,
					intoccu as sleeps,
					strlocation as `location`,
					featureList as petsallowed,
					strType as `type`,
					latitude,
					longitude,
					(select avg(rating) as average from be_reviews where unitcode = pp_propertyinfo.strpropid) as avgRating,
					(select min(dblRate) from pp_season_rates where strChargeBasis = 'weekly' and strpropid = pp_propertyinfo.strpropid) as unitMinWeeklyPrice,
					(select max(dblRate) from pp_season_rates where strChargeBasis = 'weekly' and strpropid = pp_propertyinfo.strpropid) as unitMaxWeeklyPrice

				<cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate>

					<cfset numNights = DateDiff('d',session.booking.strcheckin,session.booking.strcheckout)>

					<cfif numNights gte 7>
						,(select dblrate from pp_season_rates where #createodbcdate(session.booking.strcheckin)# between dtBeginDate and dtEndDate and strChargeBasis = 'weekly' and strpropid = pp_propertyinfo.strpropid) as 'price'
					<cfelse>
						,(select dblrate from pp_season_rates where #createodbcdate(session.booking.strcheckin)# between dtBeginDate and dtEndDate and strChargeBasis = 'Daily' and strpropid = pp_propertyinfo.strpropid) as 'price'
					</cfif>

					,(select min(dblrate) from pp_season_rates where #createodbcdate(session.booking.strcheckin)# between dtBeginDate and dtEndDate and strChargeBasis = 'Daily' and strpropid = pp_propertyinfo.strpropid) as 'MapPrice'

				<cfelse>

					,(select min(dblrate) from pp_season_rates where strChargeBasis = 'Daily' and strpropid = pp_propertyinfo.strpropid) as 'MapPrice'

				</cfif>

				from pp_propertyinfo

				<cfif session.booking.searchByDate>
					JOIN pp_season_rates ON pp_propertyinfo.strPropId = pp_season_rates.strPropId
				</cfif>

			   where 1=1

				<cfinclude template="/#settings.booking.dir#/results-search-query-common.cfm">

			  <!--- User has entered a start date and end date --->
			  <cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate>

			    and pp_season_rates.strChargeBasis = 'weekly'

			    <!--- make sure property has a rate for the selected dates --->
			    and #createodbcdate(session.booking.strcheckin)#  between pp_season_rates.dTBeginDate and pp_season_rates.dtEndDate

			    <!--- enforce min night stay rules --->
					and pp_propertyinfo.strpropid IN
					(
						select distinct strpropid from pp_minnightsinfo where #createodbcdate(session.booking.strcheckin)# between pp_minnightsinfo.dtBeginDate and pp_minnightsinfo.dtEndDate
						and #variable.numNights# >= intMinNights
					)

					<!--- enforce turn over day rules - TURN THIS OFF/ON AS NEEDED, NOT EVERY CLIENT USES THIS --->
					and pp_propertyinfo.strpropid IN
					(
						select distinct strpropid from pp_turndayinfo where #createodbcdate(session.booking.strcheckin)# between pp_turndayinfo.dtBeginDate and pp_turndayinfo.dtEndDate
						and (intTurnDay = #numberDayofWeek# or intTurnDay = 0)
					)

					<!--- make sure unit is available --->
					and pp_propertyinfo.strPropID not in (
						select distinct strPropID
						from pp_property_non_available_dates
						where

							<cfset modifiedCheckin = dateAdd('d',1,session.booking.strcheckin)>

							#createodbcdate(modifiedCheckin)#  between pp_property_non_available_dates.dTFromDate and pp_property_non_available_dates.dtToDate

							<cfloop from="2" to="#variable.numNights-1#" index="i">
							  or "#DateFormat(DateAdd('d',i,session.booking.strcheckin),'yyyy-mm-dd')#" between pp_property_non_available_dates.dTFromDate and pp_property_non_available_dates.dtToDate
							</cfloop>

							order by StrPropId
					)
			  </cfif><!--- end searchbydate --->

				<cfif StructKeyExists(session.booking,'strSortBy') and len(session.booking.strSortBy)>
					order by #session.booking.strSortBy#
				</cfif>

			</cfquery>

			<cfif isdefined('session.booking.rentalrate') and len(session.booking.rentalrate)>

					<cfset minSearchValue = #ListGetAt(session.booking.rentalrate,1)#>
					<cfset maxSearchValue = #ListGetAt(session.booking.rentalrate,2)#>

				   <cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate>
				   	<!--- Filter by base rent since the user selected dates --->
						<cfquery name="qryGetSearchResults" dbtype="query">
							select * from qryGetSearchResults where
							temp.price between '#minSearchValue#' and '#maxSearchValue#'
						</cfquery>
					<cfelse>
						<!--- Filter by the price range with a non-dated search --->
						<cfquery name="qryGetSearchResults" dbtype="query">
							select * from qryGetSearchResults where
							temp.unitMinWeeklyPrice >= '#minSearchValue#' and temp.unitMaxWeeklyPrice <= '#maxSearchValue#'
						</cfquery>
					</cfif>

			</cfif>

			<cfset cookie.numResults = qryGetSearchResults.recordcount>
			<cfset session.booking.getResults = qryGetSearchResults>
			<cfset session.booking.UnitCodeList = valueList(qryGetSearchResults.strpropid)>

    </cffunction> <!--- end of getSearchResults --->



    <cffunction name="getSearchResultsProperty" returnType="query" hint="Returns property results if the user does a sitewide search for a given term like 'ocean front rentals'">

   	<cfargument name="searchterm" required="true">

		<cfquery DATASOURCE="#variables.settings.dsn#" NAME="results">
			SELECT seoPropertyName,cleanstrpropid as propertyid,strName as propertyname,strdesc as propertydesc
			FROM pp_propertyinfo
			where strName like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#arguments.SearchTerm#%">
			or strdesc like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#arguments.SearchTerm#%">
			or straddress1 like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#arguments.SearchTerm#%">
			or straddress2 like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#arguments.SearchTerm#%">
			or strArea like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#arguments.SearchTerm#%">
			or strCity like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#arguments.SearchTerm#%">
			or strLocation like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#arguments.SearchTerm#%">
			or featureList like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#arguments.SearchTerm#%">
		</cfquery>

		<cfreturn results>

   </cffunction> <!--- end of getSearchResultsProperty --->



   <cffunction name="setGoogleAnalytics" returnType="string" hint="Sets the Google analytics script for the booking confirmation page">

      <cfargument name="settings" required="true">
      <cfargument name="form" required="true">
      <cfargument name="reservationNumber" required="true" type="string">

      <cfsavecontent variable="temp">
      <cfoutput>
         <script type="text/javascript" defer="defer">
           (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
           (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
           m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
           })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

           ga('create', '#settings.googleAnalytics#', '#settings.website#');
           ga('send', 'pageview');

           ga('require', 'ecommerce', 'ecommerce.js');

         	ga('ecommerce:addTransaction', {
         	id: '#reservationNumber#', // Transaction ID - this is normally generated by your system.
         	affiliation: '#settings.company#', // Affiliation or store name
         	revenue: '#form.dblTotalCost#', // Grand Total
         	shipping: '0' , // Shipping cost
         	tax: '0' }); // Tax.

         	ga('ecommerce:addItem', {
         	id: '#reservationNumber#', // Transaction ID.
         	sku: '#form.propertyid#', // SKU/code.
         	name: '#Replace(form.propertyname,"'","","All")#', // Product name.
         	category: 'Rental', // Category or variation.
         	price: '#form.total#', // Unit price.
         	quantity: '1'}); // Quantity.

         	ga('ecommerce:send');
         </script>
      </cfoutput>
      </cfsavecontent>

      <cfreturn temp>

   </cffunction> <!--- end of setGoogleAnalytics --->



   <cffunction name="setPropertyMetaData" returnType="string" hint="Sets the meta data for the property detail page">

      <cfargument name="property" required="true">

      <cfsavecontent variable="temp">
         <cfoutput>
         <title>#property.name# - #property.city# #property.type# Rental | #variables.settings.company#</title>
         <cfset tempDescription = striphtml(mid(property.description,1,300))>
         <meta name="description" content="#tempDescription#">
         <meta property="og:title" content="#property.name# - #variables.settings.company#">
         <meta property="og:description" content="#tempDescription#">
         <meta property="og:url" content="http://#cgi.http_host#/#settings.booking.dir#/#property.seopropertyname#/#property.propertyid#">
         <meta property="og:image" content="#property.defaultPhoto#">
         </cfoutput>
      </cfsavecontent>

      <cfreturn temp>

   </cffunction> <!--- end of setMetaData --->



   <cffunction name="submitLeadToThirdParty" hint="Submits form information a 3rd party;used on the property detail page contact form"></cffunction>



   <cffunction name="getDistinctTypes" returnType="string" hint="Gets distinct unit types for the refine search">

   	<cfset var qryGetDistinctTypes = ''>

   	<cfquery name="qryGetDistinctTypes" dataSource="#variables.settings.booking.dsn#">
   		select distinct strType from pp_propertyinfo order by strType
   	</cfquery>

   	<cfset typeList = ValueList(qryGetDistinctTypes.strType)>

   	<cfreturn typelist>

   </cffunction>



   <!--- This might need to be adjusted per-client based on what they have in their table --->
   <cffunction name="getDistinctAreas" returnType="string" hint="Gets distinct areas for the refine search">

   	<cfset var qryGetDistinctAreas = ''>

   	<cfquery name="qryGetDistinctAreas" dataSource="#variables.settings.booking.dsn#">
   		select distinct strArea from pp_propertyinfo order by strArea
   	</cfquery>

   	<cfset areaList = ValueList(qryGetDistinctAreas.strArea)>

   	<cfreturn areaList>

   </cffunction>


   <!--- This might need to be adjusted per-client based on what they have in their table --->
   <cffunction name="getDistinctViews" returnType="string" hint="Gets distinct views for the refine search">

		<cfset var qryGetDistinctViews = ''>

   	<cfset viewList = ''>

   	<cfreturn viewList>

   </cffunction>


   <cffunction name="getAllProperties" returnType="query" hint="Returns a query of all properties">

   	<cfset var qryGetAllProperties = ''>

   	<cfquery name="qryGetAllProperties" dataSource="#variables.settings.booking.dsn#">
   		select
   			distinct strPropID as propertyid,
   			strName as name,
   			seopropertyname,
   			intoccu as sleeps,
   			dblbeds as bedrooms,
   			dblbaths as bathrooms
   		from pp_propertyinfo order by strName
   	</cfquery>

   	<cfreturn qryGetAllProperties>

   </cffunction>

   <cffunction name="insertAPILogEntry" hint="Logs any API request to the apilogs table">

	   <cfargument name="page">
	   <cfargument name="req">
	   <cfargument name="res">

	   <cfset var insertAPILogEntry = queryNew("")>
	   <cfset var x = structNew()>

	   <cftry>

				<cfset cleanRequest = replace(arguments.req,'&','and','all')>
				<cfset x = xmlParse(cleanRequest)>

				<!--- Start Home Away CC wiping --->
				<cfif isDefined("x.Envelope.Body.createBooking.objBookingRequest.objCreditCardDetails.strCCNumber.xmlText")>
					<cfset x.Envelope.Body.createBooking.objBookingRequest.objCreditCardDetails.strCCNumber.xmlText="*Redacted*">
				</cfif>

				<cfif isDefined("x.Envelope.Body.createBooking.objBookingRequest.objCreditCardDetails.strToken.xmlText")>
					<cfset x.Envelope.Body.createBooking.objBookingRequest.objCreditCardDetails.strToken.xmlText="*Redacted*">
				</cfif>
				<!--- Stop Home Away CC wiping --->

				<cfquery name="insertAPILogEntry" datasource="#variables.settings.dsn#">
					insert into apilogs
					set
					page = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.page#">,
					req = <cfqueryparam cfsqltype="cf_sql_varchar" value="#toString(x)#">,
					res = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.res#">
				</cfquery>

	   <cfcatch>
	   	<cfdump var="#cfcatch#">
	      <!--- Change to Jonathan and Randy after go live --->
	      <cfmail
	         subject="API Log Error from #cgi.http_host#"
	         to="jrichey@icoastalnet.com"
	         from="jrichey@icoastalnet.com"
	         server="#settings.cfmailServer#"
	         username="#settings.cfmailUsername#"
	         password="#settings.cfmailPassword#"
	         port="#settings.cfmailPort#"
	         useSSL="#settings.cfmailSSL#"
	         type="HTML"
	      >
	      	<h1>page</h1>
	      	#arguments.page#
	      	<h1>request</h1>
	      	#arguments.req#
	      	<h1>response</h1>
	      	#arguments.res#
	      	<h1>cfcatch</h1>
	         <cfdump var="#cfcatch#">
	         <h1>cgi</h1>
	         <cfdump var="#cgi#">
	      </cfmail>


	   </cfcatch>

	   </cftry>

	</cffunction>


	<cffunction name="getRandomProperties" returnType="query" hint="Used on search results when no properties found matching the search criteria.">

		<cfset var qryGetRandomProperties = ''>

		<cfquery name="qryGetRandomProperties" datasource="#variables.settings.booking.dsn#">

			select
					pp_propertyinfo.strpropid as propertyid,
					strname as name,
					dblbeds as bedrooms,
					dblbaths as bathrooms,
					intoccu as sleeps,
					strlocation as `location`,
					featureList as petsallowed,
					strType as `type`,
					seopropertyname,
					defaultPhoto,
					(select avg(rating) as average from be_reviews where unitcode = pp_propertyinfo.strpropid) as avgRating

			from pp_propertyinfo

			order by rand() limit 2

		</cfquery>

		<cfreturn qryGetRandomProperties>

	</cffunction>


	<cffunction name="getSearchFilterCount" returnType="string" hint="Used on the results page, Filters, to count the number of properties that match the given filter.">

		<cfargument name="filter" required="true" type="string">
		<cfargument name="category" required="true" type="string">

		<cfset var qryGetSearchFilterCount = ''>

		<cfif arguments.category eq 'amenity'>
			<cfif settings.booking.v12Client eq 'yes'>
				<cfquery name="qryGetSearchFilterCount" dataSource="#variables.settings.booking.dsn#">
					select count(distinct strpropid) as numRecords
					from pp_attributes where `attribute` = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.filter#">
				</cfquery>
			<cfelse>
				<cfquery name="qryGetSearchFilterCount" dataSource="#variables.settings.booking.dsn#">
					select count(strpropid) as numRecords from pp_propertyinfo where featureList like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#arguments.filter#%">
				</cfquery>
			</cfif>
			<cfreturn qryGetSearchFilterCount.numRecords>
		<cfelseif arguments.category eq 'type'>
			<cfquery name="qryGetSearchFilterCount" dataSource="#variables.settings.booking.dsn#">
				select count(strpropid) as numRecords from pp_propertyinfo where strUnitType = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.filter#">
			</cfquery>
			<cfreturn qryGetSearchFilterCount.numRecords>
		<cfelse>
			<cfreturn 0>
		</cfif>

	</cffunction>


	<cffunction name="getPriceBasedOnDates" returnType="string" hint="Returns the rental rate for a given property based on the arrival date">

   	<cfargument name="strpropid" required="true" type="string">
   	<cfargument name="strcheckin" required="true" type="date">
   	<cfargument name="strcheckout" required="true" type="date">

   	<cfset var qryGetPriceBasedOnDates = ''>
   	<cfset var numNights = DateDiff('d',arguments.strcheckin,arguments.strcheckout)>
   	<cfset var strChargeBasis = 'Daily'>

   	<cfif numNights gte 7> <!--- weekly rate --->

			<cfset numNights = 1>
			<cfset strChargeBasis = 'Weekly'>

		</cfif>

		<cfquery name="qryGetPriceBasedOnDates" dataSource="#variables.settings.booking.dsn#">
			select (dblRate*#numNights#) as baseRate
			from pp_season_rates
			where strpropid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.strpropid#">
			and #createodbcdate(arguments.strcheckin)# between dtBeginDate and dtEndDate
			and strChargeBasis = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#strChargeBasis#">
		</cfquery>

		<cfif qryGetPriceBasedOnDates.recordcount gt 0>
			<cfset tempReturn = DollarFormat(qryGetPriceBasedOnDates.baseRate) & ' <small>+Taxes and Fees</small>'>
		<cfelse>
		  <cfset tempReturn = ''>
		</cfif>

		<cfreturn tempReturn>

   </cffunction>


   <cfscript>
   function stripHTML(str) {
   	str = reReplaceNoCase(str, "<*style.*?>(.*?)</style>","","all");
   	str = reReplaceNoCase(str, "<*script.*?>(.*?)</script>","","all");

   	str = reReplaceNoCase(str, "<.*?>","","all");
   	//get partial html in front
   	str = reReplaceNoCase(str, "^.*?>","");
   	//get partial html at end
   	str = reReplaceNoCase(str, "<.*$","");
   	return trim(str);
   }
   </cfscript>

</cfcomponent>