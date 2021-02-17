<!---
Function index:

addcoupon

bookNow

checkout

getCalendarData

getCalendarDataForDatePickers

getCalendarRates

getDetailRates

getFeaturedProperties

getLocations

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

getAllProperties

insertAPILogEntry

getRandomProperties

getSearchFilterCount

getPriceBasedOnDates

associativeArrayToQuery
--->
<cfcomponent hint="Track CFC">

   <cffunction name="init" access="public" output="false" hint="constructor">
      <cfargument name="settings" type="struct" required="true" hint="settings" />
      <cfset variables.settings = arguments.settings>

      <cfset ravenConfig = structNew()>
      <cfset ravenConfig.publicKey = variables.settings.sentry_publickey>
      <cfset ravenConfig.privateKey = variables.settings.sentry_privatekey>
      <cfset ravenConfig.sentryUrl = variables.settings.sentry_url>
      <cfset ravenConfig.projectID = variables.settings.sentry_projectid>
      <cfset ravenClient = createObject('component', 'error.components.client').init(argumentCollection=ravenConfig)>

      <cfreturn this />
   </cffunction>

   <cffunction name="addCoupon" returnType="string" hint="Used in book-now.cfm to process a promo code">

   </cffunction>

   <cffunction name="selectOptionalServices" returnType="string" hint="Used in book-now.cfm to add/remove services like travel insurance">

   </cffunction>

   <cffunction name="bookNowNew" returnType="string" hint="Used in book-now_.cfm to check availability and get pricing for the checkout page">
      <cfargument name="propertyid" required="true">
      <cfargument name="strcheckin" required="true">
      <cfargument name="strcheckout" required="true">
      <cfargument name="promoCode" required="false" default="">
      <cfargument name="petcount" required="false" default="0">
      <cfargument name="carpasscount" required="false" default="1">
      <cfargument name="addons" required="false" default="">
      <cfargument name="travelInsuranceSelected" required="false" default="">

    <!--- Local variables --->
    <cfset var unitAvailable = "yes">
    <cfset var totalamount = 0>
    <cfset var travelinsuranceAmt = 0>
    <cfset var apiresponse = ''>
    <cfset var json = ''>

    <!--- Let's just double check and make sure it's still available --->
    <cftry>
      <cfset var qryAddons = queryNew("id,quantity")>

      <cfif listLen( arguments.addons ) gt 0>
        <cfloop index="i" list="#arguments.addons#">
          <cfset queryAddRow(qryAddons)>
          <cfset querySetCell(qryAddons, "id", ListFirst(i,'-'))>
          <cfset querySetCell(qryAddons, "quantity", ListLast(i,'-'))>
        </cfloop>
      </cfif>

      <cfset var addOnsStruct = lcase(serializeJson(qryAddons,"struct"))>

      <cfset var formFields = {
        "unitId": #arguments.propertyid#,
        "arrivalDate": "#DateFormat(arguments.strcheckin,'yyyy-mm-dd')#",
        "departureDate": "#DateFormat(arguments.strcheckout,'yyyy-mm-dd')#",
        "travelInsurance": "#arguments.travelInsuranceSelected#",
        "promoCode":"#arguments.promoCode#",
        "occupants":{
            "pets":"#arguments.petcount#"
        },
        "addOns":"#deserializeJSON( addOnsStruct )#"
      }>

      <cfhttp method="post" url="#settings.booking.track_api_endpoint#/api/pms/quote" username="#settings.booking.username#" password="#settings.booking.password#">
         <cfhttpparam type="header" name="Accept" value="*/*">
         <cfhttpparam type="header" name="Content-type" value="application/json" />
         <cfhttpparam type="body" value="#serializeJSON(formFields)#">
      </cfhttp>

        <cfcatch>
        <cfif isdefined("ravenClient")>
          <cfset ravenClient.captureException(cfcatch)>
        </cfif>
           <cfset apiresponse = "Error: #cfcatch.message#">
        </cfcatch>

      </cftry>

    <cfif isdefined('cfhttp.FileContent') and isJSON(cfhttp.FileContent)>

      <cftry>
        <cflock timeout="10" scope="Session">
        <cfset json = DeserializeJSON(cfhttp.FileContent)>

        <cfset insertAPILogEntry(cgi.script_name,ReplaceNoCase(serializeJSON(formFields),'"addOnsStruct"',addOnsStruct),cfhttp.FileContent)>

        <cfif StructKeyExists(json,'detail')>
          <cfset apiResponse = json.detail>
        <cfelse>
          <cfinclude template="/#settings.booking.dir#/common/_summary-of-fees.cfm">
        </cfif>
         </cflock>

           <cfcatch>
          <cfif isdefined("ravenClient")>
            <cfset ravenClient.captureException(cfcatch)>
          </cfif>
             <cfset apiresponse = "Error: #cfcatch.message#">
           </cfcatch>
         </cftry>

    </cfif>

    <cfreturn apiresponse>

   </cffunction> <!--- end of bookNow function --->

   <cffunction name="bookNow" returnType="string" hint="Used in book-now_.cfm to check availability and get pricing for the checkout page">
      <cfargument name="propertyid" required="true">
      <cfargument name="strcheckin" required="true">
      <cfargument name="strcheckout" required="true">
      <cfargument name="promoCode" required="false" default="">
      <cfargument name="petcount" required="false" default="0">z
      <cfargument name="addons" required="false" default="">
      <cfargument name="travelInsuranceSelected" required="false" default="">

		<!--- Local variables --->
		<cfset var unitAvailable = "yes">
   	<cfset var totalamount = 0>
		<cfset var travelinsuranceAmt = 0>
		<cfset var apiresponse = ''>
    <cfset var json = ''>

		<!--- Let's just double check and make sure it's still available --->
		<cftry>
      <cfset var qryAddons = queryNew("id,quantity")>

      <cfif listLen( arguments.addons ) gt 0>
        <cfloop index="i" list="#arguments.addons#">
          <cfset queryAddRow(qryAddons)>
          <cfset querySetCell(qryAddons, "id", ListFirst(i,'-'))>
          <cfset querySetCell(qryAddons, "quantity", ListLast(i,'-'))>
        </cfloop>
      </cfif>

      <cfset var addOnsStruct = lcase(serializeJson(qryAddons,"struct"))>

      <cfset var formFields = {
        "unitId": #arguments.propertyid#,
        "arrivalDate": "#DateFormat(arguments.strcheckin,'yyyy-mm-dd')#",
        "departureDate": "#DateFormat(arguments.strcheckout,'yyyy-mm-dd')#",
        "promoCode":"#arguments.promoCode#",
        "occupants":{
            "pets":"#arguments.petcount#"
        },
        "addOns":"#deserializeJSON( addOnsStruct )#"
      }>

			<cfhttp method="post" url="#settings.booking.track_api_endpoint#/api/pms/quote" username="#settings.booking.username#" password="#settings.booking.password#">
	       <cfhttpparam type="header" name="Accept" value="*/*">
	       <cfhttpparam type="header" name="Content-type" value="application/json" />
				 <cfhttpparam type="body" value="#serializeJSON(formFields)#">
	    </cfhttp>

	      <cfcatch>
				<cfif isdefined("ravenClient")>
					<cfset ravenClient.captureException(cfcatch)>
				</cfif>
	         <cfset apiresponse = "Error: #cfcatch.message#">
	      </cfcatch>

      </cftry>

		<cfif isdefined('cfhttp.FileContent') and isJSON(cfhttp.FileContent)>

			<cftry>
        <cflock timeout="10" scope="Session">
				<cfset json = DeserializeJSON(cfhttp.FileContent)>

        <cfset insertAPILogEntry(cgi.script_name,ReplaceNoCase(serializeJSON(formFields),'"addOnsStruct"',addOnsStruct),cfhttp.FileContent)>

				<cfif StructKeyExists(json,'detail')>
					<cfset apiResponse = json.detail>
				<cfelse>
					<cfinclude template="/#settings.booking.dir#/common/_summary-of-fees.cfm">
				</cfif>
         </cflock>

	         <cfcatch>
					<cfif isdefined("ravenClient")>
						<cfset ravenClient.captureException(cfcatch)>
					</cfif>
		         <cfset apiresponse = "Error: #cfcatch.message#">
	         </cfcatch>
         </cftry>

		</cfif>

		<cfreturn apiresponse>

   </cffunction> <!--- end of bookNow function --->


   <cffunction name="checkout" returnType="string" hint="Book and confirm the reservation">
	   	<cfargument name="form" required="true">

	   	<cfset var reservationCode = "">
      <cfset var formFields = "">
      <cfset var formFieldsSafe = "">
      <cfset var addOnsStruct = "">
      <cfset var json = "">
      <cfset var qryAddons = queryNew("id,quantity")>
      <cfset var myNumPets = 0>

      <cfset var formattedCheckin = ''>
      <cfset var formattedCheckout = ''>

      <cfset var totalAmountForReservation = 0>

	   	<cfif isdefined('form.numPets')>
	   		<cfset myNumPets = form.numPets>
	   	<cfelse>
	   		<cfset myNumPets = 0>
	   	</cfif>

			<cftry>

						<cfset formattedCheckin = DateFormat(form.strCheckin,'yyyy-mm-dd')>
						<cfset formattedCheckout = DateFormat(form.strCheckout,'yyyy-mm-dd')>

						<cfparam name="totalAmountForReservation" default="0">

						<!--- Determine if we need to pass the total with or without insurance --->
						<cfif
							isdefined('form.travelInsurance') and
							form.travelInsurance eq 'true' and
							isdefined('form.TotalWithInsurance') and
							form.TotalWithInsurance neq '' and
							isValid('numeric',form.TotalWithInsurance) and
							form.TotalWithInsurance gt 0>

							<cfset totalAmountForReservation = form.TotalWithInsurance>

						<cfelse>

							<cfset totalAmountForReservation = form.Total>

						</cfif>

						<!--- Creates JSON list of Add-ons --->
            <cfif Len(trim(form.allAddOns)) GT 0>
              <cfloop index="i" list="#form.allAddOns#">
                <cfset queryAddRow(qryAddons)>
                <cfset querySetCell(qryAddons, "id", ListFirst(i,'-'))>
                <cfset querySetCell(qryAddons, "quantity", ListLast(i,'-'))>
              </cfloop>
              <cfset var addOnsStruct = lcase(serializeJson(qryAddons,"struct"))>
							<cfset var formFields =

                {
                  "reservation":
                  {
                    "unitId": "#form.propertyId#",
                    "arrivalDate": "#formattedCheckin#",
                    "departureDate": "#formattedCheckout#",
                    "travelInsurance": "#form.travelInsurance#",
                    "promoCode":"#form.hiddenPromoCode#",
                    "occupants":{
                      "adults":"#form.numAdults#",
                      "pets":"#myNumPets#"
                    },
                    "addOns": "addOnsStruct",
                    "contact": {
                      "firstName": "#form.firstname#",
                      "lastName": "#form.lastname#",
                      "streetAddress": "#form.address1#",
                      "locality": "#form.city#",
                      "region": "#form.state#",
                      "postal": "#form.zip#",
                      "country": "US",
                      "primaryEmail": "#form.email#",
                      "cellPhone": "#form.phone#"
                    },
                    "payment": {
                      <!---"amount": #totalAmountForReservation#,--->	<!---TT 116661--->
                      "paymentCard": {
                        "cardNumber": "#form.ccNumber#",
                        "cardCvv": "#form.ccCVV#",
                        "cardExp": "#form.ccMonth#-#form.ccYear#",
                        "name": "#form.ccFirstName# #form.ccLastName#",
                        "postalCode": "#form.billingZip#",
                        "saveCard": true
                      }
                    }
                 }

                }>

                <!--- We need to store the request, but strip out sensitive data like the credit card info --->
                <cfset var formFieldsSafe =

                {
                  "reservation":
                  {
                    "unitId": "#form.propertyId#",
                    "arrivalDate": "#formattedCheckin#",
                    "departureDate": "#formattedCheckout#",
                    "travelInsurance": "#form.travelInsurance#",
                    "promoCode":"#form.hiddenPromoCode#",
                    "occupants":{
                      "adults":"#form.numAdults#",
                      "pets":"#myNumPets#"
                    },
                    "addOns": "addOnsStruct",
                    "contact": {
                      "firstName": "#form.firstname#",
                      "lastName": "#form.lastname#",
                      "streetAddress": "#form.address1#",
                      "locality": "#form.city#",
                      "region": "#form.state#",
                      "postal": "#form.zip#",
                      "country": "US",
                      "primaryEmail": "#form.email#",
                      "cellPhone": "#form.phone#"
                    },
                    "payment": {
                      <!---"amount": #totalAmountForReservation#,--->	<!---TT 116661--->
                      "paymentCard": {
                        "cardNumber": "**REDACTED**",
                        "cardCvv": "**REDACTED**",
                        "cardExp": "**REDACTED**",
                        "name": "**REDACTED**",
                        "postalCode": "**REDACTED**",
                        "saveCard": false
                      }
                    }
                 }

                }>
            <cfelse>
							<cfset var formFields =

                {
                  "reservation":
                  {
                    "unitId": "#form.propertyId#",
                    "arrivalDate": "#formattedCheckin#",
                    "departureDate": "#formattedCheckout#",
                    "travelInsurance": "#form.travelInsurance#",
                    "promoCode":"#form.hiddenPromoCode#",
                    "occupants":{
                      "adults":"#form.numAdults#",
                      "pets":"#myNumPets#"
                    },
                    "contact": {
                      "firstName": "#form.firstname#",
                      "lastName": "#form.lastname#",
                      "streetAddress": "#form.address1#",
                      "locality": "#form.city#",
                      "region": "#form.state#",
                      "postal": "#form.zip#",
                      "country": "US",
                      "primaryEmail": "#form.email#",
                      "cellPhone": "#form.phone#"
                    },
                    "payment": {
                      <!---"amount": #totalAmountForReservation#,--->	<!---TT 116661--->
                      "paymentCard": {
                        "cardNumber": "#form.ccNumber#",
                        "cardCvv": "#form.ccCVV#",
                        "cardExp": "#form.ccMonth#-#form.ccYear#",
                        "name": "#form.ccFirstName# #form.ccLastName#",
                        "postalCode": "#form.billingZip#",
                        "saveCard": true
                      }
                    }
                 }

                }>

                <!--- We need to store the request, but strip out sensitive data like the credit card info --->
                <cfset var formFieldsSafe =

                {
                  "reservation":
                  {
                    "unitId": "#form.propertyId#",
                    "arrivalDate": "#formattedCheckin#",
                    "departureDate": "#formattedCheckout#",
                    "travelInsurance": "#form.travelInsurance#",
                    "promoCode":"#form.hiddenPromoCode#",
                    "occupants":{
                      "adults":"#form.numAdults#",
                      "pets":"#myNumPets#"
                    },
                    "contact": {
                      "firstName": "#form.firstname#",
                      "lastName": "#form.lastname#",
                      "streetAddress": "#form.address1#",
                      "locality": "#form.city#",
                      "region": "#form.state#",
                      "postal": "#form.zip#",
                      "country": "US",
                      "primaryEmail": "#form.email#",
                      "cellPhone": "#form.phone#"
                    },
                    "payment": {
                      <!---"amount": #totalAmountForReservation#,--->	<!---TT 116661--->
                      "paymentCard": {
                        "cardNumber": "**REDACTED**",
                        "cardCvv": "**REDACTED**",
                        "cardExp": "**REDACTED**",
                        "name": "**REDACTED**",
                        "postalCode": "**REDACTED**",
                        "saveCard": false
                      }
                    }
                 }

                }>
            </cfif>


						<cfhttp method="post" url="#settings.booking.track_api_endpoint#/api/pms/reservations" username="#settings.booking.username#" password="#settings.booking.password#">
				         <cfhttpparam type="header" name="Accept" value="*/*">
				         <cfhttpparam type="header" name="Content-Type" value="application/hal+json">
							<cfhttpparam type="body" value="#ReplaceNoCase(serializeJSON(formFields),'"addOnsStruct"',addOnsStruct)#">
				      </cfhttp>

						<cfif isdefined('cfhttp.FileContent') and isJSON(cfhttp.FileContent)>

							<cftry>

								<cfset var json = DeserializeJSON(cfhttp.FileContent)>

								<!--- error comes back from API --->
								<cfif StructKeyExists(json,'errors')>

									<cfset session.errorMessage = json.errors[1]>
									<cfset insertAPILogEntry(cgi.script_name,ReplaceNoCase(serializeJSON(formFieldsSafe),'"addOnsStruct"',addOnsStruct),session.errorMessage)>
									<cflocation addToken="no" url="/#settings.booking.dir#/booking-error.cfm">

								<!--- some other message comes back from API that's not the reservation number --->
								<cfelseif StructKeyExists(json,'detail')>

									<cfset session.errorMessage = json.detail>
									<cfset insertAPILogEntry(cgi.script_name,ReplaceNoCase(serializeJSON(formFieldsSafe),'"addOnsStruct"',addOnsStruct),session.errorMessage)>
									<cflocation addToken="no" url="/#settings.booking.dir#/booking-error.cfm">

								<!--- the reservation was successful; set the reservationCode, log the booking and send the confirmation email --->
								<cfelse>

									<cfset reservationCode = json.id>

									<cftry>
										<cfset insertAPILogEntry(cgi.script_name,ReplaceNoCase(serializeJSON(formFieldsSafe),'"addOnsStruct"',addOnsStruct),cfhttp.FileContent)>
									<cfcatch>
									</cfcatch>
									</cftry>

								</cfif>

					         <cfcatch>
									<cfif isdefined("ravenClient")>
										<cfset ravenClient.captureException(cfcatch)>
									</cfif>
						         <cfset session.errorMessage = cfcatch.message>
						         <cfset insertAPILogEntry(cgi.script_name,ReplaceNoCase(serializeJSON(formFieldsSafe),'"addOnsStruct"',addOnsStruct),cfcatch.message)>
						         <cflocation addToken="no" url="/#settings.booking.dir#/booking-error.cfm">
					         </cfcatch>

				         </cftry>

				      <cfelse>
							<cfset session.errorMessage = "API response was not in the correct format.">
							<cfset insertAPILogEntry(cgi.script_name,ReplaceNoCase(serializeJSON(formFieldsSafe),'"addOnsStruct"',addOnsStruct),session.errorMessage)>
							<cflocation addToken="no" url="/#settings.booking.dir#/booking-error.cfm">
						</cfif>


			  <cfcatch>

				    <cfif isdefined("ravenClient")>
				      <cfset ravenClient.captureMessage("Track.cfc->checkout = #cfcatch.message#")>
				    </cfif>

				    <cfset insertAPILogEntry(cgi.script_name,ReplaceNoCase(serializeJSON(formFieldsSafe),'"addOnsStruct"',addOnsStruct),cfcatch.message)>
				    <cfset session.errorMessage = "Error: Sorry, there was an issue processing your request: #cfcatch.message#">
				    <cflocation addToken="no" url="/#settings.booking.dir#/booking-error.cfm">

			  </cfcatch>

			</cftry>

	   	<cfreturn reservationCode>

	</cffunction>


   <cffunction name="getCalendarData" returnType="string" hint="Used in _calendar-tab.cfm to get all the non-available dates">

   	<cfargument name="propertyid" required="true">

   	<cfset theYear = DatePart('yyyy',now())>
		<cfset theMonth = DatePart('m',now())>

		<cfquery name="nonavaildates" dataSource="#variables.settings.booking.dsn#">
			select Date_Format(thedate,'%m/%d/%Y') as mydate from track_properties_availability
			where propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.propertyid#"> and avail = '0'
			and thedate >= '#theYear#-#theMonth#-01'
		</cfquery>

		<cfset nonAvailList = ValueList(nonavaildates.mydate)>

		<cfreturn nonAvailList>

   </cffunction> <!--- end of getCalenderData function --->


   <cffunction name="getCalendarDataForDatePickers" returnType="string" hint="Used to produce smart date pickers on the PDP">

   	<cfargument name="propertyid" required="true">
   	<cfset nonAvailListForDatepicker = ''>

   	<cfquery name="nonavaildates" dataSource="#variables.settings.booking.dsn#">
			select theDate
			from track_properties_availability
			where propertyid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#arguments.propertyid#">
			order by theDate
		</cfquery>

		<cfloop from="1" to="#nonavaildates.recordcount#" index="i">

		   <cfset myStartDate = DateFormat(nonavaildates['startdate'][i],'mm/dd/yyyy')>
		   <cfset myEndDate = DateFormat(nonavaildates['enddate'][i],'mm/dd/yyyy')>

		   <!--- First record, go ahead and add 1 day to the startdate and add it to the list --->
		   <cfif i eq 1>

		      <cfset myStartDate = dateAdd('d',1,myStartDate)>
		      <cfset myStartDate = DateFormat(myStartDate,'mm/dd/yyyy')>
		      <cfset nonAvailListForDatepicker = ListAppend(nonAvailListForDatepicker,myStartDate)>

		   <cfelse>

		      <cfset prevRowEndDate = nonavaildates['enddate'][i-1]> <!--- Get the previous records's end date --->
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


   </cffunction>

	<cffunction name="getDetailRatesNew" returnType="string" hint="Used on the property detail page to check availability and retrieve summary of fees">
		<cfargument name="propertyid" required="true">
		<cfargument name="strcheckin" required="true">
		<cfargument name="strcheckout" required="true">

      <cfset var apiResponse = "">

   		<cfset var totalAmount = 0>
   		<!--- if arrival date is more than 60 days out form today, off half payment --->
   		<cfset var numdaysout = dateDiff( 'd', now(), arguments.strcheckin ) />

   		<cfif cgi.HTTP_USER_AGENT does not contain 'bot'>
   			<cftry>
				<cfset var formFields =
				{
					"unitId": #arguments.propertyid#,
					"arrivalDate": "#DateFormat(arguments.strcheckin,'yyyy-mm-dd')#",
					"departureDate": "#DateFormat(arguments.strcheckout,'yyyy-mm-dd')#"
				}>

				<cfhttp method="post" url="#settings.booking.track_api_endpoint#/api/pms/quote" username="#settings.booking.username#" password="#settings.booking.password#">
		         	<cfhttpparam type="header" name="Accept" value="*/*">
		         	<cfhttpparam type="header" name="Content-type" value="application/json" />
					<cfhttpparam type="body" value="#serializeJSON(formFields)#">
		      	</cfhttp>

		      <cfif isdefined('cfhttp.FileContent') and isJSON(cfhttp.FileContent)>
			      	<cfset var json = DeserializeJSON(cfhttp.FileContent)>

						<cfif StructKeyExists(json,'detail')>
						<cfset apiResponse = json.detail>
						<cfelseif StructKeyExists(json,'breakdown') and StructKeyExists(json.breakdown,'charges') and StructKeyExists(json.breakdown.charges,'itemized')>
							<cfsavecontent variable="APIresponse">
							   <cfoutput>

								<cfquery name="getMinNightStay" dataSource="#variables.settings.booking.dsn#">
								select stayMin
								from track_properties_availability
								where theDate = #createodbcdate(arguments.strcheckin)#
								and propertyid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.propertyid#">
								</cfquery>

								<cfif getMinNightStay.recordcount gt 0>
									<p align="center">Minimum night stay: #getMinNightStay.stayMin#</p>
								</cfif>

								<ul class="property-cost-list">
									<li>Rent <span class="text-right">#DollarFormat(json.breakdown.rent)#</span></li>

									<cfset var taxesAndFees = 0>
                  <cfset var chargeValue = ''>
                  <cfset var taxesAndFees = ''>

									<cfloop array="#json.breakdown.charges.itemized#" index="charge">
										<cfset chargeValue = charge.value>
										<cfset taxesAndFees = taxesAndFees + chargeValue>
									</cfloop>

									<cfset taxesAndFees = taxesAndFees + json.breakdown.taxes.total>
									<cfset var halftotal = 0 />

									<cfif val( numdaysout ) gte 60>
										<cfset halftotal += json.breakdown.total / 2 />
									</cfif>

									<li>Taxes & Fees <span class="text-right">#DollarFormat(taxesAndFees)#</span></li>
									<li><strong>Total <span class="text-right">#DollarFormat( json.breakdown.total )#</span></strong></li>

									<cfif halftotal gt 0>
										<li><strong>Or Pay Half <span class="text-right">#DollarFormat( halftotal )#</span></strong></li>
									</cfif>
								</ul>

								<cfset var numNights = DateDiff('d',arguments.strcheckin,arguments.strcheckout)>

								<a id="detailBookBtn" class="btn detail-book-btn site-color-1-bg site-color-3-bg-hover text-white" href="#settings.booking.bookingURL#/#settings.booking.dir#/book-now.cfm?propertyid=#arguments.propertyid#&strcheckin=#arguments.strcheckin#&strcheckout=#arguments.strcheckout#"><i class="fa fa-check"></i> Book Now</a>
						  		<a id="splitCostCalc" class="btn site-color-2-bg site-color-3-bg-hover text-white" type="button" data-toggle="modal" data-target="##splitCostModal" href="/#settings.booking.dir#/_family-calculator.cfm?total=#totalAmount#&numnights=#numnights#"><i class="fa fa-calculator"></i> Split Cost Calc</a>

						  		<input type="hidden" id="splitCalcTotalVal" name="splitCalcTotalVal" value="#json.breakdown.total#">
						  		<input type="hidden" id="splitCalcNumNightVal" name="splitCalcNumNightVal" value="#numnights#">

								</cfoutput>
							</cfsavecontent>
						<cfelse>
							<cfset apiResponse = 'API response invalid.'>
						</cfif>

				<cfelse>
					<cfset apiResponse = 'API response was not valid JSON.'>
		      </cfif>

				<cfcatch>
					<cfsavecontent variable="APIResponse">
						<cfoutput><div class="alert alert-danger">#cfcatch#</div></cfoutput>
					</cfsavecontent>
					<cfif isdefined("ravenClient")>
						<cfset ravenClient.captureMessage('Track.cfc->getDetailRates = ' & cfcatch.message)>
					</cfif>
				</cfcatch>

			</cftry>

   	</cfif>

   	<cfreturn apiresponse>

   </cffunction>



   <cffunction name="getDetailRates" returnType="string" hint="Used on the property detail page to check availability and retrieve summary of fees">

   	<cfargument name="propertyid" required="true">
   	<cfargument name="strcheckin" required="true">
   	<cfargument name="strcheckout" required="true">

   	<cfset var totalAmount = 0>

   	<cfif cgi.HTTP_USER_AGENT does not contain 'bot'>

   		<cftry>

				<cfset var formFields =
				{
					"unitId": #arguments.propertyid#,
					"arrivalDate": "#DateFormat(arguments.strcheckin,'yyyy-mm-dd')#",
					"departureDate": "#DateFormat(arguments.strcheckout,'yyyy-mm-dd')#"
				}>

				<cfhttp method="post" url="#settings.booking.track_api_endpoint#/api/pms/quote" username="#settings.booking.username#" password="#settings.booking.password#">
		         	<cfhttpparam type="header" name="Accept" value="*/*">
		         	<cfhttpparam type="header" name="Content-type" value="application/json" />
					<cfhttpparam type="body" value="#serializeJSON(formFields)#">
		      	</cfhttp>

		      <cfif isdefined('cfhttp.FileContent') and isJSON(cfhttp.FileContent)>

			      	<cfset var json = DeserializeJSON(cfhttp.FileContent)>

						<cfif StructKeyExists(json,'detail')>
							<cfset apiResponse = json.detail>
						<cfelseif StructKeyExists(json,'breakdown') and StructKeyExists(json.breakdown,'charges') and StructKeyExists(json.breakdown.charges,'itemized')>
							<cfsavecontent variable="APIresponse">
							   <cfoutput>

								<cfquery name="getMinNightStay" dataSource="#variables.settings.booking.dsn#">
									select stayMin from track_properties_availability where theDate = #createodbcdate(arguments.strcheckin)#
									and propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.propertyid#">
								</cfquery>

								<cfif getMinNightStay.recordcount gt 0>
									<p align="center">Minimum night stay: #getMinNightStay.stayMin#</p>
								</cfif>

								<ul class="property-cost-list">
									<li>Rent <span class="text-right">#DollarFormat(json.breakdown.rent)#</span></li>

									<cfset var taxesAndFees = 0>
                  <cfset var chargeValue = ''>

									<cfloop array="#json.breakdown.charges.itemized#" index="charge">

										<cfset chargeValue = charge.value>

										<cfset taxesAndFees = taxesAndFees + chargeValue>
                                        
                                        <li>#charge.name# <span class="text-right">#DollarFormat(chargeValue)#</span></li>

									</cfloop>

									<cfset taxesAndFees = taxesAndFees + json.breakdown.taxes.total>

									<!---<li>Taxes & Fees <span class="text-right">#DollarFormat(taxesAndFees)#</span></li>--->
                                    <li>Taxes<span class="text-right">#DollarFormat(json.breakdown.taxes.total)#</span></li>
									<li><strong>Total <span class="text-right">#DollarFormat(json.breakdown.total)#</span></strong></li>
								</ul>
								<a id="detailBookBtn" class="btn detail-book-btn site-color-1-bg site-color-3-bg-hover text-white" href="#settings.booking.bookingURL#/#settings.booking.dir#/book-now.cfm?propertyid=#arguments.propertyid#&strcheckin=#arguments.strcheckin#&strcheckout=#arguments.strcheckout#"><i class="fa fa-check"></i> Book Now</a>

								 <cfset var numNights = DateDiff('d',arguments.strcheckin,arguments.strcheckout)>
						  		 <a id="splitCostCalc" class="btn site-color-2-bg site-color-3-bg-hover text-white" type="button" data-toggle="modal" data-target="##splitCostModal" href="/#settings.booking.dir#/_family-calculator.cfm?total=#totalAmount#&numnights=#numnights#"><i class="fa fa-calculator"></i> Split Cost Calc</a>
						  		 <input type="hidden" id="splitCalcTotalVal" name="splitCalcTotalVal" value="#json.breakdown.total#">
						  		 <input type="hidden" id="splitCalcNumNightVal" name="splitCalcNumNightVal" value="#numnights#">

								</cfoutput>
							</cfsavecontent>
						<cfelse>
							<cfset apiResponse = 'API response invalid.'>
						</cfif>

				<cfelse>
					<cfset apiResponse = 'API response was not valid JSON.'>
		      </cfif>

				<cfcatch>
					<cfsavecontent variable="APIResponse">
						<cfoutput><div class="alert alert-danger">#cfcatch#</div></cfoutput>
					</cfsavecontent>
					<cfif isdefined("ravenClient")>
						<cfset ravenClient.captureMessage('Track.cfc->getDetailRates = ' & cfcatch.message)>
					</cfif>
				</cfcatch>

			</cftry>

   	</cfif>

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
                  id as propertyid,
                  name,
                  bedrooms,
                  fullBathrooms as bathrooms,
                  maxoccupancy as sleeps,
                  IF(length(coverImage), coverImage, (select original from track_properties_images where  track_properties_images.propertyid = track_properties.id order by `order` limit 1))as photo,
                  seoFriendlyURL as seopropertyname,
                  streetAddress as address
               from track_properties
               where id IN (<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#propList#" list="yes">)
            </cfquery>

         <cfelse>

            <cfquery name="getProperties" dataSource="#variables.settings.booking.dsn#">
               select
                  id as propertyid,
                  name,
                  bedrooms,
                  fullBathrooms as bathrooms,
                  maxoccupancy as sleeps,
                  IF(length(coverImage), coverImage, (select original from track_properties_images where  track_properties_images.propertyid = track_properties.id order by `order` limit 1))as photo,
                  seoFriendlyURL as seopropertyname,
                  streetAddress as address
               from track_properties
               order by rand()
               limit 6
            </cfquery>

         </cfif>

         <cfreturn getProperties>

   </cffunction> <!--- end of getFeaturedProperties function --->


   <!--- This might need to be adjusted per-client based on what they have in their table --->
   <cffunction name="getLocations" returnType="query" hint="Gets locations for the refine search">
   	<!--- <cfset var qryGetLocations = queryNew('id,name')> --->

   	<cfquery name="qryGetLocations" dataSource="#variables.settings.booking.dsn#">
   		SELECT id,name FROM track_nodes WHERE typeName = 'Area' ORDER BY name
   	</cfquery>

   	<cfreturn qryGetLocations>
   </cffunction>

   <cffunction name="getMinMaxAmenities" returnType="struct" hint="Returns min/max values for common amenities like bedrooms,bathrooms and occupancy, typically used on refine search sliders">

		<cfset var qryGetMinMaxAmenities = "">

		<cfquery name="qryGetMinMaxAmenities" datasource="#variables.settings.booking.dsn#">
			SELECT
				min(bedrooms) as minBed,
				max(bedrooms) as maxBed,
				min(fullBathrooms) as minBath,
				max(fullBathrooms) as maxBath,
				min(maxOccupancy) as minOccupancy,
				max(maxOccupancy) as maxOccupancy
			FROM
				track_properties
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

		<cfset var qryGetMinMaxPrice = "">

		<cfquery name="qryGetMinMaxPrice" datasource="#variables.settings.booking.dsn#">
			SELECT
				min(minRate) as minPrice,
				max(maxRate) as maxPrice
			FROM
				track_properties
		</cfquery>

		<cfset localStruct['minprice'] = int(val( qryGetMinMaxPrice.minPrice ) )>
		<cfset localStruct['maxprice'] = ceiling(val( qryGetMinMaxPrice.maxPrice ) )>

		<cfreturn localStruct>

   </cffunction>


   <cffunction name="getProperty" returnType="query" hint="Returns all the basic information for a given property">

   	<cfargument name="propertyid" required="false">
   	<cfargument name="slug" required="false">

   	<cfset var qryGetProperty = "">

    <cfquery name="qryGetProperty" dataSource="#variables.settings.booking.dsn#">
  		SELECT prp.name,
             prp.longDescription as description,
             prp.shortDescription,
             prp.seoFriendlyURL as seopropertyname,
             prp.id as propertyid,
             IF(length(coverImage), coverImage, (select original from track_properties_images where  track_properties_images.propertyid = prp.id order by `order` limit 1)) as defaultPhoto,
             IF(length(coverImage), coverImage, (select original from track_properties_images where  track_properties_images.propertyid = prp.id order by `order` limit 1))as largePhoto,
             prp.lodgingTypeName as type,
             IF(prp.petsFriendly = 'Yes','Pets Allowed','Pets Not Allowed') as petsallowed,
             prp.locality as location,
             prp.maxoccupancy as sleeps,
             prp.bedrooms,
             prp.fullBathrooms as bathrooms,
             prp.threeQuarterBathrooms,
             prp.halfBathrooms,
             prp.latitude,
             prp.longitude,
             prp.locality as city,
             (select data from track_properties_custom_data where customDataId="72" and propertyid = prp.id) as data,
             prp.region as state,
             '' as checkouttime,
             '' as checkintime,
             '' as `view`,
             prp.streetAddress as address,
             prp.rentalPolicy,
             prp.minRate,
             prp.maxRate,
             prp.maxPets,
             enh.virtualTour,
             enh.videoLink
      FROM track_properties prp
      LEFT JOIN cms_property_enhancements enh ON prp.id = enh.strPropID
		<cfif len(arguments.propertyid)>
      WHERE prp.id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.propertyid#">
    <cfelseif len(arguments.slug)>
      WHERE prp.seoFriendlyURL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.slug#">
    </cfif>
		</cfquery>

		<cfreturn qryGetProperty>

   </cffunction> <!--- end of getProperty --->



   <cffunction name="getPropertyAmenities" returnType="query" hint="Returns all the amenities for a given property">

   	<cfargument name="propertyid" required="true">

   	<cfset var qryGetPropertyAmenities = "">

		<cfquery name="qryGetPropertyAmenities" dataSource="#variables.settings.booking.dsn#">
			select amenityName,amenityGroupName
			from track_properties_amenities
			where propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.propertyid#">
			order by amenityGroupName
		</cfquery>

		<cfreturn qryGetPropertyAmenities>

   </cffunction> <!--- end of getPropertyAmenities --->



   <cffunction name="getPropertyPhotos" returnType="query" hint="Returns all the photos for a given property">

   	<cfargument name="propertyid" required="true">

   	<cfset var qryGetPropertyPhotos = "">

		<cfquery name="qryGetPropertyPhotos" dataSource="#variables.settings.booking.dsn#">
			select
				original,
				original as large,
				original as thumbnail,
				name as caption
			from track_properties_images
			where propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.propertyid#">
			order by `order`
		</cfquery>

		<cfreturn qryGetPropertyPhotos>

   </cffunction> <!--- end of getPropertyPhotos --->


   <cffunction name="getPropertyPriceRange" returnType="string" hint="Returns the min/max price for a given property">

   	<cfargument name="propertyid" required="true" type="string">
   	<cfargument name="strcheckin" required="false">

		<cfset var qryGetPropertyPriceRange = "">

		<cfquery name="qryGetPropertyPriceRange" dataSource="#variables.settings.booking.dsn#">
			select minRate as minPrice, maxRate as maxPrice
			from track_properties
			where id = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.propertyid#">
		</cfquery>

		<cfif qryGetPropertyPriceRange.recordcount gt 0 and len(qryGetPropertyPriceRange.minPrice) and len(qryGetPropertyPriceRange.maxPrice) and qryGetPropertyPriceRange.minPrice neq qryGetPropertyPriceRange.maxPrice>
		  <cfset tempReturn = DollarFormat(qryGetPropertyPriceRange.minPrice) & ' - ' & DollarFormat(qryGetPropertyPriceRange.maxPrice) & ' <small>Per Night</small>'>
		<cfelseif qryGetPropertyPriceRange.recordcount gt 0 and len(qryGetPropertyPriceRange.minPrice) and len(qryGetPropertyPriceRange.maxPrice) and qryGetPropertyPriceRange.minPrice eq qryGetPropertyPriceRange.maxPrice>
			<cfset tempReturn = DollarFormat(qryGetPropertyPriceRange.maxPrice) & ' <small>Per Night</small>'>
		<cfelse>
		  <cfset tempReturn = ''>
		</cfif>

		<cfreturn tempReturn>

   </cffunction>


   <cffunction name="getPropertyRates" returnType="query" hint="Returns all the rates for a given property">


   </cffunction> <!--- end of getPropertyRates --->



    <cffunction name="getPropertyReviews" returnType="struct" hint="Returns reviews from be_reviews">

   	<cfargument name="propertyid" required="true">

   	<cfset var qryGetPropertyReviews = "">

		<cfquery name="qryGetPropertyReviews" dataSource="#variables.settings.dsn#">
			select rvw.* , rsp.response, rsp.createdAt AS responseCreatedAt
			from be_reviews rvw
           left join be_responses_to_reviews rsp ON rvw.id = rsp.reviewID
			where rvw.unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.propertyid#">
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
			<cfset localStruct.reviewDate = qryGetPropertyReviews.reviewDate>

			<cfset StructInsert(reviewStruct,qryGetPropertyReviews.id,localStruct)>

		</cfloop>

		<cfreturn reviewStruct>

   </cffunction> <!--- end of getPropertyReviews function --->



   <cffunction name="getSearchResults" hint="Calls the API and returns search results based on user's chosen parameters">

   	<cfset var qryGetSearchResults = ''>
    <cfset var i = 0>
    <cfset var numNights = 0>
    <cfset var theDate = "">
    <cfset var formattedStrCheckin = "">
    <cfset var formattedStrCheckout = "">


   	<cftry>

				<cfquery name="qryGetSearchResults" dataSource="#settings.booking.dsn#">
					select
					id as propertyid,
					seoFriendlyURL as seopropertyname,
					name,
					latitude,
					longitude,
					bedrooms,
					locality as `location`,
					fullBathrooms as bathrooms,
		      threeQuarterBathrooms,
    		  halfBathrooms,
					petsFriendly as petsAllowed,
					lodgingTypeName as `type`,
					minRate as minprice,
					maxRate as maxprice,
					IF(length(coverImage), coverImage, (select original from track_properties_images where  track_properties_images.propertyid = track_properties.id order by `order` limit 1)) as defaultPhoto,
					streetAddress as address,
					maxoccupancy as sleeps,
					(select avg(rating) as average from be_reviews where unitcode = track_properties.id) as avgRating

					<cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate>

						<cfset numNights = DateDiff('d',session.booking.strCheckin,session.booking.strCheckout)>

						,(SELECT sum(theRate)
            <!---
                     + (SELECT sum(feeAmount)
                        FROM track_properties_fees
                        WHERE propertyID = track_properties.id
                              AND feeType = 'Flat'
                              <cfloop index="i" from="1" to="#numNights#">
                                <cfset theDate = DateAdd('d',i-1,session.booking.strCheckin)>
                                <cfset theDateFormatted = DateFormat(theDate,'yyyy-mm-dd')>
                                 AND '#theDateFormatted#' BETWEEN startDate AND endDate
                              </cfloop>
                        )
												--->
              FROM track_properties_rates
              WHERE propertyid = track_properties.id
                    AND theDate IN (
                                      <cfloop index="i" from="1" to="#numNights#">
                                        <cfset theDate = DateAdd('d',i-1,session.booking.strCheckin)>
                                        <cfset theDateFormatted = DateFormat(theDate,'yyyy-mm-dd')>
                                        "#theDateFormatted#"
                                        <cfif i lt numNights>,</cfif>
                                      </cfloop>
                                    )
						) as searchByDatePrice
            <!---
            ,
            (SELECT sum(taxRate)
             FROM track_properties_taxes
             WHERE propertyID = track_properties.id
                   AND taxType = 'Percent'
                   <cfloop index="i" from="1" to="#numNights#">
                     <cfset theDate = DateAdd('d',i-1,session.booking.strCheckin)>
                     <cfset theDateFormatted = DateFormat(theDate,'yyyy-mm-dd')>
                      AND '#theDateFormatted#' BETWEEN startDate AND endDate
                   </cfloop>
                   ) AS taxRate
									 --->

					<cfelse>

						,minRate as 'MapPrice'

					</cfif>

					from track_properties

					where 1=1

					/* User is searching with dates */
					<cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate>

						<cfset formattedStrCheckin = Dateformat(session.booking.strCheckin,'yyyy-mm-dd')>
						<cfset formattedStrCheckout = Dateformat(session.booking.strCheckout,'yyyy-mm-dd')>

						<cfloop index="i" from="1" to="#numNights#">
							<cfset loopDate = DateFormat(DateAdd('d',i-1,session.booking.strcheckin),'yyyy-mm-dd')>
							/* Let's make sure that each day from arrival to departure is available */
							and id IN
							(
								SELECT distinct propertyid
                FROM track_properties_availability
								WHERE theDate = '#loopDate#' and avail = 1 <cfif i eq 1> and allowArrival = 1</cfif>
									/* This is the start date, we also need to check the allowArrival value */
							)
						</cfloop>

						/*
						We also need to confirm the user is staying long enough
						The track_properties_availability table has a stayMin value
					   */

					   and id IN

					   	(select distinct propertyid from track_properties_availability where #numNights# >= stayMin and theDate = '#formattedStrCheckin#')

					</cfif>



					/* This file contains other search params like occupancy,bedrooms,amenities,etc. */
					<cfinclude template="/rentals/results-search-query-common.cfm">

					<cfif isdefined('session.booking.unitcodelist') and ListLen(session.booking.unitcodelist)>
						and id in (#listQualify(session.booking.unitCodeList,"'")#)
					</cfif>

					<cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate and session.booking.strSortBy eq 'price asc'>
						order by searchByDatePrice asc
					<cfelseif isdefined('session.booking.searchByDate') and session.booking.searchByDate and session.booking.strSortBy eq 'price desc'>
						order by searchByDatePrice desc
					<cfelse>
						order by #session.booking.strsortby#
					</cfif>

				</cfquery>


				<cfif isdefined('session.booking.rentalrate') and len(session.booking.rentalrate)>

					<cfset minSearchValue = #ListGetAt(session.booking.rentalrate,1)#>
					<cfset maxSearchValue = #ListGetAt(session.booking.rentalrate,2)#>

				   <cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate>

				   	<!--- Filter by base rent since the user selected dates --->
						<cfquery name="qryGetSearchResults" dbtype="query">
							select * from qryGetSearchResults where
							searchByDatePrice between '#minSearchValue#' and '#maxSearchValue#'
						</cfquery>

					<cfelse>

						<!--- Filter by the price range with a non-dated search --->
						<cfquery name="qryGetSearchResults" dbtype="query">
							select * from qryGetSearchResults where
							minprice >= '#minSearchValue#' and maxprice <= '#maxSearchValue#'
						</cfquery>

					</cfif>

				</cfif>




				<!---
<cfdump var="#qryGetSearchResults.getMetaData().getExtendedMetaData().sql#">

				<cfabort>
--->






				<cfset cookie.numResults = qryGetSearchResults.recordcount>
				<cfset session.booking.getResults = qryGetSearchResults>
			   <cfset session.booking.UnitCodeList = valueList(qryGetSearchResults.propertyid)>

		<cfcatch>
			<cfdump var="#cfcatch#">
		</cfcatch>

		</cftry>



   </cffunction>


  	<cffunction name="getSearchResultsNew" hint="Calls the API and returns search results based on user's chosen parameters">
	   	<cfset var qryGetSearchResults = ''>
	    <cfset var i = 0>
	    <cfset var numNights = 0>
	    <cfset var theDate = "">
	    <cfset var formattedStrCheckin = "">
	    <cfset var formattedStrCheckout = "">


	   	<cftry>
			<cfquery name="qryGetSearchResults" dataSource="#settings.booking.dsn#">
			select 	id as propertyid,seoFriendlyURL as seopropertyname,name,latitude,longitude,
					bedrooms,locality as `location`,fullBathrooms as bathrooms,threeQuarterBathrooms,halfBathrooms,
					petsFriendly as petsAllowed,lodgingTypeName as `type`,minRate as minprice,maxRate as maxprice,
					IF(length(coverImage), coverImage, (select original from track_properties_images where  track_properties_images.propertyid = track_properties.id order by `order` limit 1)) as defaultPhoto,streetAddress as address,maxoccupancy as sleeps,
					(select avg(rating) as average from be_reviews where unitcode = track_properties.id) as avgRating

				<cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate>
					<cfset numNights = DateDiff('d',session.booking.strCheckin,session.booking.strCheckout)>
					,(select sum(theRate) from track_properties_rates where propertyid = track_properties.id
						and theDate in(
	                              <cfloop index="i" from="1" to="#numNights#">
	                                <cfset theDate = DateAdd('d',i-1,session.booking.strCheckin)>
	                                <cfset theDateFormatted = DateFormat(theDate,'yyyy-mm-dd')>
	                                "#theDateFormatted#"
	                                <cfif i lt numNights>,</cfif>
	                              </cfloop>
	                            )
					) as searchByDatePrice
				<cfelse>
					,minRate as 'MapPrice'
				</cfif>

				from track_properties
				where 1 = 1

				/* User is searching with dates */
				<cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate>
					<cfset formattedStrCheckin = Dateformat(session.booking.strCheckin,'yyyy-mm-dd')>
					<cfset formattedStrCheckout = Dateformat(session.booking.strCheckout,'yyyy-mm-dd')>

					<cfloop index="i" from="1" to="#numNights#">
						<cfset loopDate = DateFormat(DateAdd('d',i-1,session.booking.strcheckin),'yyyy-mm-dd')>
						/* Let's make sure that each day from arrival to departure is available */
						/* This is the start date, we also need to check the allowArrival value */
						and id in(select distinct propertyid from track_properties_availability where theDate = '#loopDate#' and avail = 1 <cfif i eq 1> and allowArrival = 1</cfif>)
					</cfloop>

					/*
					We also need to confirm the user is staying long enough
					The track_properties_availability table has a stayMin value
				   */

				   and id in(select distinct propertyid from track_properties_availability where #numNights# >= stayMin and theDate = '#formattedStrCheckin#')
				</cfif>

				/* This file contains other search params like occupancy,bedrooms,amenities,etc. */
				<cfinclude template="/rentals/results-search-query-common.cfm">

				<cfif isdefined('session.booking.unitcodelist') and ListLen(session.booking.unitcodelist)>
					and id in (#listQualify(session.booking.unitCodeList,"'")#)
				</cfif>

				<cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate and session.booking.strSortBy eq 'price asc'>
					order by searchByDatePrice asc
				<cfelseif isdefined('session.booking.searchByDate') and session.booking.searchByDate and session.booking.strSortBy eq 'price desc'>
					order by searchByDatePrice desc
				<cfelse>
					<cfif structKeyExists( session.booking, 'strsortby' ) and len( session.booking.strsortby ) gt 0>
						order by #session.booking.strsortby#
					<cfelse>
						<!---order by rand()--->
						order by bedrooms desc
					</cfif>
				</cfif>
			</cfquery>

			<cfif isdefined('session.booking.rentalrate') and len(session.booking.rentalrate)>
				<cfset minSearchValue = #ListGetAt(session.booking.rentalrate,1)#>
				<cfset maxSearchValue = #ListGetAt(session.booking.rentalrate,2)#>

			   <cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate>
				   	<!--- Filter by base rent since the user selected dates --->
					<cfquery name="qryGetSearchResults" dbtype="query">
					select *
					from qryGetSearchResults
					where searchByDatePrice between '#minSearchValue#' and '#maxSearchValue#'
					</cfquery>
				<cfelse>
					<!--- Filter by the price range with a non-dated search --->
					<cfquery name="qryGetSearchResults" dbtype="query">
					select *
					from qryGetSearchResults
					where minprice >= '#minSearchValue#' and maxprice <= '#maxSearchValue#'
					</cfquery>
				</cfif>
			</cfif>

			<cfset cookie.numResults = qryGetSearchResults.recordcount>
			<cfset session.booking.getResults = qryGetSearchResults>
			<cfset session.booking.UnitCodeList = valueList(qryGetSearchResults.propertyid)>
			<!---
			<cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate>
				<cfset emptarray = [] />

				<cfif isDefined("session.booking.getResults")>
					<cfif !listFindNoCase( session.booking.getResults.columnlist, 'pricingSort' )>
						<cfset queryAddColumn( session.booking.getResults, 'pricingSort', emptarray ) />
					</cfif>

					<cfloop from="1" to="#session.booking.getResults.recordcount#" index="i">
						<cfset pricingSortValue = getAjaxPriceBasedOnDatesInt( session.booking.getResults.propertyid[i], session.booking.strcheckin, session.booking.strcheckout ) />
						<cfset querySetCell( session.booking.getResults, 'pricingSort', val( pricingSortValue ), i ) />
					</cfloop>

					<cfquery name="getRentals2"  dbtype="query">
					select *
					from session.booking.getResults

					<cfif session.booking.strSortBy eq 'price asc'>
						order by searchByDatePrice asc
					<cfelseif session.booking.strSortBy eq 'price desc'>
						order by searchByDatePrice desc
					<cfelse>
						<!---order by #session.booking.strSortBy#--->
					</cfif>
					</cfquery>

					<cfset session.booking.getResults = getRentals2 />
				</cfif>
			</cfif>
			--->
			<cfcatch>
				<cfdump var="#cfcatch#">
			</cfcatch>
		</cftry>
   	</cffunction>



   <cffunction name="getSearchResultsProperty" returnType="query" hint="Returns property results if the user does a sitewide search for a given term like 'ocean front rentals'">

   	<cfargument name="searchterm" required="true">

		<cfquery DATASOURCE="#variables.settings.booking.dsn#" NAME="results">
			SELECT seoFriendlyURL as seoPropertyName,id AS propertyid,name as propertyname,shortdescription as propertydesc
			FROM track_properties
			where name like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#arguments.SearchTerm#%">
			or longdescription like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#arguments.SearchTerm#%">
			or shortdescription like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#arguments.SearchTerm#%">
			or streetAddress like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#arguments.SearchTerm#%">
		</cfquery>

		<cfreturn results>

   </cffunction> <!--- end of getSearchResultsProperty function --->



   <cffunction name="setGoogleAnalytics" returnType="string" hint="Sets the Google analytics script for the booking confirmation page">

      <cfargument name="settings" required="true">
      <cfargument name="form" required="true">
      <cfargument name="reservationNumber" required="true" type="string">

		<cfif isdefined('form.travelInsurance') and form.travelInsurance is "true">
			<cfset totalReservationAmount = form.TotalWithInsurance>
		<cfelse>
			<cfset totalReservationAmount = form.total>
		</cfif>

      <!---<cfsavecontent variable="temp">
      <cfoutput>
         <script type="text/javascript" defer>
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
         	revenue: '#totalReservationAmount#', // Grand Total
         	shipping: '0' , // Shipping cost
         	tax: '0' }); // Tax.

         	ga('ecommerce:addItem', {
         	id: '#reservationNumber#', // Transaction ID.
         	sku: '#form.propertyid#', // SKU/code.
         	name: '#form.propertyname#', // Product name.
         	category: 'Rental', // Category or variation.
         	price: '#totalReservationAmount#', // Unit price.
         	quantity: '1'}); // Quantity.

         	ga('ecommerce:send');
         </script>
      </cfoutput>
      </cfsavecontent>--->
      <cfsavecontent variable="temp">
	      <cfoutput>
			<!-- Google Tag Manager -->
			<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
			new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
			j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
			'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
			})(window,document,'script','dataLayer','GTM-PX5S4Q6');</script>
			<!-- End Google Tag Manager -->
			  
			  <script>
				window.dataLayer = window.dataLayer || [];
				dataLayer.push({
					'event': 'ICND.BookingComplete',
				   'transactionId': '#reservationNumber#',
				   'transactionAffiliation': '#settings.company#',
				   'transactionTotal': '#totalReservationAmount#',
				   'transactionTax': '0',
				   'transactionShipping': '0',
				   'transactionProducts': [{
					   'sku': '#form.propertyid#',
					   'name': '#form.propertyname#',
					   'category': 'Rental',
					   'price': '#totalReservationAmount#',
					   'quantity': 1
				   }]
				});
			  </script>
	      </cfoutput>
      </cfsavecontent>

      <cfreturn temp>

   </cffunction> <!--- end of setGoogleAnalytics function --->




   <cffunction name="setPropertyMetaData" returnType="string" hint="Sets the meta data for the property detail page">

      <cfargument name="property" required="true">

      <cfsavecontent variable="temp">
         <cfoutput>
         <title>#property.name# - Vacation Rental in #property.city#,#property.state# | #variables.settings.company#</title>
         <cfset tempDescription = striphtml(mid(property.description,1,300))>
         <meta name="description" content="#tempDescription#">
         <meta property="og:title" content="#property.name# - #variables.settings.company#">
         <meta property="og:description" content="#tempDescription#">
         <meta property="og:url" content="http://#cgi.http_host#/booking/#property.seoPropertyName#">
         <meta property="og:image" content="#property.defaultPhoto#">
         </cfoutput>
      </cfsavecontent>

      <cfreturn temp>

   </cffunction> <!--- end of setMetaData function --->



   <cffunction name="submitLeadToThirdParty" hint="Submits form information a 3rd party;used on the property detail page contact form"></cffunction>


   <cffunction name="getDistinctTypes" returnType="string" hint="Gets distinct unit types for the refine search">

   	<cfset var qryGetDistinctTypes = "">

     	<cfquery name="qryGetDistinctTypes" dataSource="#variables.settings.booking.dsn#">
   		select distinct lodgingTypeName from track_properties order by lodgingTypeName
   	</cfquery>

   	<cfset typeList = ValueList(qryGetDistinctTypes.lodgingTypeName)>

   	<cfreturn typeList>

   </cffunction>



   <!--- This might need to be adjusted per-client based on what they have in their table --->
   <cffunction name="getDistinctAreas" returnType="string" hint="Gets distinct areas for the refine search">

   	<cfset var qryGetDistinctAreas = "">

   	<cfquery name="qryGetDistinctAreas" dataSource="#variables.settings.booking.dsn#">
   		select distinct area from track_properties order by area
   	</cfquery>

   	<cfset areaList = ValueList(qryGetDistinctAreas.area)>

   	<cfreturn areaList>

   </cffunction>


   <!--- This might need to be adjusted per-client based on what they have in their table --->
   <cffunction name="getDistinctViews" returnType="string" hint="Gets distinct views for the refine search">

   </cffunction>



   <cffunction name="getAllProperties" returnType="query" hint="Returns a query of all properties">

   	<cfset var qryGetAllProperties = "">

   	<cfquery name="qryGetAllProperties" dataSource="#variables.settings.booking.dsn#">
   		select
   			distinct id as propertyid,
   			name,
   			seoFriendlyURL as seopropertyname,
   			maxoccupancy as sleeps,
   			bedrooms,
   			fullBathrooms as bathrooms
   		from track_properties order by name
   	</cfquery>

   	<cfreturn qryGetAllProperties>

   </cffunction>

   <cffunction name="insertAPILogEntry" hint="Logs any API request to the apilogs table">

	   <cfargument name="page">
	   <cfargument name="req">
	   <cfargument name="res">

	   <cftry>

				<cfquery datasource="#variables.settings.dsn#">
         		insert into apilogs
         		set
	            page = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.page#">,
	            req = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.req#">,
	            res = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.res#">
      	   </cfquery>

	   <cfcatch>

	      <!--- Change to Jonathan and Randy after go live --->
	      <!---
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
--->


	   </cfcatch>

	   </cftry>

	</cffunction>


	<cffunction name="getRandomProperties" returnType="query">

		<cfset var qryGetRandomProperties = ''>

		<cfquery name="qryGetRandomProperties" datasource="#variables.settings.booking.dsn#">

		select
				id as propertyid,
				seoFriendlyURL as seopropertyname,
				name,
				bedrooms,
				locality as `location`,
				fullBathrooms as bathrooms,
				petsFriendly as petsAllowed,
				unitTypeName as `type`,
				0 as minprice,
				0 as maxprice,
				IF(length(coverImage), coverImage, (select original from track_properties_images where  track_properties_images.propertyid = track_properties.id order by `order` limit 1)) as defaultPhoto,
				maxoccupancy as sleeps,
				(select avg(rating) as average from be_reviews where unitcode = track_properties.id) as avgRating

			from track_properties

			order by rand() limit 2

		</cfquery>

		<cfreturn qryGetRandomProperties>

	</cffunction>


	<cffunction name="getSearchFilterCount" returnType="string">

		<cfargument name="filter" required="true" type="string">
		<cfargument name="category" required="true" type="string">

		<cfset var qryGetSearchFilterCount = ''>

		<cfif arguments.category eq 'amenity'>
			<cfquery name="qryGetSearchFilterCount" dataSource="#variables.settings.booking.dsn#">
				select count(propertyid) as numRecords from track_properties_amenities where amenityName = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.filter#">
			</cfquery>
			<cfreturn qryGetSearchFilterCount.numRecords>
		<cfelseif arguments.category eq 'type'>
			<cfquery name="qryGetSearchFilterCount" dataSource="#variables.settings.booking.dsn#">
				select count(id) as numRecords from track_properties where lodgingTypeName = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.filter#">
			</cfquery>
			<cfreturn qryGetSearchFilterCount.numRecords>
		<cfelseif arguments.category eq 'view'>
			<cfquery name="qryGetSearchFilterCount" dataSource="#variables.settings.booking.dsn#">
				select count(id) as numRecords from track_properties where view = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.filter#">
			</cfquery>
			<cfreturn qryGetSearchFilterCount.numRecords>
		<cfelseif arguments.category eq 'complex'>
			<cfquery name="qryGetSearchFilterCount" dataSource="#variables.settings.booking.dsn#">
			SELECT count(id) as numRecords
      FROM track_properties
      WHERE nodeID = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.filter#">
			</cfquery>
			<cfreturn qryGetSearchFilterCount.numRecords>
		<cfelseif arguments.category eq 'area'>
			<cfquery name="qryGetSearchFilterCount" dataSource="#variables.settings.booking.dsn#">
			SELECT count(id) as numRecords
      FROM track_properties
      WHERE nodeID = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.filter#">
			</cfquery>
			<cfreturn qryGetSearchFilterCount.numRecords>
		<cfelseif arguments.category eq 'Must Haves'>
			<cfquery name="qryGetSearchFilterCount" dataSource="#variables.settings.booking.dsn#">
				select count(id) as numRecords from track_properties where id IN (select distinct propertyid from track_properties_amenities where amenityName = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.filter#">)
			</cfquery>
			<cfreturn qryGetSearchFilterCount.numRecords>
		<cfelse>
			<cfreturn 0>
		</cfif>

	</cffunction>


	<cffunction name="getPriceBasedOnDates" returnType="string" hint="Returns the rental rate for a given property based on the arrival date">

   	<cfargument name="propertyid" required="true" type="string">
   	<cfargument name="strcheckin" required="true" type="date">
   	<cfargument name="strcheckout" required="true" type="date">

   	<cfset var qryGetPriceBasedOnDates = "">

		<cfset var numNights = 7>

		<cfquery name="qryGetPriceBasedOnDates" dataSource="#variables.settings.booking.dsn#">
			select sum(theRate) as sumTheRate
			from track_properties_rates
			where propertyid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#arguments.propertyid#">
			and theDate IN
			(
				<cfloop from="0" to="#numNights#-1" index="i">

					<cfset theDate = DateAdd('d',arguments.strCheckin,i)>
					<cfset theDateFormatted = DateFormat(theDate,'yyyy-mm-dd')>

					"#theDateFormatted#"

					<cfif i lt numNights>,</cfif>

				</cfloop>
			)

		</cfquery>

		<cfif qryGetPriceBasedOnDates.recordcount gt 0>
			<cfset tempReturn = DollarFormat(qryGetPriceBasedOnDates.sumTheRate) & ' <small>+Taxes and Fees</small>'>
		<cfelse>
		  <cfset tempReturn = ''>
		</cfif>

		<cfreturn tempReturn>

   </cffunction>

	<cffunction name="getAjaxPriceBasedOnDates" returnType="string" hint="Returns the rental rate for a given property based on the arrival date">
	   	<cfargument name="propertyID" required="true" type="string">
	   	<cfargument name="strcheckin" required="true" type="date">
	   	<cfargument name="strcheckout" required="true" type="date">

	   	<cfset var totalAmount = "">
	    <cfset var formFields = "">

   		<cfif cgi.HTTP_USER_AGENT does not contain 'bot'>
   			<cftry>
				<cfset formFields =
				{
					"unitId": #arguments.propertyid#,
					"arrivalDate": "#DateFormat(arguments.strcheckin,'yyyy-mm-dd')#",
					"departureDate": "#DateFormat(arguments.strcheckout,'yyyy-mm-dd')#"
				}>

				<cfhttp method="post" url="#settings.booking.track_api_endpoint#/api/pms/quote" username="#settings.booking.username#" password="#settings.booking.password#">
					<cfhttpparam type="header" name="Accept" value="*/*">
					<cfhttpparam type="header" name="Content-type" value="application/json" />
					<cfhttpparam type="body" value="#serializeJSON(formFields)#">
				</cfhttp>

		      	<cfif isdefined('cfhttp.FileContent') and isJSON(cfhttp.FileContent)>
					<cfset json = DeserializeJSON(cfhttp.FileContent)>

					<cfif StructKeyExists(json,'detail')>
						<cfset apiResponse = json.detail>
					<cfelseif StructKeyExists(json,'breakdown') and StructKeyExists(json.breakdown,'charges') and StructKeyExists(json.breakdown.charges,'itemized')>
						<cfset totalAmount = json.breakdown.total>
					</cfif>
		      	</cfif>

				<cfcatch>
					<cfif isdefined("ravenClient")>
						<cfset ravenClient.captureMessage('Track.cfc->getAjaxPriceBasedOnDates = ' & cfcatch.message)>
					</cfif>
				</cfcatch>
			</cftry>
   		</cfif>

		<cfif IsNumeric(totalAmount)>
			<cfreturn "Grand Total: #DollarFormat(totalAmount)#">
		<cfelse>
			<cfreturn "">
		</cfif>
   </cffunction>

	<cffunction name="getAjaxPriceBasedOnDatesInt" returnType="string" hint="Returns the rental rate for a given property based on the arrival date without the formatting">
		<cfargument name="propertyID" required="true" type="string">
		<cfargument name="strcheckin" required="true" type="date">
		<cfargument name="strcheckout" required="true" type="date">
		<cfset var totalAmount = "">
		<cfset var formFields = "">

		<cfif cgi.HTTP_USER_AGENT does not contain 'bot'>
			<cftry>
				<cfset formFields =
				{
					"unitId": #arguments.propertyid#,
					"arrivalDate": "#DateFormat(arguments.strcheckin,'yyyy-mm-dd')#",
					"departureDate": "#DateFormat(arguments.strcheckout,'yyyy-mm-dd')#"
				}>

				<cfhttp method="post" url="#settings.booking.track_api_endpoint#/api/pms/quote" username="#settings.booking.username#" password="#settings.booking.password#">
					<cfhttpparam type="header" name="Accept" value="*/*">
					<cfhttpparam type="header" name="Content-type" value="application/json" />
					<cfhttpparam type="body" value="#serializeJSON(formFields)#">
				</cfhttp>

				<cfif isdefined('cfhttp.FileContent') and isJSON(cfhttp.FileContent)>
					<cfset json = DeserializeJSON(cfhttp.FileContent)>

					<cfif StructKeyExists(json,'detail')>
						<cfset apiResponse = json.detail>
					<cfelseif StructKeyExists(json,'breakdown') and StructKeyExists(json.breakdown,'charges') and StructKeyExists(json.breakdown.charges,'itemized')>
						<cfset totalAmount = json.breakdown.total>
					</cfif>
				</cfif>

				<cfcatch>
					<cfif isdefined("ravenClient")>
						<cfset ravenClient.captureMessage('Track.cfc->getAjaxPriceBasedOnDates = ' & cfcatch.message)>
					</cfif>
				</cfcatch>
			</cftry>
		</cfif>

		<cfif isNumeric(totalAmount)>
			<cfreturn totalAmount>
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction>
  <!---
  <cffunction name="getPropertyFees">
    <cfargument name="propertyid" required="true" />
    <cfargument name="filter" required="false" />

    <cfset var qryPropertyFees = '' />

    <cfquery name="qryPropertyFees" datasource="#variables.settings.booking.dsn#">
    SELECT id,feeName,feeType,feeAmount,startDate,endDate
    FROM track_properties_fees
    WHERE propertyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#val( arguments.propertyid )#" />
    </cfquery>
  </cffunction>
  --->

  <cffunction name="getGoogleSearchLog" returntype="string" hint="Returns a ga event to log an initial or refined search">
      <cfargument name="searchType" type="string" required="true" default="initial" hint="initial or refine">
      <!--- log the search with Google Analytics (in results.cfm & ajax/results.cfm)
        These definitions will be different from client to client, and will be provided by SEO
        The code below will need
        dimension1, = Arrival Date
        dimension2, = Number of Nights
        dimension3, = Bedroom Size
        dimension4 = Amenities --->

      <cfset local = structNew()>
      <cfset local.dimensionsList = ''>

      <cfif arguments.searchType is 'refine'>
          <cfset local.searchType = 'Refine'>
      <cfelse>
          <cfset local.searchType = 'Initial'>
      </cfif>

      <!--- Build a single "list" of all the items for the JSON array --->
      <cfif session.booking.searchByDate and isDefined('session.booking.strcheckin') and isValid('date', session.booking.strcheckin) and
            isDefined('session.booking.strcheckout') and isValid('date', session.booking.strcheckout)>
            <cfset numNights = DateDiff('d',session.booking.strcheckin, session.booking.strcheckout)>
            <cfset local.dimensionsList = listAppend(local.dimensionsList, "'dimension1':'#dateFormat(session.booking.strcheckin,'yyyy-mm-dd')#'")>
            <cfset local.dimensionsList = listAppend(local.dimensionsList, "'dimension2':'#dateFormat(session.booking.strcheckout,'yyyy-mm-dd')#'")>
            <cfset local.dimensionsList = listAppend(local.dimensionsList, "'dimension3':#numNights#")>
      </cfif>

      <cfif isDefined('session.booking.town') and len(session.booking.town)>
        <cfquery name="qryTownList" datasource="#variables.settings.booking.dsn#">
          SELECT GROUP_CONCAT(TRIM(name) ORDER BY name ASC) AS townList
          FROM track_nodes
          WHERE id IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#session.booking.town#">)
        </cfquery>

        <cfset local.townList = xmlFormat(qryTownList.townList)>
        <cfset local.dimensionsList = listAppend(local.dimensionsList, "'dimension4':'#local.townList#'")>
      </cfif>

      <cfif isdefined('session.booking.bedrooms') and session.booking.bedrooms neq '' and session.booking.bedrooms neq 0>
          <cfset local.dimensionsList = listAppend(local.dimensionsList, "'dimension5':'#session.booking.bedrooms#'")>
      </cfif>

      <cfif isdefined('session.booking.FLEX_DATES') and len(session.booking.FLEX_DATES) AND session.booking.FLEX_DATES EQ 'on'>
          <cfset local.dimensionsList = listAppend(local.dimensionsList, "'dimension6':'Flex Yes'")>
      <cfelse>
          <cfset local.dimensionsList = listAppend(local.dimensionsList, "'dimension6':'Flex No'")>
      </cfif>

      <cfif isdefined('session.booking.amenities') and ListLen(session.booking.amenities)>
          <cfset local.dimensionsList = listAppend(local.dimensionsList, "'dimension7':'#session.booking.amenities#'")>
      </cfif>

      <cfsavecontent variable="local.returnString">
          <cfoutput>
              <!---gtag('event', 'User #local.searchType# Search', {#local.dimensionsList#});--->
              dataLayer.push({'event': 'User #local.searchType# Search' ,#local.dimensionsList#});
          </cfoutput>
      </cfsavecontent>

      <cfreturn local.returnString>
  </cffunction>

  <cffunction name="associativeArrayToQuery" hint="Turns an array into a query.">
      <cfargument name="array_var" required="true" type="array" />

      <cftry>
        <cfset local.array_to_query = '' />

        <cfif isArray( arguments.array_var ) and arrayLen( arguments.array_var ) gt 0>
          <cfset local.query_columns = structKeyList( arguments.array_var[1] ) />
          <cfset local.query_columns &= ',sort' />
          <cfset local.array_to_query = queryNew( local.query_columns ) />
          
          <cfloop from="1" to="#arrayLen( arguments.array_var )#" index="i">
            <cfset local.array_to_query_row = queryAddRow( local.array_to_query ) />
            <cfset local.sort = 1 />

            <cfloop collection="#arguments.array_var[i]#" item="j">
              <cfif arguments.array_var[i][j] contains 'Car Pass'>
                <cfset local.sort = 0 />
              </cfif>

              <cfset querySetCell( local.array_to_query, j, arguments.array_var[i][j], local.array_to_query_row ) />
              <cfset querySetCell( local.array_to_query, 'sort', local.sort, local.array_to_query_row ) />
            </cfloop>
          </cfloop>
        </cfif>

        <cfcatch>
          <cfdump var="#cfcatch#" abort="true" />
        </cfcatch>
      </cftry>

      <cfreturn local.array_to_query />
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