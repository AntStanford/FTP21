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

getMinMaxAmenities

getMinMaxPrice

getProperty

getPropertyAmenities

getPropertyPhotos

getPropertyPriceRange

getPropertyRates

getPropertyReviews

getSearchResults

getSearchResultsResorts

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

getGoogleSearchLog
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

   <cffunction name="bookNow" returnType="string" hint="Used in book-now_.cfm to check availability and get pricing for the checkout page">

		<cfargument name="propertyid" required="true">
		<cfargument name="strcheckin" required="true">
		<cfargument name="strcheckout" required="true">
		<cfargument name="promoCode" required="false">
		<cfargument name="pets" required="false" default="0">
<!--- <cfset settings.booking.track_api_endpoint = "https://summit.stg-3.trackstaging.info">
<cfset settings.booking.username = "fa9c5c35b2367eca53db86fc82d30f24">
<cfset settings.booking.password = "44cec62b40065773b027a025275921f1"> --->
		<!--- Local variables --->
		<cfset var unitAvailable = "yes">
		<cfset var totalamount = 0>
		<cfset var travelinsuranceAmt = 0>
		<cfset local.apiresponse = ''>
		<cfset local.apiformFields = ''>
		<cfset local.booknowjson = ''>

		<!--- Let's just double check and make sure it's still available --->
	<cftry>

			<cfif isdefined('arguments.pets') and pets GT 0>
				<cfif isdefined('arguments.promoCode') and len(arguments.promoCode)>
					<cfset local.apiformFields =
					{
					"unitId": #arguments.propertyid#,
					"arrivalDate": "#DateFormat(arguments.strcheckin,'yyyy-mm-dd')#",
					"departureDate": "#DateFormat(arguments.strcheckout,'yyyy-mm-dd')#",
					"promoCode":"#arguments.promoCode#",
					"occupants":{"pets":#arguments.pets#}
					}>
				<cfelse>
					<cfset local.apiformFields =
					{
					"unitId": #arguments.propertyid#,
					"arrivalDate": "#DateFormat(arguments.strcheckin,'yyyy-mm-dd')#",
					"departureDate": "#DateFormat(arguments.strcheckout,'yyyy-mm-dd')#",
					"occupants":{"pets":#arguments.pets#}
					}>
				</cfif>
			<cfelse>
				<cfif isdefined('arguments.promoCode') and len(arguments.promoCode)>
					<cfset local.apiformFields =
					{
					"unitId": #arguments.propertyid#,
					"arrivalDate": "#DateFormat(arguments.strcheckin,'yyyy-mm-dd')#",
					"departureDate": "#DateFormat(arguments.strcheckout,'yyyy-mm-dd')#",
					"promoCode":"#arguments.promoCode#"
					}>
				<cfelse>
					<cfset local.apiformFields =
					{
					"unitId": #arguments.propertyid#,
					"arrivalDate": "#DateFormat(arguments.strcheckin,'yyyy-mm-dd')#",
					"departureDate": "#DateFormat(arguments.strcheckout,'yyyy-mm-dd')#"
					}>
				</cfif>
			</cfif>


		<cfhttp method="post" url="#settings.booking.track_api_endpoint#/api/pms/quote" username="#settings.booking.username#" password="#settings.booking.password#" result="apiQuoteResponse">
			<cfhttpparam type="header" name="Accept" value="*/*">
			<cfhttpparam type="header" name="Content-type" value="application/json" />
			<cfhttpparam type="body" value="#serializeJSON(local.apiformFields)#">
		</cfhttp>

	      <cfcatch>
				<cfif isdefined("ravenClient")>
					<cfset ravenClient.captureException(cfcatch)>
				</cfif>
	         <cfset local.apiresponse = "Error: #cfcatch.message#">
	      </cfcatch>

      </cftry>

		<cfif isdefined('apiQuoteResponse.FileContent') and isJSON(apiQuoteResponse.FileContent)>
		<cfset insertAPILogEntry(cgi.script_name,#serializeJSON(local.apiformFields)#,apiQuoteResponse.FileContent)>
			<cftry>
				<cflock timeout="10" scope="Session">
					<cfset local.booknowjson = DeserializeJSON(apiQuoteResponse.FileContent)>
					<cfset json = DeserializeJSON(apiQuoteResponse.FileContent)>

					<cfif StructKeyExists(local.booknowjson,'detail')>
						<cfset local.apiResponse = local.booknowjson.detail>
					<cfelse>


						<!--- <cfif ListFind('70.40.100.144', CGI.REMOTE_ADDR)> --->


								<cfquery name="qryAddons" datasource="#settings.dsn#">
									select * from cms_checkout_addons
								</cfquery>
<!---
								<cfif ListFind('70.40.100.144,99.1.177.220', CGI.REMOTE_ADDR)>
									ICND EYES ONLY<br>
									<cfdump var="#local.booknowjson#">
									<cfdump var="#local.booknowjson.unit#"><cfdump var="#local.booknowjson.breakdown.total#">
									<!--- <cfdump var="#DeserializeJSON(cfhttp.FileContent)#"> ---><!---  --->
								</cfif>
 --->






								<cfset variables.defaultDaysOut = 30> <!--- 60 ---> <!--- also change in book-now.cfm line 128 --->

									<!--- Calculate the Deposit --->
									<!--- Loop through taxes, parse Tax percent and calculate total tax --->
									<cfset variables.booknowTemp.totalTaxPercent = 0>
									<cfset variables.booknowTemp.servicefees = 0>

										<cfloop array="#local.booknowjson.breakdown.taxes.itemized#" index="i">
											<cfset variables.booknowTemp.totalTaxPercent = variables.booknowTemp.totalTaxPercent + application.bookingObject.parseTaxPercentage(i.name)>
										</cfloop>
										<cfloop array="#local.booknowjson.charges.required#" index="i">
											<cfif i.displayAs eq 'fees'>
												<cfset variables.booknowTemp.servicefees = variables.booknowTemp.servicefees + i.itemPrice>
											</cfif>
										</cfloop>

									<!--- <cfset variables.booknowTemp.percentageOfRent = local.booknowjson.breakdown.rent / 10> ---> <!--- 10% of Rent --->

									<cfset variables.booknowTemp.percentageOfRent = local.booknowjson.breakdown.rent * (30/100)> <!--- 30% of Rent --->
									<cfset variables.booknowTemp.taxTotal = (variables.booknowTemp.percentageOfRent + variables.booknowTemp.servicefees) * variables.booknowTemp.totalTaxPercent>
									<cfset variables.booknowTemp.taxTotal = variables.booknowTemp.taxTotal / 100>
									<cfset variables.booknowTemp.thisDeposit = variables.booknowTemp.percentageOfRent + variables.booknowTemp.servicefees + variables.booknowTemp.taxTotal>
									<cfset variables.depositTotal = NumberFormat(variables.booknowTemp.thisDeposit,'______.__')>
									<cfset variables.depositTotal = TRIM(variables.depositTotal)>
									<!--- <cfif ListFind('216.99.119.254,70.40.100.144,173.16.13.172', CGI.REMOTE_ADDR)><cfdump var="#local.booknowjson.breakdown.deposit#"></cfif> --->

	<cfset variables.depositTotal = local.booknowjson.breakdown.deposit>

<!--- <cfdump var="#local.booknowjson#"> --->
		<cfset variables.booknowTemp.daysout = dateDiff( 'd', dateFormat( now(), 'yyyy-mm-dd' ), arguments.strcheckin ) />
		<cfset variables.booknowTemp.today = dateFormat( now(), 'yyyy-mm-dd' ) />
		<cfset variables.booknowTemp.duetoday = 0 />
		<cfset variables.booknowTemp.duelater = 0 />

		<cfif structKeyExists( json, 'paymentPlan' )>
			<cfset variables.booknowTemp.pp_array = structKeyArray( json.paymentPlan ) />
			<!---
				If the arrival date is <= 30 days, there is only one paymentPlan
				If it's > 30 days, there are two
			--->
			<cfif arrayLen( variables.booknowTemp.pp_array ) eq 2>
				<!--- the array of days aren't in order so we check which amount matches today --->
				<cfif json.paymentPlan[variables.booknowTemp.pp_array[1]] eq json.paymentPlan['#variables.booknowTemp.today#']>
					<cfset variables.booknowTemp.duetoday += json.paymentPlan[variables.booknowTemp.pp_array[1]] />
					<cfset variables.booknowTemp.duelater += json.paymentPlan[variables.booknowTemp.pp_array[2]] />
				<cfelse>
					<cfset variables.booknowTemp.duetoday += json.paymentPlan[variables.booknowTemp.pp_array[2]] />
					<cfset variables.booknowTemp.duelater += json.paymentPlan[variables.booknowTemp.pp_array[1]] />
				</cfif>
			<cfelse>
				<cfset variables.booknowTemp.duetoday += json.paymentPlan[variables.booknowTemp.pp_array[1]] />
			</cfif>
		<cfelse>
			<cfset variables.booknowTemp.duetoday += json.breakdown.total />
		</cfif>

		<cfset variables.depositTotal = variables.booknowTemp.duetoday>
		<cfset variables.defaultDaysOut = variables.booknowTemp.daysout>

<!--- <cfif ListFind('216.99.119.254,173.16.13.172', CGI.REMOTE_ADDR)>
<cfdump var="#local.booknowjson#">
<cfdump var="#variables.booknowTemp#">
</cfif> --->




								<cfoutput>
									<div id="hiddenDeposit" style="display:none;" data-cost="#variables.depositTotal#"></div>


									<cfparam name="url.paychoice" default=""> <!--- TT-121221: Disabled; was causing bad quote --->
									<cfif url.paychoice EQ "undefined">
										<cfset url.paychoice  = "half">
									</cfif>

									<!--- Loop through all the taxes and fees and tally up the total amount --->
									<cfif StructKeyExists(json,'breakdown') and StructKeyExists(local.booknowjson.breakdown,'charges') and StructKeyExists(local.booknowjson.breakdown.charges,'itemized')>
										<!--- <cfif ListFind('216.99.119.254,209.188.44.35,75.87.75.62', CGI.REMOTE_ADDR)>ICND Eyes Only: Call <cfdump var="#serializeJSON(variables.formFields)#"> Response Unit: <cfdump var="#local.booknowjson.unit.name#"></cfif> --->
										<!--- if arrival date is more than 60 days out form today, off half payment --->
										<cfset numdaysout = dateDiff( 'd', now(), url.strcheckin ) />
										<cfset taxesAndFees = 0 />
										<!--- <cfset halftotal = 0 /> --->
										<cfset halftotal = variables.depositTotal />

										<div class="panel-group property-cost-list<cfif isDefined('url.expanded') AND url.expanded EQ 'true'> pclOpen</cfif>">
											<div class="panel panel-default">
												<div id="collapse1" class="panel-collapse collapse <cfif isDefined('url.expanded') AND url.expanded EQ 'true'> in</cfif>" <cfif isDefined('url.expanded') AND url.expanded EQ 'true'> aria-expanded="true"</cfif>>
													<div class="panel-body">
														<div class="property-cost-list-rent"><strong>Rent <span class="jackpot-message"></span></strong> <span class="text-right">#DollarFormat(local.booknowjson.breakdown.rent)#</span></div>
														<cfset taxesAndFees = 0>

														<cfloop array="#local.booknowjson.breakdown.charges.itemized#" index="charge">
															<cfset chargeValue = charge.value>
															<cfset taxesAndFees = taxesAndFees + chargeValue>
														</cfloop>

														<cfset taxesAndFees = taxesAndFees + local.booknowjson.breakdown.taxes.total>

														<cfsavecontent variable="charges">
															<cfloop array="#local.booknowjson.breakdown.taxes.itemized#" index="charge">
																<div class='property-cost-list-taxes-fees-looped'><strong>#charge.name#</strong> - <span>#DollarFormat(charge.value)#</span></div>
															</cfloop>
														</cfsavecontent>
														<!--- <div class="property-cost-list-taxes-fees" data-toggle="tooltip" data-html="true" title="#charges#"><strong>Taxes & Fees</strong> <span class="text-right">#DollarFormat(taxesAndFees)#</span> <i class="fa fa-info-circle" aria-hidden="true"></i></div> --->
														<!--- <div class="property-cost-list-cleaning-fee"><strong>Cleaning Fee</strong> <span class="text-right">$#local.booknowjson.breakdown.charges.itemized[2].value#</span></div> --->
														<cfloop array="#local.booknowjson.breakdown.charges.itemized#" index="item">
															<div class="property-cost-list-service-fees"><strong>#item.name#</strong> <span class="text-right">$#item.value#</span></div>
														</cfloop>
														<!--- <div class="property-cost-list-service-fees"><strong>Service Fees</strong> <span class="text-right">$#local.booknowjson.breakdown.charges.itemized[1].value#</span></div> --->

														<cfloop query="qryAddons">
															<div class="property-cost-list-service-fees" id="addon_#qryAddons.track_id#" style="display:none"><strong>#qryAddons.title# <a onclick="javascript:removeAddon(#qryAddons.track_id#)" href="javascript:;">Remove</a></strong> <span class="text-right" id="addon_price_#qryAddons.track_id#"></span></div>
														</cfloop>

														<div class="property-cost-list-taxes"><strong>Taxes</strong> <span class="text-right">$#local.booknowjson.breakdown.taxes.total#</span></div>

														<cfif StructKeyExists(json,'promoCode')>
															<span id="discount" data-amount="#local.booknowjson.breakdown.discount#"></span>

															<cfif val( local.booknowjson.breakdown.discount ) gt 0>
																<div id="promoCodeTr" class="property-cost-list-promo-code">
																	<strong>Discount</strong> <span class="text-right">(#DollarFormat(local.booknowjson.breakdown.discount)#)</span>
																</div>
															</cfif>
															<!---<tr><td colspan="2">Promo code applied!</td></tr>--->
														</cfif>

														<div class="property-cost-list-total-with-insurance success amount-with-insurance" <cfif structKeyExists( url, 'ti' ) AND url.ti neq 'add_insurance'>style="display: none;"</cfif>>
															<strong>Optional - Travel Insurance</strong> <span class="text-right">#DollarFormat(local.booknowjson.breakdown.travelInsurance)#</span>
														</div><!--END promoCodeTr-->
													</div><!--END panel-body-->
												</div><!--END panel-collapse-->


										        <div class="alert-success amount-without-insurance" <cfif structKeyExists( url, 'ti' ) and url.ti is 'add_insurance'>style="display:none"</cfif>>
										            <h4 class="panel-title">
										                <a data-toggle="collapse" href="##collapse1" id="togglem" <cfif isDefined('url.expanded') AND url.expanded EQ 'true'> aria-expanded="true"</cfif>>
										                  <div class="property-cost-list-total"> <span id="costRowShowHide" class="glyphicon glyphicon-plus"></span> <strong><cfif val( numdaysout ) gte variables.defaultDaysOut>Total<cfelse>Total</cfif></strong> <span class="text-right" id="summarytotal">#DollarFormat(local.booknowjson.breakdown.total)#</span></div>
										                </a>
										            </h4>
										        </div><!--END alert-success-->

										        <div class="alert-success amount-with-insurance" <cfif !structKeyExists( url, 'ti' ) or (structKeyExists( url, 'ti' ) AND url.ti neq 'add_insurance')>style="display: none;"</cfif>>
										            <h4 class="panel-title">
										                <a data-toggle="collapse" href="##collapse1" id="togglem" <cfif isDefined('url.expanded') AND url.expanded EQ 'true'> aria-expanded="true"</cfif>>
										                  <div class="property-cost-list-total"> <span id="costRowShowHide" class="glyphicon glyphicon-plus"></span> <strong>Total</strong> <span class="text-right" id="summarytotal2">

																<cfif <!--- val( numdaysout ) gte variables.defaultDaysOut and--->  isDefined('url.paychoice') and url.paychoice is 'half'>
																	<b>#DollarFormat(local.booknowjson.breakdown.totalInsurance/2)#</b>
																<cfelse>
																	<b>#DollarFormat(local.booknowjson.breakdown.totalInsurance)#</b>
																</cfif>

																</span>
															</div>
										                </a>
										            </h4>
										        </div><!--END alert-success-->
										    </div><!--END panel-->
										</div><!-- END panel-group -->

										<!---
											<cfif val( numdaysout ) gte variables.defaultDaysOut>
										<!--- 											<div class="alert alert-info">
													<p><input type="radio" name="tchoice" class="tchoice" id="tchoice_total" value="full" <cfif isDefined('url.paychoice') and url.paychoice is 'full'>checked="checked"</cfif> onclick="updateSummaryOfFees()"/>
														<label for="fulltotal">Pay In Full <span id="summarytotalr">#dollarFormat( local.booknowjson.breakdown.total )#</span></label></p>
													  <p><input type="radio" name="tchoice" class="tchoice" id="tchoice_half" value="half"  <cfif (isDefined('url.paychoice') and url.paychoice is 'half')>checked="checked"</cfif> onclick="updateSummaryOfFees()"/>
														<label for="halftotal">Pay Deposit <span id="halftotalr">#dollarFormat( variables.depositTotal )#</span></label></p>
												  </div> --->
												<div class="alert alert-info">
													  <p><input type="radio" name="tchoice" class="tchoice" id="tchoice_half" value="half"  <cfif (isDefined('url.paychoice') and url.paychoice is 'half')>checked="checked"</cfif> onclick="updateSummaryOfFees()"/>
														<label for="halftotal">Due Today <span id="halftotalr">#dollarFormat( variables.depositTotal )#</span></label></p>
												  </div>
											<cfelse>
												<div class="alert alert-info">
													<p>
														<label for="fulltotal">Due Today <span id="summarytotalr2">#dollarFormat( local.booknowjson.breakdown.total )#</span></label>
													</p>
												</div>
											</cfif>
										--->
											<div class="alert alert-info" data-deposit="#variables.depositTotal#">
												<p>
													<label for="fulltotal">Due Today <span id="summarytotalr2">#dollarFormat(variables.depositTotal)#</span></label>
												</p>
											</div>

										</table>


									</cfif>

									<h3>Protect Your Trip</h3>
									<b>Travel Insurance</b> - Protect your payments should you have to cancel.<br /><br />

									<div class="alert alert-info">
								    <p><input type="radio" name="travel_insurance" class="travel_insurance" value="add_insurance" id="addinsurance" <cfif (structKeyExists( url, 'ti' ) and url.ti is 'add_insurance')>checked="checked"</cfif>>
										<label for="addinsurance">Add travel insurance for #Dollarformat(local.booknowjson.breakdown.travelInsurance)#</label></p>
									  <p><input type="radio" name="travel_insurance" class="travel_insurance" value="remove_insurance" id="removeinsurance" <cfif structKeyExists( url, 'ti' ) and url.ti is 'remove_insurance'>checked="checked"</cfif>>
										<label class="nothanks" for="removeinsurance">No thanks, I am not interested in travel insurance</label></p>
								  </div>

									<!--- This script loads the data from the API call to the hidden input fields in the checkout form --->

									<script type="text/javascript">
									   <cfif <!---val( numdaysout ) gte variables.defaultDaysOut and--->  isDefined('url.paychoice') and url.paychoice is 'half' AND not StructKeyExists(json,'promoCode')>
									   	 console.log('here1');
											<cfset ti_total = local.booknowjson.breakdown.totalInsurance / 2 />
											<cfset half_total = local.booknowjson.breakdown.total /2 />
											$('input##TotalWithInsurance').val("#ti_total#");
										    $('input##originalTotal').val("#local.booknowjson.breakdown.total#");
										    $('input##Total').val("#variables.depositTotal#");
											console.log('#variables.depositTotal#');

											$('input##tripinsuranceamount').val("#local.booknowjson.breakdown.travelInsurance#");
											$('##BookingValue').val('#variables.depositTotal#');
											$('##payHalf').val(true);

											<cfif (structKeyExists( url, 'ti' ) and url.ti is 'add_insurance')>
												$('##summarytotal2').val('#ti_total#');
											<cfelse>
												$('##summarytotal2').val('#local.booknowjson.breakdown.total#');
											</cfif>

										<cfelse>
											console.log('here2');
										   	$('input##TotalWithInsurance').val("#local.booknowjson.breakdown.totalInsurance#");
											$('input##originalTotal').val("#local.booknowjson.breakdown.total#");
											$('input##Total').val("#local.booknowjson.breakdown.total#");
											$('input##tripinsuranceamount').val("#local.booknowjson.breakdown.travelInsurance#");
											$('##BookingValue').val('#local.booknowjson.breakdown.total#');
											$('##payHalf').val(false);

											<cfif (structKeyExists( url, 'ti' ) and url.ti is 'add_insurance')>
												$('##summarytotal2').val('#local.booknowjson.breakdown.totalInsurance#');
											<cfelse>
												$('##summarytotal2').val('#local.booknowjson.breakdown.total#');
											</cfif>


										</cfif>
									</script>
								</cfoutput>

					<!--- <cfelse>
						<cfinclude template="/#settings.booking.dir#/common/_summary-of-fees-mc.cfm">
					</cfif>  --->
					<!--- end IP restriction for summary of fees include --->

					<!--- 	<cfif ListFind('70.40.100.144x', CGI.REMOTE_ADDR)>
							<cfinclude template="/#settings.booking.dir#/common/_summary-of-fees-mc.cfm">
						<cfelse>
							<cfinclude template="/#settings.booking.dir#/common/_summary-of-fees.cfm">
						</cfif> --->
						<!--- <cfinclude template="/#settings.booking.dir#/common/_summary-of-fees_orig.cfm"> --->
					</cfif>
				</cflock>
	         <cfcatch>
					<cfif isdefined("ravenClient")>
						<cfset ravenClient.captureException(cfcatch)>
					</cfif>
		         <cfset local.apiresponse = "Error: #cfcatch.message#">
	         </cfcatch>

         </cftry>

		</cfif>

		<cfreturn local.apiresponse>

   </cffunction> <!--- end of bookNow function --->

	<cffunction name="checkout" returnType="string" hint="Book and confirm the reservation">

	   	<cfargument name="form" required="true">

	   	<cfset var totalAmountForReservation = 0>
		<cfset local.num_children = 0 />

		<cfquery name="qryAddons" datasource="#settings.dsn#">
		  select * from cms_checkout_addons
		</cfquery>

		<cfsavecontent variable="local.addOnsStruct"><cfoutput query="qryAddons">{"id": #qryAddons.track_id#,"quantity": #form['optionalfeesqty'&qryAddons.track_id]#}<cfif qryAddons.currentrow neq qryAddons.recordcount>,</cfif></cfoutput></cfsavecontent>

	   	<cfset local.checkout.reservationCode = "">

	   	<cfif isdefined('form.numPets')>
	   		<cfset local.checkout.myNumPets = form.numPets>
	   	<cfelse>
	   		<cfset local.checkout.myNumPets = 0>
	   	</cfif>

		<cftry>
			<cfset local.checkout.formattedCheckin = DateFormat(form.strCheckin,'yyyy-mm-dd')>
			<cfset local.checkout.formattedCheckout = DateFormat(form.strCheckout,'yyyy-mm-dd')>
			<!---
			<cfif form.travelinsurance>
				<cfset totalamount = form.totalwithinsurance>
			<cfelse>
				<cfset totalamount = form.total>
			</cfif>
			--->
			<cfif form.fraction EQ "full" and form.travelinsurance eq true>
				<cfset local.checkout.totalamount = form.TotalWithInsurance>
			<cfelseif form.fraction EQ "full" and form.travelinsurance eq false>
				<cfset local.checkout.totalamount = form.total>
			<cfelseif form.fraction EQ "half" and form.travelinsurance eq true>
				<cfset local.checkout.totalamount = form.TotalDepositWithInsurance>
			<cfelseif form.fraction EQ "half" and form.travelinsurance eq false>
				<cfset local.checkout.totalamount = form.Deposit>
			</cfif>
			<!---
			<cfif form.fraction EQ "half">
				<cfset totalamount = decimalformat(totalamount/2)>
				<cfset totalAmount = Replace(totalamount, ",","","ALL")>
			</cfif>
			<cfif form.travelinsurance>
				<cfset totalamount = totalamount + form.tripinsuranceamount>
			</cfif>
			--->
			<cfset local.checkout.comm = form.comments>

			<cfif isdefined('form.adultages')>
				<cfset local.checkout.comm = local.checkout.comm & "     Adult Ages:#form.adultages#">
			</cfif>

			<cfif isdefined('form.childages')>
				<cfset local.num_children = form.numChild />
				<cfset local.checkout.comm = local.checkout.comm & "     Child Ages:#form.childages#">
			</cfif>

			<cfhttp method="get" url="#settings.booking.track_api_endpoint#/api/crm/contacts/?email=#form.email#" username="#settings.booking.track_hbd_username#" password="#settings.booking.track_hbd_password#" result="apiContactResponse">
				<cfhttpparam type="header" name="Accept" value="*/*">
				<cfhttpparam type="header" name="Content-type" value="application/json" />
			</cfhttp>

			<cfset local.checkout.contactInfo = deserializeJson(apiContactResponse.filecontent)>
			<cfset local.checkout.contactID = "">

			<cfif structKeyExists(local.checkout.contactinfo._embedded,"contacts") AND arrayLen(local.checkout.contactinfo._embedded.contacts)>
				<cfset local.checkout.contactID = local.checkout.contactinfo._embedded.contacts[1].id>
			</cfif>
			<!---
			<cfif cgi.remote_host eq '75.87.66.209'>
				<cfdump var="#apiContactResponse#" abort="true" />
			</cfif>
			--->
			<cfif len(local.checkout.contactID)>
				<cfset local.checkout.formFields =
				{
				  "reservation":
				  {
				    "unitId": "#form.propertyId#",
				    "arrivalDate": "#local.checkout.formattedCheckin#",
				    "departureDate": "#local.checkout.formattedCheckout#",
				    "travelInsurance": "#form.travelInsurance#",
				    "promoCode":"#form.hiddenPromoCode#",
				    "notes":[{
						"note":"#local.checkout.comm#",
						"isPublic":true
					}],
				    "occupants":{
				    	"adults":"#form.numAdults#",
				    	"pets":"#local.checkout.myNumPets#",
				    	"children": "#local.num_children#"
				    },
					"addOn": #local.addonsstruct#,
				    "contact": {
							"id": "#local.checkout.contactID#",
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
				      "amount": #local.checkout.totalamount#,
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
			<cfelse>
				<cfset local.checkout.formFields =

					{
					  "reservation":
					  {
						"unitId": "#form.propertyId#",
						"arrivalDate": "#local.checkout.formattedCheckin#",
						"departureDate": "#local.checkout.formattedCheckout#",
						"travelInsurance": "#form.travelInsurance#",
						"promoCode":"#form.hiddenPromoCode#",
						"notes":[{
							"note":"#local.checkout.comm#",
							"isPublic":true
						}],
						"occupants":{
							"adults":"#form.numAdults#",
							"pets":"#local.checkout.myNumPets#",
							"children": "#local.num_children#"
						},
						"addOn": #local.addonsstruct#,
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
						  "amount": #local.checkout.totalamount#,
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
				</cfif>
				<!--- We need to store the request, but strip out sensitive data like the credit card info --->
				<cfset local.checkout.formFieldsSafe =

				{
				  "reservation":
				  {
				    "unitId": "#form.propertyId#",
				    "arrivalDate": "#local.checkout.formattedCheckin#",
				    "departureDate": "#local.checkout.formattedCheckout#",
				    "travelInsurance": "#form.travelInsurance#",
				    "promoCode":"#form.hiddenPromoCode#",
				    "occupants":{
				    	"adults":"#form.numAdults#",
				    	"pets":"#local.checkout.myNumPets#",
				    	"children": "#local.num_children#"
				    },
					"addOn": #local.addonsstruct#,
				    "contact": {
					  "id": "#local.checkout.contactID#",
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
				      "amount": #local.checkout.totalamount#,
				      "paymentCard": {
				        "cardNumber": "**REDACTED**",
				        "cardCvv": "**REDACTED**",
				        "cardExp": "**REDACTED**",
				        "name": "**REDACTED**",
				        "postalCode": "**REDACTED**",
				        "saveCard": false
				      },
				      "fraction": "#form.fraction#"
				    },

				   "notes" :
						{
							"note": "#form.comments#",
							"isPublic": false
						}
				 }

				}>

				<cfif isDefined('session.track.trackcampaign') and structKeyExists(session.track,'trackcampaign') and len(session.track.trackcampaign) gt 0>
					<cfset local.checkout.formFields.reservation["campaignToken"] = session.track.trackcampaign />
					<cfset local.checkout.formFieldsSafe.reservation["campaignToken"] = session.track.trackcampaign />
				</cfif>

				<cfhttp method="post" url="#settings.booking.track_api_endpoint#/api/pms/reservations" username="#settings.booking.username#" password="#settings.booking.password#" result="apiResResponse">
					<cfhttpparam type="header" name="Accept" value="*/*">
					<cfhttpparam type="header" name="Content-Type" value="application/hal+json">
					<cfhttpparam type="body" value="#serializeJSON(local.checkout.formFields)#">
				</cfhttp>


			<cfif isdefined('apiResResponse.FileContent') and isJSON(apiResResponse.FileContent)>

				<cftry>

					<cfset json = DeserializeJSON(apiResResponse.FileContent)>

					<!--- Record bookings locally during testing --->
					<cfset rightNowFile = "booking-" & DateFormat(now(),'yyyy-mm-dd') & '-' & TimeFormat(now(),'HH.nn.ss') & ".txt">
					<!---<cffile action="write" file="E:\inetpub\wwwroot\domains\summitcove.com\htdocs\rentals\json\#rightNowFile#" output="#cfhttp.FileContent#" fixnewline="yes">--->

					<!--- error comes back from API --->
					<cfif StructKeyExists(json,'errors')>

						<cfset session.errorMessage = json.errors[1]>
						<cfset insertAPILogEntry(cgi.script_name,#serializeJSON(local.checkout.formFieldsSafe)#,session.errorMessage)>
						<cflocation addToken="no" url="/#settings.booking.dir#/booking-error.cfm">

					<!--- some other message comes back from API that's not the reservation number --->
					<cfelseif StructKeyExists(json,'detail')>

						<cfset session.errorMessage = json.detail>
						<cfset insertAPILogEntry(cgi.script_name,#serializeJSON(local.checkout.formFieldsSafe)#,session.errorMessage)>
						<cflocation addToken="no" url="/#settings.booking.dir#/booking-error.cfm">

					<!--- the reservation was successful; set the reservationCode, log the booking and send the confirmation email --->
					<cfelse>

						<cfset local.checkout.reservationCode = json.id>

						<cftry>
							<cfset insertAPILogEntry(cgi.script_name,serializeJSON(local.checkout.formFieldsSafe),apiResResponse.FileContent)>
						<cfcatch>
						</cfcatch>
						</cftry>

					</cfif>

		         <cfcatch>
						<cfif isdefined("ravenClient")>
							<cfset ravenClient.captureException(cfcatch)>
						</cfif>
			         <cfset session.errorMessage = cfcatch.message>
			         <cfset insertAPILogEntry(cgi.script_name,#serializeJSON(local.checkout.formFieldsSafe)#,cfcatch.message)>
			         <cflocation addToken="no" url="/#settings.booking.dir#/booking-error.cfm">
		         </cfcatch>

	         </cftry>

	      <cfelse>
				<cfset session.errorMessage = "API response was not in the correct format.">
				<cfset insertAPILogEntry(cgi.script_name,#serializeJSON(local.checkout.formFieldsSafe)#,session.errorMessage)>
				<cflocation addToken="no" url="/#settings.booking.dir#/booking-error.cfm">
			</cfif>


		  <cfcatch>

			    <cfif isdefined("ravenClient")>
			      <cfset ravenClient.captureMessage("Track.cfc->checkout = #cfcatch.message#")>
			    </cfif>
				<cfdump var="#cfcatch.message#"><cfabort>
			    <cfset insertAPILogEntry(cgi.script_name,#serializeJSON(local.checkout.formFieldsSafe)#,cfcatch.message)>
			    <cfset session.errorMessage = "Error: Sorry, there was an issue processing your request: #cfcatch.message#">
			    <cflocation addToken="no" url="/#settings.booking.dir#/booking-error.cfm">

		  </cfcatch>

		</cftry>

	   	<cfreturn local.checkout.reservationCode>

	</cffunction>

   <cffunction name="getCalendarData" returnType="string" hint="Used in _calendar-tab.cfm to get all the non-available dates">

   	<cfargument name="propertyid" required="true">

   	<cfset theYear = DatePart('yyyy',now())>
		<cfset theMonth = DatePart('m',now())>

		<cfquery name="nonavaildates" dataSource="#variables.settings.booking.dsn#">
			select Date_Format(thedate,'%m-%d-%Y') as mydate from track_properties_availability
			where propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.propertyid#"> and avail = '0'
			and thedate >= '#theYear#-#theMonth#-01'
		</cfquery>



		<cfset nonAvailList = ValueList(nonavaildates.mydate)>
		<cfset index = 1>
		<cfset deleteList = "">
		<cfloop list="#nonAvailList#" index="day">
			<cfif index neq 1>
				<cfset dateBefore = DateFormat(DateAdd("d",-1,day),"mm-dd-yyyy")>

				<cfif dateBefore NEQ ListGetAt(nonavaillist, index-1)>
					<cfset deleteList = listAppend(deleteList,index)>
				</cfif>
			</cfif>
			<cfset index = index + 1>
		</cfloop>

		<cfset j = 0>
		<cfloop list="#deleteList#" index="i">
			<cfset nonAvailList = listDeleteAt(nonAvailList, i-j)>
			<cfset j = j + 1>
		</cfloop>
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

		   <cfset myStartDate = DateFormat(nonavaildates['startdate'][i],'mm-dd-yyyy')>
		   <cfset myEndDate = DateFormat(nonavaildates['enddate'][i],'mm-dd-yyyy')>

		   <!--- First record, go ahead and add 1 day to the startdate and add it to the list --->
		   <cfif i eq 1>

		      <cfset myStartDate = dateAdd('d',1,myStartDate)>
		      <cfset myStartDate = DateFormat(myStartDate,'mm-dd-yyyy')>
		      <cfset nonAvailListForDatepicker = ListAppend(nonAvailListForDatepicker,myStartDate)>

		   <cfelse>

		      <cfset prevRowEndDate = nonavaildates['enddate'][i-1]> <!--- Get the previous records's end date --->
		      <cfset prevRowEndDate = DateFormat(prevRowEndDate,'mm-dd-yyyy')>

		      <cfif myStartDate neq prevRowEndDate> <!--- if the current row's start date neq previous row's end date, add 1 --->

		         <cfset myStartDate = dateAdd('d',1,myStartDate)>
		         <cfset myStartDate = DateFormat(myStartDate,'mm-dd-yyyy')>

		         <cfset nonAvailListForDatepicker = ListAppend(nonAvailListForDatepicker,myStartDate)>

		      <cfelse> <!--- the current row's start date DOES equal the previous row's end date, DO NOT ADD 1, but add to the list --->
		          <cfset nonAvailListForDatepicker = ListAppend(nonAvailListForDatepicker,myStartDate)>
		      </cfif>

		   </cfif>

		   <cfset newEndDate = DateAdd('d',-1,myEndDate)> <!--- always subtract 1 from the end date --->

		   <cfset numNights = DateDiff('d',myStartDate,newEndDate)> <!--- get the difference between start date and end date --->

		   <cfloop from="1" to="#numNights#" index="i"> <!--- add i to the start date and add to the list --->

		      <cfset newDate = DateAdd('d',i,myStartDate)>
		      <cfset newDate = DateFormat(newDate,'mm-dd-yyyy')>

		      <cfset nonAvailListForDatepicker = ListAppend(nonAvailListForDatepicker,newDate)>

		   </cfloop>

		</cfloop>

		<cfreturn nonAvailListForDatepicker>

   </cffunction>



   <cffunction name="getCalendarRates" returnType="numeric" hint="Used in _calendar-tab.cfm to display weekly price on the calendar">


   </cffunction>



   <cffunction name="getDetailRates" returnType="string" hint="Used on the property detail page to check availability and retrieve summary of fees">
	<cfargument name="propertyid" required="true">
	<cfargument name="strcheckin" required="true">
	<cfargument name="strcheckout" required="true">

   	<cfset var totalAmount = 0>
    <cfset var charges = "">
    <cfset var formFields = "">
	<cfset numNights = DateDiff('d',arguments.strcheckin,arguments.strcheckout)>

   	<cfif cgi.HTTP_USER_AGENT does not contain 'bot'>

   		<cftry>

				<cfset formFields =
				{
					"unitId": #arguments.propertyid#,
					"arrivalDate": "#DateFormat(arguments.strcheckin,'yyyy-mm-dd')#",
					"departureDate": "#DateFormat(arguments.strcheckout,'yyyy-mm-dd')#"
				}>

				<!--- <cfif cgi.remote_host eq '75.87.66.209'>
					<cfdump var="#serializeJSON(formFields)#" />
				</cfif> --->

				<cfhttp method="post" url="#settings.booking.track_api_endpoint#/api/pms/quote" username="#settings.booking.username#" password="#settings.booking.password#">
		        	<cfhttpparam type="header" name="Accept" value="*/*">
				 	<cfhttpparam type="header" name="Content-Type" value="application/hal+json">
				 	<cfhttpparam type="body" value="#serializeJSON(formFields)#">
		      	</cfhttp>

		      <!--- <cfif cgi.remote_host eq '75.87.66.209'>
		      	<cfdump var="#cfhttp.filecontent#" abort="true" />
		      </cfif> --->

		      <cfif isdefined('cfhttp.FileContent') and isJSON(cfhttp.FileContent)>
			      	<cfset json = DeserializeJSON(cfhttp.FileContent)>
					<!--- <cfif ListFind('216.99.119.254,70.40.113.45', CGI.REMOTE_ADDR)><cfdump var="#json#"></cfif> --->
						<cfif StructKeyExists(json,'detail')>
							<cfif json.detail is 'Available rate type was not found for the quote parameters.'>
								<cfset apiResponse = "The request does not comply with this property's reservation policy. To request an exception or for availability, please call us." />
							<cfelse>
								<cfset apiResponse = json.detail>
							</cfif>
						<cfelseif StructKeyExists(json,'breakdown') and StructKeyExists(json.breakdown,'charges') and StructKeyExists(json.breakdown.charges,'itemized')>
							<cfsavecontent variable="APIresponse">
							   <cfoutput>
								<!---
								<cfquery name="getMinNightStay" dataSource="#variables.settings.booking.dsn#">
									select stayMin from track_properties_availability where theDate = #createodbcdate(arguments.strcheckin)#
									and propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.propertyid#">
								</cfquery>

								<cfif getMinNightStay.recordcount gt 0>
									<cfif getMinNightStay.stayMin GT numnights>
										<p align="center">Minimum night stay: #getMinNightStay.stayMin#<br>Call for availability or flexibility!</p>

									</cfif>
								</cfif>
								--->
								<div class="panel-group property-cost-list">
			            <div class="panel panel-default">
		                <div id="collapse1" class="panel-collapse collapse">
	                    <div class="panel-body">

		                    <div class="property-cost-list-rent"><span class="pcl-fee-title">Rent</span> <span class="text-right">#DollarFormat(json.breakdown.rent)#</span></div>
												<cfset taxesAndFees = 0>
												<cfloop array="#json.breakdown.charges.itemized#" index="charge">
													<cfset chargeValue = charge.value>
													<cfset taxesAndFees = taxesAndFees + chargeValue>
												</cfloop>
												<cfset taxesAndFees = taxesAndFees + json.breakdown.taxes.total>
			                  <cfsavecontent variable="charges">
				                  <cfloop array="#json.breakdown.taxes.itemized#" index="charge">
					                  <div class='property-cost-list-taxes-fees-looped'><span class="pcl-fee-title">#charge.name#</span> - <span>#DollarFormat(charge.value)#</span></div>
						              </cfloop>
					              </cfsavecontent>
<!--- 												<div class="property-cost-list-taxes-fees" data-toggle="tooltip" data-html="true" title="#charges#"><strong>Taxes & Fees</strong> <span class="text-right">#DollarFormat(taxesAndFees)#</span> <i class="fa fa-info-circle" aria-hidden="true"></i></div> --->
						<cfif arraylen(json.breakdown.charges.itemized) GT 1>
                        <div class="property-cost-list-cleaning-fee"><span class="pcl-fee-title">Cleaning Fee</span> <span class="text-right">$#json.breakdown.charges.itemized[2].value#</span></div>
													</cfif>
                        <div class="property-cost-list-service-fees"><span class="pcl-fee-title">Service Fees</span> <span class="text-right">$#json.breakdown.charges.itemized[1].value#</span></div>
                        <div class="property-cost-list-taxes"><span class="pcl-fee-title">Taxes</span> <span class="text-right">$#json.breakdown.taxes.total#</span></div>
	                    </div><!--END panel-body-->
		                </div>
		                <div class="alert-success">
		                    <h4 class="panel-title">
		                        <a data-toggle="collapse" href="##collapse1">
									<div class="property-cost-list-total">
										<span id="costRowShowHide" class="glyphicon glyphicon-plus"></span>
										<span class="pcl-fee-title">Total</span>
										<span class="text-right">#DollarFormat(json.breakdown.total)#</span>
										<div><small class="text-white">(including Tax &amp; Fees)</small></div>
									</div>
			                      </a>
		                    </h4>
		                </div>
			            </div>
				        </div>
																<!---
								<ul class="property-cost-list">
									<li>Rent <span class="text-right">#DollarFormat(json.breakdown.rent)#</span></li>

									<cfset taxesAndFees = 0>

									<cfloop array="#json.breakdown.charges.itemized#" index="charge">

										<cfset chargeValue = charge.value>

										<cfset taxesAndFees = taxesAndFees + chargeValue>

									</cfloop>

									<cfset taxesAndFees = taxesAndFees + json.breakdown.taxes.total>

                  <cfsavecontent variable="charges"><ul><cfloop array="#json.breakdown.taxes.itemized#" index="charge"><li>#charge.name# -  #DollarFormat(charge.value)#</li></cfloop></ul></cfsavecontent>

									<li data-toggle="tooltip" data-html="true" title="#charges#" class="">Taxes & Fees <span class="text-right">#DollarFormat(taxesAndFees)#</span> <i class="fa fa-info-circle" aria-hidden="true"></i></li>
									<li><strong>Total <span class="text-right">#DollarFormat(json.breakdown.total)#</span></strong></li>
								</ul>
--->
								<a id="detailBookBtn" class="btn detail-book-btn site-color-1-bg site-color-1-lighten-bg-hover text-white" href="#settings.booking.bookingURL#/#settings.booking.dir#/book-now.cfm?propertyid=#arguments.propertyid#&strcheckin=#arguments.strcheckin#&strcheckout=#arguments.strcheckout#"><i class="fa fa-check"></i> Book Now</a>

								 <cfset numNights = DateDiff('d',arguments.strcheckin,arguments.strcheckout)>
						  		 <a id="splitCostCalc" class="btn site-color-2-bg site-color-2-lighten-bg-hover text-white" type="button" data-toggle="modal" data-target="##splitCostModal" href="/#settings.booking.dir#/_family-calculator.cfm?total=#totalAmount#&numnights=#numnights#"><i class="fa fa-calculator"></i> Split Cost Calc</a>
						  		 <input type="hidden" id="splitCalcTotalVal" name="splitCalcTotalVal" value="#json.breakdown.total#">
						  		 <input type="hidden" id="splitCalcNumNightVal" name="splitCalcNumNightVal" value="#numnights#">

								</cfoutput>
                                <cfset session.booking.quotedTotal = json.breakdown.total>

                                <!---<cfinclude template = "/vacation-rentals/_remind-book-later.cfm">--->

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
    <cfif FindNoCase("minimum night",apiresponse)>
    	<cfset insertAPILogEntry(cgi.script_name,#serializeJSON(formFields)#,apiresponse)>
		<cfquery name="getMinNightStay" dataSource="#variables.settings.booking.dsn#">
									select stayMin from track_properties_availability where theDate = #createodbcdate(arguments.strcheckin)#
									and propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.propertyid#">
								</cfquery>
		<cfset apiresponse = "Minimum night stay: #getMinNightStay.stayMin#<br>Call for availability or flexibility!">
	</cfif>
   	<cfreturn apiresponse>

   </cffunction>

   <cffunction name="getDetailRates2" returnType="any" hint="Used on the property detail page to check availability and retrieve summary of fees">
		<cfargument name="propertyid" required="true">
		<cfargument name="strcheckin" required="true">
		<cfargument name="strcheckout" required="true">
		<cfargument name="propIDList" required="false">

		<cfset returnstuct = structNew()>
		<cfset var totalAmount = 0>
		<cfset var charges = "">
		<cfset var formFields = "">
		<cfset numNights = DateDiff('d',arguments.strcheckin,arguments.strcheckout)>
		<cfset returnval = structNew()>

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
				 	<cfhttpparam type="header" name="Content-Type" value="application/hal+json">
				 	<cfhttpparam type="body" value="#serializeJSON(formFields)#">
		      	</cfhttp>

		      	<cfif isdefined('cfhttp.FileContent') and isJSON(cfhttp.FileContent)>
		      		<cfset json = DeserializeJSON(cfhttp.FileContent)>
						<cfif StructKeyExists(json,'detail')>
							<cfset apiResponse = json.detail>
						<cfelseif StructKeyExists(json,'breakdown') and StructKeyExists(json.breakdown,'charges') and StructKeyExists(json.breakdown.charges,'itemized')>
							<cfsavecontent variable="APIresponse">
							   <cfoutput>
								<!---
								<cfquery name="getMinNightStay" dataSource="#variables.settings.booking.dsn#">
									select stayMin from track_properties_availability where theDate = #createodbcdate(arguments.strcheckin)#
									and propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.propertyid#">
								</cfquery>

								<cfif getMinNightStay.recordcount gt 0>
									<cfif getMinNightStay.stayMin GT numnights>
										<p align="center">Minimum night stay: #getMinNightStay.stayMin#<br>Call for availability or flexibility!</p>

									</cfif>
								</cfif>
									--->
									<div class="panel-group property-cost-list">
										<div class="panel panel-default">
											<div id="collapse1" class="panel-collapse collapse">
												<div class="panel-body">
													<div class="property-cost-list-rent"><span class="pcl-fee-title">Rent</span> <span class="text-right">#DollarFormat(json.breakdown.rent)#</span></div>

													<cfset taxesAndFees = 0>

													<cfloop array="#json.breakdown.charges.itemized#" index="charge">
														<cfset chargeValue = charge.value>
														<cfset taxesAndFees = taxesAndFees + chargeValue>
													</cfloop>

													<cfset taxesAndFees = taxesAndFees + json.breakdown.taxes.total>

													<cfsavecontent variable="charges">
														<cfloop array="#json.breakdown.taxes.itemized#" index="charge">
															<div class='property-cost-list-taxes-fees-looped'><span class="pcl-fee-title"><cfif isDefined('charge.name')>#charge.name#</cfif></span> - <cfif isDefined('charge.value')><span>#dollarFormat(charge.value)#</span></cfif></div>
														</cfloop>
													</cfsavecontent>
													<!--- <div class="property-cost-list-taxes-fees" data-toggle="tooltip" data-html="true" title="#charges#"><strong>Taxes & Fees</strong> <span class="text-right">#DollarFormat(taxesAndFees)#</span> <i class="fa fa-info-circle" aria-hidden="true"></i></div> --->
												</div><!--END panel-body-->
											</div>
											<div>
												<h4>
													<cfset returnstruct.total = json.breakdown.total>
													<div>
														<span id="costRowShowHide" ></span> <span class="pcl-fee-title">Total</span> <span class="text-right">#DollarFormat(json.breakdown.total)#</span>
													</div>
												</h4>
											</div>
										</div>
									</div>
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

			<cfif FindNoCase("minimum night",apiresponse)>
				<cfset insertAPILogEntry(cgi.script_name,#serializeJSON(formFields)#,apiresponse)>

				<cfquery name="getMinNightStay" dataSource="#variables.settings.booking.dsn#">
				select stayMin from track_properties_availability where theDate = #createodbcdate(arguments.strcheckin)#
				and propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.propertyid#">
				</cfquery>

				<cfset apiresponse = "Minimum night stay: #getMinNightStay.stayMin#<br>Call for availability or flexibility!">
			</cfif>

			<cfset returnstruct.apiresponse = apiresponse>

			<cfreturn returnstruct>
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
                  coverImage as photo,
                  seopropertyname,
                  streetAddress as address,
                  distanceToBeach
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
                  coverImage as photo,
                  seopropertyname,
                  streetAddress as address
                  ,distanceToBeach
               from track_properties
               order by rand()
               limit 6
            </cfquery>

         </cfif>

         <cfreturn getProperties>

   </cffunction> <!--- end of getFeaturedProperties function --->


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


  <!---

   <cffunction name="getMinMaxPrice" returnType="struct" hint="Returns min/max rates for the refine search price range slider">

		<cfargument name="strcheckin" type="date" required="false">
		<cfargument name="strcheckout" type="date" required="false">

		<cfset var qryGetMinMaxPrice = ''>
		<cfset var numNights = 7>
		<cfset var rateType = 'Weekly'>
		<cfset dated = false>

		<cfif
			isdefined('arguments.strcheckin') and
			len(arguments.strcheckin) and
			isvalid('date',arguments.strcheckin) and
			isdefined('arguments.strcheckout') and
			len(arguments.strcheckout) and
			isvalid('date',arguments.strcheckout) and
			DateDiff('d',arguments.strcheckin,arguments.strcheckout) lt 7
			>

			<cfset numNights = DateDiff('d',arguments.strcheckin,arguments.strcheckout)>
			<cfset rateType = 'Nightly'>
			<cfset dated = true>
	   </cfif>

		<cfquery name="qryGetMinMaxPrice" datasource="#variables.settings.booking.dsn#">
			SELECT
				min(ratemin*#numNights#) as minPrice,
				max(ratemax*#numNights#) as maxPrice
			FROM
				track_properties_availability
			WHERE
				<cfif dated EQ false>
				thedate >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(now(),"YYYY")#-01-01">
				<cfelse>
				thedate >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(arguments.strcheckin,"YYYY-mm-dd")#">
				AND thedate <= <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(arguments.strcheckout,"YYYY-mm-dd")#">
				</cfif>

		</cfquery>

		<cfset localStruct = StructNew()>
		<cfset localStruct['minprice'] = int(qryGetMinMaxPrice.minPrice)>
		<cfset localStruct['maxprice'] = ceiling(qryGetMinMaxPrice.maxPrice)>

		<cfreturn localStruct>

   </cffunction>
		--->

<cffunction name="getMinMaxPrice" returnType="struct" hint="Returns min/max rates for the refine search price range slider">

		<cfargument name="strcheckin" type="date" required="false">
		<cfargument name="strcheckout" type="date" required="false">

		<cfset var qryGetMinMaxPrice = "">

		<cfquery name="qryGetMinMaxPrice" datasource="#variables.settings.booking.dsn#">
			SELECT
				coalesce(min(minRate),0) as minPrice,
				coalesce(max(maxRate),0) as maxPrice
			FROM
				track_properties
		</cfquery>

		<cfset localStruct['minprice'] = int(qryGetMinMaxPrice.minPrice)>
		<cfset localStruct['maxprice'] = ceiling(qryGetMinMaxPrice.maxPrice)>

		<cfreturn localStruct>

   </cffunction>



   <cffunction name="getProperty" returnType="query" hint="Returns all the basic information for a given property">

   	<cfargument name="propertyid" required="false">
   	<cfargument name="slug" required="false">

   	<cfset var qryGetProperty = "">

   	<cfquery name="qryGetProperty" dataSource="#variables.settings.booking.dsn#">
		SELECT  track_properties.name,
            track_properties.longDescription as description,
			track_properties.ShortDescription as SEOdescription,
            track_properties.seopropertyname,
            IFNULL(track_properties.seoDestinationName,'area') AS seoDestinationName,
            track_properties.id as propertyid,
            track_properties.coverImage as defaultPhoto,
            track_properties.coverImage as largePhoto,
            track_properties.lodgingTypeName as type,
            IF(track_properties.petsFriendly = 'Yes','Pets Allowed','Pets Not Allowed') as petsallowed,
            track_properties.locality as location,
            track_properties.maxoccupancy as sleeps,
            track_properties.bedrooms,
            track_properties.fullBathrooms as bathrooms,
            track_properties.halfBathrooms as halfBathrooms,
            track_properties.latitude,
            track_properties.longitude,
             track_properties.distanceToBeach,
            track_properties.locality as city,
            track_properties.region as state,
            '' as checkouttime,
            '' as checkintime,
            '' as `view`,
            track_properties.streetAddress as address,
            track_properties.rentalPolicy,
            track_properties.minRate,
            track_properties.maxRate,
            track_properties.maxPets,
            cpe.notfoundurl,
            cpe.virtualTour,
			cpe.videoLink,
            nds.id as nodeid,
            nds2.id as nodeid2,
            nds3.id as nodeid3,
            nds.typeID,
            nds.typename,
            nds2.typeid as typeid2,
            nds3.typeid as typeid3
   	FROM track_properties
			   LEFT JOIN track_nodes nds ON track_properties.nodeId = nds.id
			   LEFT JOIN track_nodes nds2 on nds2.id = nds.parentid
			   LEFT JOIN track_nodes nds3 on nds3.id = nds2.parentid
			   LEFT JOIN cms_property_enhancements cpe ON cpe.strPropID = track_properties.id
		<cfif len(arguments.propertyid)>
      WHERE track_properties.id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.propertyid#">
    <cfelseif len(arguments.slug)>
      WHERE track_properties.seopropertyname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.slug#">
    </cfif>
		</cfquery>

		<cfreturn qryGetProperty>

   </cffunction> <!--- end of getProperty --->



   <cffunction name="getPropertyAmenities" returnType="query" hint="Returns all the amenities for a given property">

   	<cfargument name="propertyid" required="true">

   	<cfset var qryGetPropertyAmenities = "">

		<cfquery name="qryGetPropertyAmenities" dataSource="#variables.settings.booking.dsn#">
			select amenityName,amenityGroupName, CASE when amenityName IN ('Dryer','Washer','TV (s) - Smart','TV (s)','Clean Coverlets - Every Reservation','Self Check-in (Keyless Lock)','2 Adult Bikes Included','4 Adult Bikes Included','Complimentary Beach Service in Season - 4 Chairs & 2 Umbrellas','Complimentary Beach Service in Season - 2 Chairs & Umbrella','Free WiFi','Pool - Community','Pool - Private Heated for a Fee','Pool - Private','Pool - Indoor/Outdoor','Pool - Indoor','1 Parking Space','2 Parking Spaces','3 Parking Spaces','4 Parking Spaces','5 Parking Spaces','6 Parking Spaces','7 Parking Spaces','8 Parking Spaces','16 Parking Spaces') then 1 else 0 END as amenityTop, 0 as ordernum
			from track_properties_amenities
			where propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.propertyid#">
			order by field(amenityname,'Dryer','Washer','TV (s) - Smart','TV (s)','Clean Cover Program - Fresh Duvets per Reservation','Self Check-in (Keyless Lock)','2 Adult Bikes Included','4 Adult Bikes Included','Complimentary Beach Service in Season - 4 Chairs & 2 Umbrellas','Complimentary Beach Service in Season - 2 Chairs & Umbrella','Free WiFi','Pool - Community','Pool - Private Heated for a Fee','Pool - Private','Pool - Indoor/Outdoor','Pool - Indoor') desc, amenityGroupName
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
		  <cfset tempReturn = DollarFormat(qryGetPropertyPriceRange.minPrice) & ' - ' & DollarFormat(qryGetPropertyPriceRange.maxPrice) & ' <small>/Night + Taxes</small>'>
		<cfelseif qryGetPropertyPriceRange.recordcount gt 0 and len(qryGetPropertyPriceRange.minPrice) and len(qryGetPropertyPriceRange.maxPrice) and qryGetPropertyPriceRange.minPrice eq qryGetPropertyPriceRange.maxPrice>
			<cfset tempReturn = DollarFormat(qryGetPropertyPriceRange.maxPrice) & ' <small>/Night + Taxes</small>'>
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

			<cfset StructInsert(reviewStruct,qryGetPropertyReviews.id,localStruct)>

		</cfloop>

		<cfreturn reviewStruct>

   </cffunction> <!--- end of getPropertyReviews function --->



   <cffunction name="getSearchResults" hint="Calls the API and returns search results based on user's chosen parameters">
   	<cfargument name="resortfilterList" required="false" type="string">
   	<cfset var qryGetSearchResults = ''>

   	<cftry>

				<cfquery name="qryGetSearchResults" dataSource="#settings.booking.dsn#">
					select
					track_properties.id AS propertyid,
					track_properties.seopropertyname,
					track_properties.distanceToBeach,
					track_properties.name,
					track_properties.latitude,
					track_properties.longitude,
					bedrooms,
					bedrooms as bedroomsRange,
					case when nds3.typename = 'Area'
					then
					nds3.name
					when ndsa.typename = 'Area'
					then
					ndsa.name
					else
					nds2.name END
					as dest,
					case when nds.typename = 'Complex/Neighborhood'

					then
					nds.name
					ELSE track_properties.name
					END
					AS resortname,
					case when nds.typename = 'Complex/Neighborhood'

					then
					0
					ELSE 1
					END
					AS isproperty,
					nds.locality AS `location`,
					track_properties.locality,
					track_properties.region,
					fullBathrooms AS bathrooms,
					fullBathrooms as bathroomsRange,
					halfbathrooms,
					nds.petsFriendly AS petsAllowed,
					lodgingTypeName AS `type`,
					minRate AS minprice,
					maxRate AS maxprice,
					coverImage AS defaultPhoto,
					nds.streetAddress AS address,
					maxoccupancy AS sleeps,
					maxoccupancy AS sleepsrange,
					cpe.notfoundurl,
					IFNULL(track_properties.seoDestinationName,'area') AS seoDestinationName,
					(SELECT AVG(rating) AS average FROM be_reviews WHERE unitcode = track_properties.id) AS avgRating,
					case when nds.typename = 'Complex/Neighborhood' then
					(SELECT original FROM track_nodes_images WHERE nodeid = nds.id LIMIT 1)
					ELSE track_properties.coverimage
					END as resortimage,
					(SELECT weddingDescription from cms_property_enhancements where strPropID = track_properties.id AND showOnWedding =1) as weddingDescription,
					(SELECT amenityname from track_properties_amenities where propertyid = track_properties.id AND amenityid = 204) as newproperty,
					case when nds.typename = 'Complex/Neighborhood'

					then
					nds.shortdescription
					ELSE track_properties.shortdescription
					END
					AS resortdescription,
					track_properties.shortdescription as description,
					nds.id as nodeid,
					nds2.id as nodeid2,
					nds3.id as nodeid3,
					nds.typeID,
					nds.typename,
					nds2.typeid as typeid2,
					nds3.typeid as typeid3

					,(select Concat(Min(bedrooms),' - ',Max(bedrooms)) from track_properties tp where tp.nodeid = track_properties.nodeId) as minmaxbedroom

					<cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate>

						<cfset numNights = DateDiff('d',session.booking.strCheckin,session.booking.strCheckout)>
						<!---
						,(SELECT sum(rateMin)

              FROM track_properties_availability
              WHERE propertyid = track_properties.id
                    AND theDate IN (
                                      <cfloop index="i" from="1" to="#numNights#">
                                        <cfset theDate = DateAdd('d',i-1,session.booking.strCheckin)>
                                        <cfset theDateFormatted = DateFormat(theDate,'yyyy-mm-dd')>
                                        "#theDateFormatted#"
                                        <cfif i lt numNights>,</cfif>
                                      </cfloop>
                                    )
						) as mapprice
						--->


						,( select rateMin from track_properties_availability where propertyid = track_properties.id and theDate = #createodbcdate(session.booking.strcheckin)# ) as mapprice

					<!---
							<cfset var ddatefix = dateAdd( 'd', -1, session.booking.strcheckout ) />

					,(
						select sum(ratemin) as rentprice
						from track_properties_availability tpa
						where propertyid = track_properties.id
						and thedate >= <cfqueryparam cfsqltype="cf_sql_date" value="#dateFormat( session.booking.strcheckin, 'yyyy-mm-dd' )#" />
						and thedate <= <cfqueryparam cfsqltype="cf_sql_date" value="#dateFormat( ddatefix, 'yyyy-mm-dd' )#" />
						order by thedate
					) as rentprice

					,(
						select sum((feeAmount/100) * rentprice)
						from track_properties_fees
						where propertyid = track_properties.id
						and feeAmount > <cfqueryparam cfsqltype="cf_sql_integer" value="0" />
						and ( <cfqueryparam cfsqltype="cf_sql_date" value="#session.booking.strcheckin#" /> between startDate and endDate or ( startDate is null and endDate is null ) )
						and feeType = <cfqueryparam cfsqltype="cf_sql_varchar" value="percent" />
					) as percent_fees

					,(
						select sum(feeAmount)
						from track_properties_fees
						where propertyid = track_properties.id
						and feeAmount > <cfqueryparam cfsqltype="cf_sql_integer" value="0" />
						and ( <cfqueryparam cfsqltype="cf_sql_date" value="#session.booking.strcheckin#" /> between startDate and endDate or ( startDate is null and endDate is null ) )
						and feeType = <cfqueryparam cfsqltype="cf_sql_varchar" value="flat" />
					) as flat_fees

					,(
						select sum(taxRate * rentprice)
						from track_properties_taxes
						where propertyid = track_properties.id
						and taxRate > <cfqueryparam cfsqltype="cf_sql_integer" value="0" />
						and ( <cfqueryparam cfsqltype="cf_sql_date" value="#session.booking.strcheckin#" /> between startDate and endDate or ( startDate is null and endDate is null ) )
					) as tax_rate

					,(
						select sum( percent_fees + flat_fees )
					) as total_fees

					,(
						select sum( rentprice + tax_rate + total_fees )
					) as mapprice

					<cfelse>

						,minRate as 'MapPrice'
					--->
					</cfif>

					from track_properties
					left join track_nodes nds ON track_properties.nodeId = nds.id and nds.typename = 'Complex/Neighborhood'
					left join track_nodes ndsa ON track_properties.nodeId = ndsa.id
					left join track_nodes nds2 on nds2.id = ndsa.parentid
					left join track_nodes nds3 on nds3.id = nds2.parentid
					left join cms_property_enhancements cpe ON cpe.strPropID = track_properties.id
					where 1=1
					and track_properties.id is not null
					and track_properties.id <> ''
					/* User is searching with dates */
					<cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate and not isDefined("request.destination")>

						<cfset formattedStrCheckin = Dateformat(session.booking.strCheckin,'yyyy-mm-dd')>
						<cfset formattedStrCheckout = Dateformat(session.booking.strCheckout,'yyyy-mm-dd')>
						<cfset numNights = DateDiff('d',session.booking.strCheckin,session.booking.strCheckout)>

						<cfloop from="1" to="#numNights#" index="i">

							/* Let's make sure that each day from arrival to departure is available */
							and track_properties.id IN
							(
								select distinct propertyid from track_properties_availability

								where

								<cfif i eq 1>
									/* This is the start date, we also need to check the allowArrival value */
									theDate = '#formattedStrCheckin#' and avail = 1 and allowArrival = 1


								<cfelse>
									<cfset loopDate = DateFormat(DateAdd('d',session.booking.strcheckin,i),'yyyy-mm-dd')>
										theDate = '#loopDate#' <cfif i neq numnights>and avail = 1</cfif>
								</cfif>

							)

						</cfloop>

						/*
						We also need to confirm the user is staying long enough
						The track_properties_availability table has a stayMin value
					   */

					   and track_properties.id IN

					   	(select distinct propertyid from track_properties_availability where #numNights# >= stayMin and theDate = '#formattedStrCheckin#')

					</cfif>




					/* This file contains other search params like occupancy,bedrooms,amenities,etc. */
					<cfinclude template="/vacation-rentals/results-search-query-common.cfm">
					<!---
					<cfif isdefined('session.booking.unitcodelist') and ListLen(session.booking.unitcodelist)>
						and nds.id in (#listQualify(session.booking.unitCodeList,"'")#)
					</cfif>
--->						<!---commented out 4/8/20 MCrouch
						order by <cf
						if isDefined("request.resortContent") or isDefined("session.booking.specialID")>rand()<cfelse>nds.name</cfif>
						--->

					<!---commented out 4/10/20 MCrouch	--->
					Group by resortname

						order by rand()
					<!---

					<cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate and session.booking.strSortBy eq 'price asc'>
						order by searchByDatePrice asc
					<cfelseif isdefined('session.booking.searchByDate') and session.booking.searchByDate and session.booking.strSortBy eq 'price desc'>
						order by searchByDatePrice desc
					<cfelse>
						order by #session.booking.strsortby#
					</cfif>
--->

				</cfquery>

				<cfset session.booking.getResultsPre  = qryGetSearchResults>

				<cfif isdefined('session.booking.rentalrate') and len(session.booking.rentalrate)>

					<cfset minSearchValue = #ListGetAt(session.booking.rentalrate,1)#>
					<cfset maxSearchValue = #ListGetAt(session.booking.rentalrate,2)#>

				   <cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate>

				   	<!--- Filter by base rent since the user selected dates --->
						<cfquery name="qryGetSearchResults" dbtype="query">
							select * from qryGetSearchResults where
							minprice*#numnights# between '#minSearchValue#' and '#maxSearchValue#'
						</cfquery>

					<cfelse>

						<!--- Filter by the price range with a non-dated search --->
						<cfquery name="qryGetSearchResults" dbtype="query">
							select * from qryGetSearchResults
							WHERE (minPrice >= '#minSearchValue#' AND minPrice <= '#maxSearchValue#') OR (maxPrice >= '#minSearchValue#' AND maxPrice <= '#maxSearchValue#')

						</cfquery>

					</cfif>

				</cfif>


				<cfset qryGetSearchresults2 = QueryNew("propertyid,seopropertyname,name,latitude,longitude,bedrooms,location,region,locality,bathrooms,petsAllowed,type,minprice,maxprice,defaultPhoto,address,sleeps,seoDestinationName,avgRating,sorter,maxbeds,maxbaths,maxsleeps,totalunits,description,weddingDescription,nodeid,nodeid2,nodeid3,typename,isproperty,newproperty,bedroomsrange,bathroomsrange,halfBathrooms,sleepsrange,mapprice,dest,resortPropList,distanceToBeach",
				"Integer,
				varchar,
				varchar,
				varchar,
				varchar,
				Integer,
				varchar,
				varchar,
				varchar,
				Integer,
				varchar,
				varchar,
				double,
				double,
				varchar,
				varchar,
				Integer,
				varchar,
				Integer,
				Integer,
				Integer,
				Integer,
				Integer,
				Integer,
				VarChar,
				VarChar,
				Integer,
				Integer,
				Integer,
				varchar,
				Integer,
				varchar,
				VarChar,
				VarChar,
				Integer,
				VarChar,
				Integer,
				VarChar,
				varchar,
				varchar")>


				<!--- <cfset qryGetSearchresults2 = QueryNew("propertyid,seopropertyname,name,latitude,longitude,bedrooms,location,region,locality,bathrooms,petsAllowed,type,minprice,maxprice,defaultPhoto,address,sleeps,seoDestinationName,avgRating,sorter,maxbeds,maxbaths,maxsleeps,totalunits,description,weddingDescription,nodeid,typename,isproperty,newproperty,bedroomsrange,bathroomsrange,halfBathrooms,sleepsrange,mapprice,dest,resortPropList")>
				 --->


				<cfset session.booking.getResultsPre = qryGetSearchResults>

				<cfoutput query="qryGetSearchResults" group="resortname">
					<cftry>

					<cfset propList2="a">
					<cfoutput><cfset proplist2 = listappend(proplist2,propertyid)></cfoutput>

				<!--- 		<cfquery dbtype="query" name="getPropInfo">
							select min(bedrooms) as minbedrooms, max(bedrooms) as maxbedrooms, min(bathrooms) as minbathrooms, max(bathrooms) as maxbathrooms,
							min(minprice) as minprice, max(maxprice) as maxprice,
							min(sleeps) as minsleeps, max(sleeps) as maxsleeps
							from qryGetSearchResults
							where address = '#address#'
						</cfquery>

						<cfquery dbtype="query" name="getUnits">
							select *
							from qryGetSearchResults
							where address = '#address#'
						</cfquery> --->
						<cfquery dbtype="query" name="getPropInfo">
							select min(bedrooms) as minbedrooms, max(bedrooms) as maxbedrooms, min(bathrooms) as minbathrooms, max(bathrooms) as maxbathrooms,
							min(minprice) as minprice, max(maxprice) as maxprice,
							min(sleeps) as minsleeps, max(sleeps) as maxsleeps
							from qryGetSearchResults
							where resortname = '#resortname#'
						</cfquery>

						<cfquery dbtype="query" name="getUnits">
							select *
							from qryGetSearchResults
							where resortname = '#resortname#'
						</cfquery>

					<cfset queryAddRow(qryGetSearchresults2)>
					<cfset Resname = reReplace(resortname, "[[:space:]]", "", "ALL") />
					<cfset Resname = replace(resname,'(','','All')>
					<cfset Resname = replace(resname,')','','All')>
					<cfset Resname = replace(resname,'&','','All')>
					<cfset Resname = replace(resname,"'","","ALL")>
					<cfif typename EQ 'Complex/Neighborhood'>
						<cfset slug = Resname />
					<cfelse>
						<cfset slug = seopropertyname>
					</cfif>

					<cfset QuerySetCell(qryGetSearchresults2, "propertyid", propertyid )>
					<cfset QuerySetCell(qryGetSearchresults2, "dest", dest )>
					<cfset QuerySetCell(qryGetSearchresults2, "seopropertyname", slug  )>
					<cfset QuerySetCell(qryGetSearchresults2, "seodestinationname", seodestinationname  )>
					<cfset QuerySetCell(qryGetSearchresults2, "name", resortname  )>
					<cfset QuerySetCell(qryGetSearchresults2, "isproperty", isproperty  )>
					<cfset QuerySetCell(qryGetSearchresults2, "newproperty", newproperty  )>
					<cfset QuerySetCell(qryGetSearchresults2, "defaultphoto", resortimage  )>
					<cfset QuerySetCell(qryGetSearchresults2, "latitude", latitude  )>
					<cfset QuerySetCell(qryGetSearchresults2, "longitude", longitude  )>
					<cfset QuerySetCell(qryGetSearchresults2, "location", location  )>
					<cfset QuerySetCell(qryGetSearchresults2, "region", region  )>
					<cfset QuerySetCell(qryGetSearchresults2, "locality", locality  )>
					<cfset QuerySetCell(qryGetSearchresults2, "totalunits", getunits.recordcount  )>

					<cfif isdefined('getpropinfo.minprice') and LEN(getpropinfo.minprice) and getpropinfo.minprice gt 0>
						<cfset QuerySetCell(qryGetSearchresults2, "minprice", getpropinfo.minprice )>
					<cfelse>
						<cfset QuerySetCell(qryGetSearchresults2, "minprice", "0" )>
					</cfif>

					<cfset QuerySetCell(qryGetSearchresults2, "maxprice", getpropinfo.maxprice )>

					<cfset QuerySetCell(qryGetSearchresults2, "description", resortdescription )>
					<cfset QuerySetCell(qryGetSearchresults2, "weddingDescription", weddingDescription )>
					<cfset QuerySetCell(qryGetSearchresults2, "nodeid", nodeid )>
					<cfset QuerySetCell(qryGetSearchresults2, "nodeid2", nodeid2 )>
					<cfset QuerySetCell(qryGetSearchresults2, "nodeid3", nodeid3 )>
					<cfset QuerySetCell(qryGetSearchresults2, "typename", typename )>
					<cfset QuerySetCell(qryGetSearchresults2, "sorter", RandRange(1,10000) )>

					<cfif getPropInfo.minbedrooms EQ getPropInfo.maxbedrooms>
						<cfset QuerySetCell(qryGetSearchresults2, "bedrooms", getPropInfo.minbedrooms )>
					<cfelse>
						<cfif isdefined('session.booking.strSortBy') and findnocase("asc",session.booking.strSortBy)>
						<cfset QuerySetCell(qryGetSearchresults2, "bedrooms", getPropInfo.minbedrooms)>
						<cfelse>
						<cfset QuerySetCell(qryGetSearchresults2, "bedrooms", getPropInfo.maxbedrooms)>
						</cfif>
					</cfif>


						<cfset local.minbeds = listFirst(minmaxbedroom,' - ')>
						<cfset local.maxbeds = listLast(minmaxbedroom,' - ')>

						<cfif local.minbeds eq local.maxbeds OR typename NEQ 'Complex/Neighborhood'>
							<cfset QuerySetCell(qryGetSearchresults2, "bedroomsrange", "abc#local.minbeds#" )>
						<cfelse>
							<cfset QuerySetCell(qryGetSearchresults2, "bedroomsrange", "abc#minmaxbedroom#" )>
						</cfif>


			<!--- 			<cfif getPropInfo.minbedrooms EQ getPropInfo.maxbedrooms OR typename NEQ 'Complex/Neighborhood'>
							<cfset QuerySetCell(qryGetSearchresults2, "bedroomsrange", "abc#getPropInfo.minbedrooms#" )>
						<cfelse>
							<cfset QuerySetCell(qryGetSearchresults2, "bedroomsrange", "abc#getPropInfo.minbedrooms# - #getPropInfo.maxbedrooms#" )>
						</cfif>
 --->


					<cfif getPropInfo.minbathrooms EQ getPropInfo.maxbathrooms>
						<cfset QuerySetCell(qryGetSearchresults2, "bathrooms", "#getPropInfo.minbathrooms#" )>
					<cfelse>
						<cfif findnocase("asc",session.booking.strSortBy)>
							<cfset QuerySetCell(qryGetSearchresults2, "bathrooms", "#getPropInfo.minbathrooms#" )>
						<cfelse>
							<cfset QuerySetCell(qryGetSearchresults2, "bathrooms", "#getPropInfo.maxbathrooms#" )>
						</cfif>
					</cfif>

					<cfif getPropInfo.minbathrooms EQ getPropInfo.maxbathrooms>
						<cfset QuerySetCell(qryGetSearchresults2, "bathroomsrange", "abc#getPropInfo.minbathrooms#" )>
					<cfelse>
						<cfset QuerySetCell(qryGetSearchresults2, "bathroomsrange", "abc#getPropInfo.minbathrooms# - #getPropInfo.maxbathrooms#" )>
					</cfif>

					<cfif getPropInfo.minsleeps EQ getPropInfo.maxsleeps>
						<cfset QuerySetCell(qryGetSearchresults2, "sleeps", "#getPropInfo.minsleeps#" )>
					<cfelse>
						<cfif findnocase("asc",session.booking.strSortBy)>
							<cfset QuerySetCell(qryGetSearchresults2, "sleeps", "#getPropInfo.minsleeps#" )>
						<cfelse>
							<cfset QuerySetCell(qryGetSearchresults2, "sleeps", "#getPropInfo.maxsleeps#" )>
						</cfif>
					</cfif>

					<cfif getPropInfo.minsleeps EQ getPropInfo.maxsleeps>
						<cfset QuerySetCell(qryGetSearchresults2, "sleepsrange", "abc#getPropInfo.minsleeps#" )>
					<cfelse>
						<cfset QuerySetCell(qryGetSearchresults2, "sleepsrange", "abc#getPropInfo.minsleeps# - #getPropInfo.maxsleeps#" )>
					</cfif>

					<cfset QuerySetCell(qryGetSearchresults2, "halfBathrooms", "#halfBathrooms#" )>
					<cfset QuerySetCell(qryGetSearchresults2, "maxsleeps", "#getPropInfo.maxsleeps#" )>
					<cfset QuerySetCell(qryGetSearchresults2, "maxbeds", "#getPropInfo.maxbedrooms#" )>
					<cfset QuerySetCell(qryGetSearchresults2, "maxbaths", "#getPropInfo.maxbathrooms#" )>

					<cfif isdefined('mapprice') and LEN(mapprice)>
						<cfset QuerySetCell(qryGetSearchresults2, "mapprice", "#mapprice#" )>
					<cfelse>
						<cfset QuerySetCell(qryGetSearchresults2, "mapprice", "0" )>
					</cfif>

					<cfset QuerySetCell(qryGetSearchresults2, "resortPropList", propList2 )>

					<cfset QuerySetCell(qryGetSearchresults2, "petsAllowed", petsAllowed)>
					<cfset QuerySetCell(qryGetSearchresults2, "type", typename)>
					<cfset QuerySetCell(qryGetSearchresults2, "address", address)>
					<cfset QuerySetCell(qryGetSearchresults2, "avgRating", avgRating)>
					<cfset QuerySetCell(qryGetSearchresults2, "distanceToBeach", distanceToBeach)>


					<cfcatch><cfif ListFind('216.99.119.254,209.188.44.35', CGI.REMOTE_ADDR)><!--- <cfdump var="#qryGetSearchresults#"> ---><cfdump var="#cfcatch#" abort="true"></cfif></cfcatch>
				</cftry>
				</cfoutput>

				<cfif isDefined("session.booking.sleeps") AND session.booking.sleeps GT 1>
					<cfset session.booking.strSortBy = "sleeps asc">
				</cfif>

				<cfset session.booking.getResultsPost = qryGetSearchresults2>

<!--- 		<cfif ListFind('216.99.119.254', CGI.REMOTE_ADDR)><cfdump var="#qryGetSearchresults2.getMetaData().getExtendedMetaData().sql#" abort="true"></cfif>
 --->

				<cfquery name="qryGetSearchresults2Sorted" dbtype="query">
					select * from qryGetSearchresults2
					<cfif isdefined('session.booking.strSortBy') and LEN(session.booking.strSortBy)>
						<cfif session.booking.strSortBy EQ "rand()">
						<!---	order by sorter IS NOT NULL--->
						<cfelseif session.booking.strSortBy EQ "bedrooms asc">
							order by bedrooms asc
						<cfelseif session.booking.strSortBy EQ "bedrooms desc">
							order by maxbeds desc
						<cfelseif session.booking.strSortBy EQ "name">
							order by name asc
						<cfelseif session.booking.strSortBy EQ "fullbathrooms desc">
							order by maxbaths desc
						<cfelseif session.booking.strSortBy EQ "fullbathrooms asc">
							order by bathrooms asc
						<cfelseif session.booking.strSortBy EQ "sleeps desc">
							order by maxsleeps desc
						<cfelseif session.booking.strSortBy EQ "sleeps asc">
							order by sleeps asc
						 <cfelseif session.booking.strSortBy EQ "price asc">
							order by mapprice asc
						<cfelseif session.booking.strSortBy EQ "price desc">
							order by mapprice desc
						</cfif>
					</cfif>
				</cfquery>


				<!--- <cfdump var="#qryGetSearchResults.getMetaData().getExtendedMetaData().sql#"> --->
				<!--- <cfabort> --->

				<cfif isDefined("request.resortContent") or isDefined("session.booking.specialID")>
					<cfset cookie.numResults = qryGetSearchResults.recordcount>
					<cfset session.booking.getResults = qryGetSearchResults>
				    <cfset session.booking.UnitCodeList = valueList(qryGetSearchResults.propertyid)>
				<cfelseif isdefined('qryGetSearchresults2Sorted')>
					<cfset cookie.numResults = qryGetSearchresults2Sorted.recordcount>
					<cfset session.booking.getResults = qryGetSearchresults2Sorted>
			   		<cfset session.booking.UnitCodeList = valueList(qryGetSearchresults2Sorted.propertyid)>
			   	<cfelse>
					<cfset cookie.numResults = qryGetSearchResults.recordcount>
					<cfset session.booking.getResults = qryGetSearchResults>
				    <cfset session.booking.UnitCodeList = valueList(qryGetSearchResults.propertyid)>
				</cfif>


				<!--- If we get a search query recordcount of zero, we want to track it for debugging --->
				<!--- Clean session and serialize to store in the DB --->
				<cfif session.booking.getResults.recordcount eq 0>
					<cftry>
						<cfset var cleanSessionForLogging = "">
						<cfset var cleanCGI = serializeJson(cgi)>
						<cfset var cleanForm = "">

						<!--- Remove the queries from the session to make it smaller --->
						<cfif structKeyExists(session, "booking")>
							<cfset cleanSessionForLogging = Duplicate(session.booking)>
							<cfif StructKeyExists(session.booking,"GETRESULTS")>
								<cfset tempClean1 = StructDelete(cleanSessionForLogging, "GETRESULTS")>
							</cfif>
							<cfif StructKeyExists(session.booking,"GETRESULTSPOST")>
								<cfset tempClean2 = StructDelete(cleanSessionForLogging, "GETRESULTSPOST")>
							</cfif>
							<cfif StructKeyExists(session.booking,"GETRESULTSPRE")>
								<cfset tempClean3 = StructDelete(cleanSessionForLogging, "GETRESULTSPRE")>
							</cfif>
							<cfset cleanSessionForLogging = serializeJson(cleanSessionForLogging)>
						</cfif>

						<cfif isdefined('form')>
							<cfset cleanForm = serializeJson(form)>
						</cfif>

						<cfquery datasource="#settings.dsn#">
							Insert Into searchquery_logs(qryRecordCount,searchType,dataSession,dataCGI,dataForm,remoteIP)
							Values(<cfqueryparam value="0" cfsqltype="integer">
								   ,<cfqueryparam value="SRP" cfsqltype="varchar">
								   ,<cfqueryparam value="#cleanSessionForLogging#" cfsqltype="longvarchar">
								   ,<cfqueryparam value="#cleanCGI#" cfsqltype="longvarchar">
								   ,<cfqueryparam value="#cleanForm#" cfsqltype="longvarchar">
								   ,<cfqueryparam value="#cgi.REMOTE_ADDR#" cfsqltype="longvarchar">
								   )
						</cfquery>
						<cfcatch><cfif ListFind('216.99.119.254,209.188.44.35', CGI.REMOTE_ADDR)><cfdump var="#cfcatch#"></cfif></cfcatch>
					</cftry>
				</cfif>

		<cfcatch>
            <cfif isDefined('ravenClient')>
                <cfset ravenClient.captureException(cfcatch)>
            </cfif>
		</cfcatch>
		</cftry>

   </cffunction>


   <cffunction name="getSearchResultsResorts" hint="Calls the API and returns search results based on user's chosen parameters">

   	<cfset var qryGetSearchResults = ''>

   	<cftry>

				<cfquery name="qryGetSearchResults" dataSource="#settings.booking.dsn#">
					select
					track_properties.id AS propertyid,
					track_properties.seopropertyname,
					track_properties.name,
					track_properties.latitude,
					track_properties.longitude,
					track_properties.distanceToBeach,
					bedrooms,
					bedrooms as bedroomsRange,
					case when nds3.typename = 'Area'
					then
					nds3.name
					when ndsa.typename = 'Area'
					then
					ndsa.name
					else
					nds2.name END
					as dest,
					case when nds.typename = 'Complex/Neighborhood'

					then
					nds.name
					ELSE track_properties.name
					END
					AS resortname,
					case when nds.typename = 'Complex/Neighborhood'

					then
					0
					ELSE 1
					END
					AS isproperty,
					nds.locality AS `location`,
					track_properties.locality,
					track_properties.region,
					fullBathrooms AS bathrooms,
					fullBathrooms as bathroomsRange,
					halfbathrooms,
					nds.petsFriendly AS petsAllowed,
					lodgingTypeName AS `type`,
					minRate AS minprice,
					maxRate AS maxprice,
					coverImage AS defaultPhoto,
					nds.streetAddress AS address,
					maxoccupancy AS sleeps,
					maxoccupancy AS sleepsrange,
					cpe.notfoundurl,
					IFNULL(track_properties.seoDestinationName,'area') AS seoDestinationName,
					(SELECT AVG(rating) AS average FROM be_reviews WHERE unitcode = track_properties.id) AS avgRating,
					case when nds.typename = 'Complex/Neighborhood' then
					(SELECT original FROM track_nodes_images WHERE nodeid = nds.id LIMIT 1)
					ELSE track_properties.coverimage
					END as resortimage,
					(SELECT weddingDescription from cms_property_enhancements where strPropID = track_properties.id AND showOnWedding =1) as weddingDescription,
					(SELECT amenityname from track_properties_amenities where propertyid = track_properties.id AND amenityid = 204) as newproperty,
					case when nds.typename = 'Complex/Neighborhood'

					then
					nds.shortdescription
					ELSE track_properties.shortdescription
					END
					AS resortdescription,
					track_properties.shortdescription as description,
					nds.id as nodeid,
					nds2.id as nodeid2,
					nds3.id as nodeid3,
					nds.typeID,
					nds.typename,
					nds2.typeid as typeid2,
					nds3.typeid as typeid3

					<cfif isdefined('session.booking.resort.searchByDate') and session.booking.resort.searchByDate>

						<cfset numNights = DateDiff('d',session.booking.resort.strCheckin,session.booking.resort.strCheckout)>

						,( select rateMin from track_properties_availability where propertyid = track_properties.id and theDate = #createodbcdate(session.booking.resort.strcheckin)# ) as mapprice

					</cfif>

					from track_properties
					left join track_nodes nds ON track_properties.nodeId = nds.id and nds.typename = 'Complex/Neighborhood'
					left join track_nodes ndsa ON track_properties.nodeId = ndsa.id
					left join track_nodes nds2 on nds2.id = ndsa.parentid
					left join track_nodes nds3 on nds3.id = nds2.parentid
					left join cms_property_enhancements cpe ON cpe.strPropID = track_properties.id
					where 1=1
					and track_properties.id is not null
					and track_properties.id <> ''
					/* User is searching with dates */
					<cfif isdefined('session.booking.resort.searchByDate') and session.booking.resort.searchByDate and not isDefined("request.destination")>

						<cfset formattedStrCheckin = Dateformat(session.booking.resort.strCheckin,'yyyy-mm-dd')>
						<cfset formattedStrCheckout = Dateformat(session.booking.resort.strCheckout,'yyyy-mm-dd')>
						<cfset numNights = DateDiff('d',session.booking.resort.strCheckin,session.booking.resort.strCheckout)>

						<cfloop from="1" to="#numNights#" index="i">

							/* Let's make sure that each day from arrival to departure is available */
							and track_properties.id IN
							(
								select distinct propertyid from track_properties_availability

								where

								<cfif i eq 1>
									/* This is the start date, we also need to check the allowArrival value */
									theDate = '#formattedStrCheckin#' and avail = 1 and allowArrival = 1


								<cfelse>
									<cfset loopDate = DateFormat(DateAdd('d',session.booking.resort.strcheckin,i),'yyyy-mm-dd')>
										theDate = '#loopDate#' <cfif i neq numnights>and avail = 1</cfif>
								</cfif>

							)

						</cfloop>

						/*
						We also need to confirm the user is staying long enough
						The track_properties_availability table has a stayMin value
					   */

					   and track_properties.id IN

					   	(select distinct propertyid from track_properties_availability where #numNights# >= stayMin and theDate = '#formattedStrCheckin#')

					</cfif>



					/* This file contains other search params like occupancy,bedrooms,amenities,etc. */
					<cfinclude template="/vacation-rentals/results-search-query-common-resort.cfm">

						order by <cfif isDefined("request.resortContent") or isDefined("session.booking.resort.specialID")>rand()<cfelse>nds.name</cfif>

				</cfquery>



				<cfif isdefined('session.booking.resort.rentalrate') and len(session.booking.resort.rentalrate)>

					<cfset minSearchValue = #ListGetAt(session.booking.resort.rentalrate,1)#>
					<cfset maxSearchValue = #ListGetAt(session.booking.resort.rentalrate,2)#>

				   <cfif isdefined('session.booking.resort.searchByDate') and session.booking.resort.searchByDate>

				   	<!--- Filter by base rent since the user selected dates --->
						<cfquery name="qryGetSearchResults" dbtype="query">
							select * from qryGetSearchResults where
							minprice*#numnights# between '#minSearchValue#' and '#maxSearchValue#'
						</cfquery>

					<cfelse>

						<!--- Filter by the price range with a non-dated search --->
						<cfquery name="qryGetSearchResults" dbtype="query">
							select * from qryGetSearchResults
							WHERE (minPrice >= '#minSearchValue#' AND minPrice <= '#maxSearchValue#') OR (maxPrice >= '#minSearchValue#' AND maxPrice <= '#maxSearchValue#')

						</cfquery>

					</cfif>

				</cfif>


				<cfset qryGetSearchresults2 = QueryNew("propertyid,seopropertyname,name,latitude,longitude,bedrooms,location,region,locality,bathrooms,petsAllowed,type,minprice,maxprice,defaultPhoto,address,sleeps,seoDestinationName,avgRating,sorter,maxbeds,maxbaths,maxsleeps,totalunits,description,weddingDescription,nodeid,typename,isproperty,newproperty,bedroomsrange,bathroomsrange,halfBathrooms,sleepsrange,mapprice,dest,resortPropList,distanceToBeach",
				"Integer,
				varchar,
				varchar,
				varchar,
				varchar,
				Integer,
				varchar,
				varchar,
				varchar,
				Integer,
				varchar,
				varchar,
				double,
				double,
				varchar,
				varchar,
				Integer,
				varchar,
				Integer,
				Integer,
				Integer,
				Integer,
				Integer,
				Integer,
				VarChar,
				VarChar,
				Integer,
				varchar,
				Integer,
				varchar,
				VarChar,
				VarChar,
				Integer,
				VarChar,
				Integer,
				VarChar,
				varchar,
				varchar")>



				<!--- <cfset session.booking.resort.getResultsPre = qryGetSearchResults> --->

				<cfoutput query="qryGetSearchResults" group="resortname">
					<cftry>

					<cfset propList2="a">
					<cfoutput><cfset proplist2 = listappend(proplist2,propertyid)></cfoutput>
					<cfquery dbtype="query" name="getPropInfo">
						select min(bedrooms) as minbedrooms, max(bedrooms) as maxbedrooms, min(bathrooms) as minbathrooms, max(bathrooms) as maxbathrooms,
						min(minprice) as minprice, max(maxprice) as maxprice,
						min(sleeps) as minsleeps, max(sleeps) as maxsleeps
						from qryGetSearchResults
						where resortname = '#resortname#'
					</cfquery>

					<cfquery dbtype="query" name="getUnits">
						select *
						from qryGetSearchResults
						where resortname = '#resortname#'
					</cfquery>

					<cfset queryAddRow(qryGetSearchresults2)>
					<cfset Resname = reReplace(resortname, "[[:space:]]", "", "ALL") />
					<cfset Resname = replace(resname,'(','','All')>
					<cfset Resname = replace(resname,')','','All')>
					<cfset Resname = replace(resname,'&','','All')>
					<cfset Resname = replace(resname,"'","","ALL")>
					<cfif typename EQ 'Complex/Neighborhood'>
						<cfset slug = Resname />
					<cfelse>
						<cfset slug = seopropertyname>
					</cfif>

					<cfset QuerySetCell(qryGetSearchresults2, "propertyid", propertyid )>
					<cfset QuerySetCell(qryGetSearchresults2, "dest", dest )>
					<cfset QuerySetCell(qryGetSearchresults2, "seopropertyname", slug  )>
					<cfset QuerySetCell(qryGetSearchresults2, "seodestinationname", seodestinationname  )>
					<cfset QuerySetCell(qryGetSearchresults2, "name", resortname  )>
					<cfset QuerySetCell(qryGetSearchresults2, "isproperty", isproperty  )>
					<cfset QuerySetCell(qryGetSearchresults2, "newproperty", newproperty  )>
					<cfset QuerySetCell(qryGetSearchresults2, "defaultphoto", resortimage  )>
					<cfset QuerySetCell(qryGetSearchresults2, "latitude", latitude  )>
					<cfset QuerySetCell(qryGetSearchresults2, "longitude", longitude  )>
					<cfset QuerySetCell(qryGetSearchresults2, "location", location  )>
					<cfset QuerySetCell(qryGetSearchresults2, "region", region  )>
					<cfset QuerySetCell(qryGetSearchresults2, "locality", locality  )>
					<cfset QuerySetCell(qryGetSearchresults2, "totalunits", getunits.recordcount  )>

					<cfif isdefined('getpropinfo.minprice') and LEN(getpropinfo.minprice)>
						<cfset QuerySetCell(qryGetSearchresults2, "minprice", getpropinfo.minprice )>
					<cfelse>
						<cfset QuerySetCell(qryGetSearchresults2, "minprice", "0" )>
					</cfif>

					<cfset QuerySetCell(qryGetSearchresults2, "maxprice", getpropinfo.maxprice )>

					<cfset QuerySetCell(qryGetSearchresults2, "description", resortdescription )>
					<cfset QuerySetCell(qryGetSearchresults2, "weddingDescription", weddingDescription )>
					<cfset QuerySetCell(qryGetSearchresults2, "nodeid", nodeid )>
					<cfset QuerySetCell(qryGetSearchresults2, "typename", typename )>
					<cfset QuerySetCell(qryGetSearchresults2, "sorter", RandRange(1,10000) )>

					<cfif getPropInfo.minbedrooms EQ getPropInfo.maxbedrooms>
						<cfset QuerySetCell(qryGetSearchresults2, "bedrooms", "#getPropInfo.minbedrooms#" )>
					<cfelse>
						<cfif findnocase("asc",session.booking.resort.strSortBy)>
						<cfset QuerySetCell(qryGetSearchresults2, "bedrooms", "#getPropInfo.minbedrooms#" )>
						<cfelse>
						<cfset QuerySetCell(qryGetSearchresults2, "bedrooms", "#getPropInfo.maxbedrooms#" )>
						</cfif>
					</cfif>

					<cfif getPropInfo.minbedrooms EQ getPropInfo.maxbedrooms>
						<cfset QuerySetCell(qryGetSearchresults2, "bedroomsrange", "abc#getPropInfo.minbedrooms#" )>
					<cfelse>
						<cfset QuerySetCell(qryGetSearchresults2, "bedroomsrange", "abc#getPropInfo.minbedrooms# - #getPropInfo.maxbedrooms#" )>
					</cfif>

					<cfif getPropInfo.minbathrooms EQ getPropInfo.maxbathrooms>
						<cfset QuerySetCell(qryGetSearchresults2, "bathrooms", "#getPropInfo.minbathrooms#" )>
					<cfelse>
						<cfif findnocase("asc",session.booking.resort.strSortBy)>
							<cfset QuerySetCell(qryGetSearchresults2, "bathrooms", "#getPropInfo.minbathrooms#" )>
						<cfelse>
							<cfset QuerySetCell(qryGetSearchresults2, "bathrooms", "#getPropInfo.maxbathrooms#" )>
						</cfif>
					</cfif>

					<cfif getPropInfo.minbathrooms EQ getPropInfo.maxbathrooms>
						<cfset QuerySetCell(qryGetSearchresults2, "bathroomsrange", "abc#getPropInfo.minbathrooms#" )>
					<cfelse>
						<cfset QuerySetCell(qryGetSearchresults2, "bathroomsrange", "abc#getPropInfo.minbathrooms# - #getPropInfo.maxbathrooms#" )>
					</cfif>

					<cfif getPropInfo.minsleeps EQ getPropInfo.maxsleeps>
						<cfset QuerySetCell(qryGetSearchresults2, "sleeps", "#getPropInfo.minsleeps#" )>
					<cfelse>
						<cfif findnocase("asc",session.booking.resort.strSortBy)>
							<cfset QuerySetCell(qryGetSearchresults2, "sleeps", "#getPropInfo.minsleeps#" )>
						<cfelse>
							<cfset QuerySetCell(qryGetSearchresults2, "sleeps", "#getPropInfo.maxsleeps#" )>
						</cfif>
					</cfif>

					<cfif getPropInfo.minsleeps EQ getPropInfo.maxsleeps>
						<cfset QuerySetCell(qryGetSearchresults2, "sleepsrange", "abc#getPropInfo.minsleeps#" )>
					<cfelse>
						<cfset QuerySetCell(qryGetSearchresults2, "sleepsrange", "abc#getPropInfo.minsleeps# - #getPropInfo.maxsleeps#" )>
					</cfif>

					<cfset QuerySetCell(qryGetSearchresults2, "halfBathrooms", "#halfBathrooms#" )>
					<cfset QuerySetCell(qryGetSearchresults2, "maxsleeps", "#getPropInfo.maxsleeps#" )>
					<cfset QuerySetCell(qryGetSearchresults2, "maxbeds", "#getPropInfo.maxbedrooms#" )>
					<cfset QuerySetCell(qryGetSearchresults2, "maxbaths", "#getPropInfo.maxbathrooms#" )>

					<cfif isdefined('mapprice') and LEN(mapprice)>
						<cfset QuerySetCell(qryGetSearchresults2, "mapprice", "#mapprice#" )>
					<cfelse>
						<cfset QuerySetCell(qryGetSearchresults2, "mapprice", "0" )>
					</cfif>

					<cfset QuerySetCell(qryGetSearchresults2, "resortPropList", propList2 )>

					<cfset QuerySetCell(qryGetSearchresults2, "petsAllowed", petsAllowed)>
					<cfset QuerySetCell(qryGetSearchresults2, "type", typename)>
					<cfset QuerySetCell(qryGetSearchresults2, "address", address)>
					<cfset QuerySetCell(qryGetSearchresults2, "avgRating", avgRating)>
					<cfset QuerySetCell(qryGetSearchresults2, "distanceToBeach", distanceToBeach)>

					<cfcatch><cfif ListFind('216.99.119.254,209.188.44.35', CGI.REMOTE_ADDR)><!--- <cfdump var="#qryGetSearchresults#"> ---><cfdump var="#cfcatch#" abort="true"></cfif></cfcatch>
				</cftry>
				</cfoutput>

				<cfif isDefined("session.booking.resort.sleeps") AND session.booking.resort.sleeps GT 1>
					<cfset session.booking.resort.strSortBy = "sleeps asc">
				</cfif>

				<!--- <cfset session.booking.resort.getResultsPost = qryGetSearchresults2> --->

<!--- 		<cfif ListFind('216.99.119.254', CGI.REMOTE_ADDR)><cfdump var="#qryGetSearchresults2.getMetaData().getExtendedMetaData().sql#" abort="true"></cfif>
 --->

				<cfquery name="qryGetSearchresults2Sorted" dbtype="query">
					select * from qryGetSearchresults2
					<cfif isdefined('session.booking.resort.strSortBy') and LEN(session.booking.resort.strSortBy)>
						<cfif session.booking.resort.strSortBy EQ "rand()">
						<!---	order by sorter IS NOT NULL--->
						<cfelseif session.booking.resort.strSortBy EQ "bedrooms asc">
							order by bedrooms asc
						<cfelseif session.booking.resort.strSortBy EQ "bedrooms desc">
							order by maxbeds desc
						<cfelseif session.booking.resort.strSortBy EQ "name">
							order by name asc
						<cfelseif session.booking.resort.strSortBy EQ "fullbathrooms desc">
							order by maxbaths desc
						<cfelseif session.booking.resort.strSortBy EQ "fullbathrooms asc">
							order by bathrooms asc
						<cfelseif session.booking.resort.strSortBy EQ "sleeps desc">
							order by maxsleeps desc
						<cfelseif session.booking.resort.strSortBy EQ "sleeps asc">
							order by sleeps asc
						 <cfelseif session.booking.resort.strSortBy EQ "price asc">
							order by mapprice asc
						<cfelseif session.booking.resort.strSortBy EQ "price desc">
							order by mapprice desc
						</cfif>
					</cfif>
				</cfquery>


				<cfif isDefined("request.resortContent") or isDefined("session.booking.specialID")>
					<cfset cookie.numResortResults = qryGetSearchResults.recordcount>
					<cfset session.booking.resort.getResults = qryGetSearchResults>
				    <cfset session.booking.resort.UnitCodeList = valueList(qryGetSearchResults.propertyid)>
				<cfelseif isdefined('qryGetSearchresults2Sorted')>
					<cfset cookie.numResortResults = qryGetSearchresults2Sorted.recordcount>
					<cfset session.booking.resort.getResults = qryGetSearchresults2Sorted>
			   		<cfset session.booking.resort.UnitCodeList = valueList(qryGetSearchresults2Sorted.propertyid)>
			   	<cfelse>
					<cfset cookie.numResortResults = qryGetSearchResults.recordcount>
					<cfset session.booking.resort.getResults = qryGetSearchResults>
				    <cfset session.booking.resort.UnitCodeList = valueList(qryGetSearchResults.propertyid)>
				</cfif>


				<!--- If we get a search query recordcount of zero, we want to track it for debugging --->
				<!--- Clean session and serialize to store in the DB --->
				<cfif session.booking.resort.getResults.recordcount eq 0>
					<cftry>
						<cfset var cleanSessionForLogging = "">
						<cfset var cleanCGI = serializeJson(cgi)>
						<cfset var cleanForm = "">

						<!--- Remove the queries from the session to make it smaller --->
						<cfif structKeyExists(session.booking, "resort")>
							<cfset cleanSessionForLogging = Duplicate(session.booking.resort)>
							<cfif StructKeyExists(session.booking.resort,"GETRESULTS")>
								<cfset tempClean1 = StructDelete(cleanSessionForLogging, "GETRESULTS")>
							</cfif>
							<cfif StructKeyExists(session.booking.resort,"GETRESULTSPOST")>
								<cfset tempClean2 = StructDelete(cleanSessionForLogging, "GETRESULTSPOST")>
							</cfif>
							<cfif StructKeyExists(session.booking.resort,"GETRESULTSPRE")>
								<cfset tempClean3 = StructDelete(cleanSessionForLogging, "GETRESULTSPRE")>
							</cfif>
							<cfset cleanSessionForLogging = serializeJson(cleanSessionForLogging)>
						</cfif>

						<cfif isdefined('form')>
							<cfset cleanForm = serializeJson(form)>
						</cfif>

						<cfquery datasource="#settings.dsn#">
							Insert Into searchquery_logs(qryRecordCount,searchType,dataSession,dataCGI,dataForm,remoteIP)
							Values(<cfqueryparam value="0" cfsqltype="integer">
								   ,<cfqueryparam value="Resort" cfsqltype="varchar">
								   ,<cfqueryparam value="#cleanSessionForLogging#" cfsqltype="longvarchar">
								   ,<cfqueryparam value="#cleanCGI#" cfsqltype="longvarchar">
								   ,<cfqueryparam value="#cleanForm#" cfsqltype="longvarchar">
								   ,<cfqueryparam value="#cgi.REMOTE_ADDR#" cfsqltype="longvarchar">
								   )
						</cfquery>
						<cfcatch><cfif ListFind('216.99.119.254,209.188.44.35', CGI.REMOTE_ADDR)><cfdump var="#cfcatch#"></cfif></cfcatch>
					</cftry>
				</cfif>

				<cfif ListFind("103.85.207.121", cgi.remote_host)>
	                <cfdump var="#session.booking.resort#">
	            </cfif>

			<cfcatch>
	            <cfif isDefined('ravenClient')>
	                <cfset ravenClient.captureException(cfcatch)>
	            </cfif>
			</cfcatch>

		</cftry>


   </cffunction>




   <cffunction name="getSearchResultsProperty" returnType="query" hint="Returns property results if the user does a sitewide search for a given term like 'ocean front rentals'">

   	<cfargument name="searchterm" required="true">

<!--- 		<cfquery DATASOURCE="#variables.settings.booking.dsn#" NAME="results">
			SELECT seoPropertyName,id as propertyid,name as propertyname,shortdescription as propertydesc, IFNULL(seoDestinationName,'area') as seoDestinationName
			FROM track_properties
			where name like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#arguments.SearchTerm#%">
			or shortdescription like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#arguments.SearchTerm#%">
			or longdescription like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#arguments.SearchTerm#%">
			or streetAddress like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#arguments.SearchTerm#%">
		</cfquery> --->
		<cfquery DATASOURCE="#variables.settings.booking.dsn#" NAME="results">
			SELECT cpe.strPropID,tp.seoPropertyName,tp.id as propertyid,tp.name as propertyname,tp.shortdescription as propertydesc, IFNULL(tp.seoDestinationName,'area') as seoDestinationName
			FROM cms_property_enhancements cpe
			INNER JOIN track_properties tp ON tp.id = cpe.strPropID
			WHERE cpe.longdescription like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#arguments.SearchTerm#%">
			Order by Rand()
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

	<cfif isdefined('cookie.trnsnmb') and cookie.trnsnmb eq arguments.reservationNumber>

		<cfsavecontent variable="temp"></cfsavecontent>

	<cfelse>

      <cfsavecontent variable="temp">
      <cfoutput>
         <script type="text/javascript" defer>
           (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
           (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
           m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
           })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

           ga('create', '#settings.googleAnalytics#', 'auto');
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
      </cfsavecontent>

      <cftry>
      	<!--- name ambiguous on purpose --->
      	<cfoutput><cfcookie name="trnsnmb" value="#reservationNumber#" expires="30"></cfoutput>
      	<cfcatch></cfcatch>
      </cftry>

    </cfif>




      <cfreturn temp>

   </cffunction> <!--- end of setGoogleAnalytics function --->




   <cffunction name="setPropertyMetaData" returnType="string" hint="Sets the meta data for the property detail page">

      <cfargument name="property" required="true">

	  <cfquery name="getenhancements" datasource="#settings.dsn#">
		SELECT *
		FROM cms_property_enhancements
		WHERE strpropid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#property.propertyid#">
		</cfquery>

      <cfsavecontent variable="temp">
         <cfoutput>
         <title><cfif Len(getenhancements.seotitle)>#getenhancements.seotitle#<cfelse>#property.name# | #property.city# Vacation Rentals - #left(property.SEOdescription,'50')#</cfif></title>
         <cfset tempDescription = striphtml(mid(getenhancements.metadescription,1,300))>
		 <cfset tempDescription = Replace(tempDescription, '"',"'","ALL")>
         <meta name="description" content="#tempDescription#">
         <meta property="og:title" content="#property.name# - #variables.settings.company#">
         <meta property="og:description" content="#tempDescription#">
         <meta property="og:url" content="http://#cgi.http_host#/#variables.settings.booking.dir#/#property.seoDestinationName#/#property.seoPropertyName#">
         <meta property="og:image" content="https://img.trackhs.com/1200x630/#property.defaultPhoto#">
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
   		select name FROM southernresorts.track_nodes where typeId = 3
   	</cfquery>

   	<cfset areaList = ValueList(qryGetDistinctAreas.name)>

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
   			seopropertyname, seodestinationname,
   			maxoccupancy as sleeps,
   			bedrooms,
   			fullBathrooms as bathrooms,
   			IFNULL(seoDestinationName,'area') as seoDestinationName,
   			locality
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
				seopropertyname,
				name,
				bedrooms,
				locality as `location`,
				fullBathrooms as bathrooms,
				halfBathrooms,
				petsFriendly as petsAllowed,
				lodgingtypename as type,
				0 as minprice,
				0 as maxprice,
				coverImage as defaultPhoto,
				maxoccupancy as sleeps,
			    shortdescription as description,
			IFNULL(seoDestinationName,'area') AS seoDestinationName,
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
<cfset numNights = DateDiff('d',arguments.strcheckin,arguments.strcheckout)>
		<cfquery name="qryGetPriceBasedOnDates" dataSource="#variables.settings.booking.dsn#">
			select rateMin as baseRate
			from track_properties_availability
			where propertyid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#arguments.propertyid#">
			and theDate = "#Dateformat(arguments.strcheckin,'yyyy-mm-dd')#"
		</cfquery>
		<cfset price = qryGetPriceBasedOnDates.baseRate>
		<cfset price = price * numnights>
		<cfset price = dollarformat(price)>
		<cfset price = replace(price,".00","")>
		<cfif qryGetPriceBasedOnDates.recordcount gt 0 AND 1 EQ 0>
			<cfset tempReturn = price & ' <small>+Taxes</small>'>
		<cfelse>
		  <cfset tempReturn = ''>
		</cfif>

		<cfreturn tempReturn>

   </cffunction>


	<cffunction name="parseTaxPercentage" returntype="string" output="false">
		<cfargument name="taxName" required="false">
		<cfset returnThis = "0">

		<cftry>
			<cfset findFirstParenthesis = FindNoCase("(", arguments.taxName) + 1>
			<cfset midCount = (LEN(arguments.taxName) - findFirstParenthesis) - 1>
			<cfset returnThis = mid(arguments.taxName,findFirstParenthesis,midCount)>
		<cfcatch></cfcatch>
		</cftry>

		<cfreturn returnThis>
	</cffunction>

  <cffunction name="getGoogleSearchLog" returntype="string" hint="Returns a ga event to log an initial or refined search">
    <cfargument name="searchType" type="string" required="true" default="initial" hint="initial or refine">

    <!--- log the search with Google Analytics (in results.cfm & ajax/results.cfm)
      These definitions will be different from client to client, and will be provided by SEO
      The code below will need
	dimension1 = Arrival Date
	dimension2 = Guests
	dimension3 = Bedrooms
	dimension4 = Amenities
	dimension5 = Location --->

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
    </cfif>

    <cfif isdefined('session.booking.bedrooms') and session.booking.bedrooms neq '' and session.booking.bedrooms neq 0>
      <cfset local.dimensionsList = listAppend(local.dimensionsList, "'dimension2':#sleeps#")>
    </cfif>

    <cfif isdefined('session.booking.bedrooms') and session.booking.bedrooms neq '' and session.booking.bedrooms neq 0>
      <cfset local.dimensionsList = listAppend(local.dimensionsList, "'dimension3':'#session.booking.bedrooms#'")>
    </cfif>

    <cfif isdefined('session.booking.amenities') and ListLen(session.booking.amenities)>
      <cfset local.dimensionsList = listAppend(local.dimensionsList, "'dimension4':'#session.booking.amenities#'")>
    </cfif>

    <cfif isdefined('session.booking.location') and ListLen(session.booking.location)>
      <cfset local.dimensionsList = listAppend(local.dimensionsList, "'dimension5':'#session.booking.location#'")>
    </cfif>

    <cfsavecontent variable="local.returnString">
		gtag('config', 'UA-972629-1', {
		  'custom_map': {'dimension1': 'Arrival Date','dimension2': 'Guests','dimension3': 'Bedrooms','dimension4': 'Amenities','dimension5': 'Location'}
		});

      <cfoutput>
        gtag('event', 'User Performs Search', {#local.dimensionsList#});
      </cfoutput>
    </cfsavecontent>

    <cfreturn local.returnString>
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
