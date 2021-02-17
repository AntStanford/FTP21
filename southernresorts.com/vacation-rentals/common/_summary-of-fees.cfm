<cfquery name="qryAddons" datasource="#settings.dsn#">
select * from cms_checkout_addons
</cfquery>
<!--- <cfif ListFind('216.99.119.254,209.188.44.35', CGI.REMOTE_ADDR)><cfdump var="#now()#"></cfif> --->
<!--- <cfif ListFind('216.99.119.254', CGI.REMOTE_ADDR)><cfdump var="#url#"></cfif>
<cfif ListFind('216.99.119.254', CGI.REMOTE_ADDR)><cfdump var="#json.breakdown#"></cfif> --->

<cfset variables.defaultDaysOut = 14> <!--- 60 ---> <!--- also change in book-now.cfm line 128 --->

	<!--- Calculate the Deposit --->
	<!--- Loop through taxes, parse Tax percent and calculate total tax --->
	<cfset variables.booknowTemp.totalTaxPercent = 0>
	<cfset variables.booknowTemp.servicefees = 0>

		<cfloop array="#json.breakdown.taxes.itemized#" index="i">
			<cfset variables.booknowTemp.totalTaxPercent = variables.booknowTemp.totalTaxPercent + application.bookingObject.parseTaxPercentage(i.name)>
		</cfloop>
		<cfloop array="#json.charges.required#" index="i">
			<cfif i.displayAs eq 'fees'>
				<cfset variables.booknowTemp.servicefees = variables.booknowTemp.servicefees + i.itemPrice>
			</cfif>
		</cfloop>

	<cfset variables.booknowTemp.percentageOfRent = json.breakdown.rent / 10> <!--- 10% of Rent --->
	<cfset variables.booknowTemp.taxTotal = (variables.booknowTemp.percentageOfRent + variables.booknowTemp.servicefees) * variables.booknowTemp.totalTaxPercent>
	<cfset variables.booknowTemp.taxTotal = variables.booknowTemp.taxTotal / 100>
	<cfset variables.booknowTemp.thisDeposit = variables.booknowTemp.percentageOfRent + variables.booknowTemp.servicefees + variables.booknowTemp.taxTotal>
	<cfset variables.depositTotal = NumberFormat(variables.booknowTemp.thisDeposit,'______.__')>
	<cfset variables.depositTotal = TRIM(variables.depositTotal)> 
	
<cfoutput>
	<div id="hiddenDeposit" style="display:none;" data-cost="#variables.depositTotal#"></div>
	<!--- for some reason the ICNDeyesOnly doesn't work here --->
	<cfparam name="url.paychoice" default="half" />

	<cfif url.paychoice EQ "undefined">
		<cfset url.paychoice  = "half">
	</cfif>
	<!--- Loop through all the taxes and fees and tally up the total amount --->
	<cfif StructKeyExists(json,'breakdown') and StructKeyExists(json.breakdown,'charges') and StructKeyExists(json.breakdown.charges,'itemized')>
		<!--- <cfif ListFind('216.99.119.254,209.188.44.35,75.87.75.62', CGI.REMOTE_ADDR)>ICND Eyes Only: Call <cfdump var="#serializeJSON(variables.formFields)#"> Response Unit: <cfdump var="#json.unit.name#"></cfif> --->
		<!--- if arrival date is more than 60 days out form today, off half payment --->
		<cfset numdaysout = dateDiff( 'd', now(), url.strcheckin ) />
		<cfset taxesAndFees = 0 />
		<!--- <cfset halftotal = 0 /> --->
		<cfset halftotal = variables.depositTotal />

		<div class="panel-group property-cost-list<cfif isDefined('url.expanded') AND url.expanded EQ 'true'> pclOpen</cfif>">
			<div class="panel panel-default">
				<div id="collapse1" class="panel-collapse collapse <cfif isDefined('url.expanded') AND url.expanded EQ 'true'> in</cfif>" <cfif isDefined('url.expanded') AND url.expanded EQ 'true'> aria-expanded="true"</cfif>>
					<div class="panel-body">
						<div class="property-cost-list-rent"><strong>Rent <span class="jackpot-message"></span></strong> <span class="text-right">#DollarFormat(json.breakdown.rent)#</span></div>
						<cfset taxesAndFees = 0>
						
						<cfloop array="#json.breakdown.charges.itemized#" index="charge">
							<cfset chargeValue = charge.value>
							<cfset taxesAndFees = taxesAndFees + chargeValue>
						</cfloop>
						
						<cfset taxesAndFees = taxesAndFees + json.breakdown.taxes.total>
						
						<cfsavecontent variable="charges">
							<cfloop array="#json.breakdown.taxes.itemized#" index="charge">
								<div class='property-cost-list-taxes-fees-looped'><strong>#charge.name#</strong> - <span>#DollarFormat(charge.value)#</span></div>
							</cfloop>
						</cfsavecontent>
						<!--- <div class="property-cost-list-taxes-fees" data-toggle="tooltip" data-html="true" title="#charges#"><strong>Taxes & Fees</strong> <span class="text-right">#DollarFormat(taxesAndFees)#</span> <i class="fa fa-info-circle" aria-hidden="true"></i></div> --->
						<!--- <div class="property-cost-list-cleaning-fee"><strong>Cleaning Fee</strong> <span class="text-right">$#json.breakdown.charges.itemized[2].value#</span></div> --->			
						<cfloop array="#json.breakdown.charges.itemized#" index="item">
							<div class="property-cost-list-service-fees"><strong>#item.name#</strong> <span class="text-right">$#item.value#</span></div>
						</cfloop>
						<!--- <div class="property-cost-list-service-fees"><strong>Service Fees</strong> <span class="text-right">$#json.breakdown.charges.itemized[1].value#</span></div> --->				
							
						<cfloop query="qryAddons">
							<div class="property-cost-list-service-fees" id="addon_#qryAddons.track_id#" style="display:none"><strong>#qryAddons.title# <a onclick="javascript:removeAddon(#qryAddons.track_id#)" href="javascript:;">Remove</a></strong> <span class="text-right" id="addon_price_#qryAddons.track_id#"></span></div>
						</cfloop>

						<div class="property-cost-list-taxes"><strong>Taxes</strong> <span class="text-right">$#json.breakdown.taxes.total#</span></div>
						
						<cfif StructKeyExists(json,'promoCode')>
							<span id="discount" data-amount="#json.breakdown.discount#"></span>

							<cfif val( json.breakdown.discount ) gt 0>
								<div id="promoCodeTr" class="property-cost-list-promo-code">
									<strong>Discount</strong> <span class="text-right">(#DollarFormat(json.breakdown.discount)#)</span>
								</div>
							</cfif>
							<!---<tr><td colspan="2">Promo code applied!</td></tr>--->
						</cfif>

						<div class="property-cost-list-total-with-insurance success amount-with-insurance" <cfif structKeyExists( url, 'ti' ) AND url.ti neq 'add_insurance'>style="display: none;"</cfif>>
							<strong>Optional - Travel Insurance</strong> <span class="text-right">#DollarFormat(json.breakdown.travelInsurance)#</span>
						</div><!--END promoCodeTr-->
					</div><!--END panel-body-->
				</div><!--END panel-collapse-->
				<!---
				        <div class="alert-success">
				            <h4 class="panel-title">
				                <a data-toggle="collapse" href="##collapse1">
				                  <div class="property-cost-list-total"> <span id="costRowShowHide" class="glyphicon glyphicon-plus"></span> <strong>Total</strong> <span class="text-right">#DollarFormat(json.breakdown.total)#</span></div>
				                </a>
				            </h4>
				        </div>
				--->
        
		        <div class="alert-success amount-without-insurance" <cfif structKeyExists( url, 'ti' ) and url.ti is 'add_insurance'>style="display:none"</cfif>>
		            <h4 class="panel-title">
		                <a data-toggle="collapse" href="##collapse1" id="togglem" <cfif isDefined('url.expanded') AND url.expanded EQ 'true'> aria-expanded="true"</cfif>>
		                  <div class="property-cost-list-total"> <span id="costRowShowHide" class="glyphicon glyphicon-plus"></span> <strong><cfif val( numdaysout ) gte variables.defaultDaysOut>Total<cfelse>Total</cfif></strong> <span class="text-right" id="summarytotal">#DollarFormat(json.breakdown.total)#</span></div>
		                </a>
		            </h4>
		        </div><!--END alert-success-->
        
		        <div class="alert-success amount-with-insurance" <cfif !structKeyExists( url, 'ti' ) or (structKeyExists( url, 'ti' ) AND url.ti neq 'add_insurance')>style="display: none;"</cfif>>
		            <h4 class="panel-title">
		                <a data-toggle="collapse" href="##collapse1" id="togglem" <cfif isDefined('url.expanded') AND url.expanded EQ 'true'> aria-expanded="true"</cfif>>
		                  <div class="property-cost-list-total"> <span id="costRowShowHide" class="glyphicon glyphicon-plus"></span> <strong>Total</strong> <span class="text-right" id="summarytotal2">
		                    
								<cfif val( numdaysout ) gte variables.defaultDaysOut and isDefined('url.paychoice') and url.paychoice is 'half'>
									<b>#DollarFormat(json.breakdown.totalInsurance/2)#</b>
								<cfelse>
									<b>#DollarFormat(json.breakdown.totalInsurance)#</b>
								</cfif>

								</span>
							</div>
		                </a>
		            </h4>
		        </div><!--END alert-success-->
		    </div><!--END panel-->
		</div><!-- END panel-group -->
		
		<!---
		

		<table class="table table-striped">
			<tr class="info">
				<td><b>Description</b></td>
				<td align="right"><b>Price</b></td>
			</tr>
			<tr>
				<td>Rent <span class="jackpot-message"></span></td>
				<td align="right">#DollarFormat(json.breakdown.rent)#</td>
			</tr>

			<cfloop array="#json.breakdown.charges.itemized#" index="charge">
			   <cfset chargeValue = charge.value>
			   <cfset taxesAndFees = taxesAndFees + chargeValue>
			</cfloop>

			<cfset taxesAndFees = taxesAndFees + json.breakdown.taxes.total>

			<tr>
				<td>Taxes & Fees</td>
				<td align="right">#DollarFormat(taxesAndFees)#</td>
			</tr>

			<cfif StructKeyExists(json,'promoCode')>
				<tr id="promoCodeTr">
					<td>Discount</td>
					<td align="right">(#DollarFormat(json.breakdown.discount)#)</td>
				</tr>
				<!---<tr><td colspan="2">Promo code applied!</td></tr>--->
			</cfif>
<!--- 		</table> --->

<!---
		<table class="table table-striped" id="insuranceTable">
			<tr>
				<td colspan="2"><b>Insurance</b></td>
			</tr>
--->
		
			<tr class="success amount-with-insurance" style="display: none;">
				<td>Optional - Travel Insurance</td>
				<td align="right">#DollarFormat(json.breakdown.travelInsurance)#</td>
			</tr>
<!---
			<tr>
				<td><b>Total w/Insurance</b></td>
				<td align="right">
					
				</td>
			</tr>
---><!---

		</table>
--->

<!--- 		<table class="table table-striped"> --->
			
	--->		
			
			<cfif val( numdaysout ) gte variables.defaultDaysOut>
				<!--- <cfset halftotal += json.breakdown.total / 2 /> --->
				
				
				<div class="alert alert-info">
					<p><input type="radio" name="tchoice" class="tchoice" id="tchoice_total" value="full" <cfif isDefined('url.paychoice') and url.paychoice is 'full'>checked="checked"</cfif> onclick="updateSummaryOfFees()"/> 
						<label for="fulltotal">Pay In Full <span id="summarytotalr">#dollarFormat( json.breakdown.total )#</span></label></p>
					  <p><input type="radio" name="tchoice" class="tchoice" id="tchoice_half" value="half"  <cfif (isDefined('url.paychoice') and url.paychoice is 'half')>checked="checked"</cfif> onclick="updateSummaryOfFees()"/> 
						<label for="halftotal">Pay Deposit <span id="halftotalr">#dollarFormat( variables.depositTotal )#</span></label></p>
				  </div>
<!---
				<tr class="success amount-without-insurance">
					<td>
						Pay In Full
					</td>
					<td align="right">#dollarFormat( json.breakdown.total )#</td>
				</tr>

				<tr class="success amount-without-insurance">
					<td>
						<input type="radio" name="tchoice" class="tchoice" id="tchoice_half" value="half"  <cfif (isDefined('url.paychoice') and url.paychoice is 'half')>checked="checked"</cfif> onclick="updateSummaryOfFees()"/> 
					</td>
					<td align="right">#dollarFormat( halftotal )# </td>
				</tr>

			<cfelse>
				<tr class="success amount-without-insurance">
					<td>Due At Booking</td>
					<td align="right">#DollarFormat(json.breakdown.total)#</td>
				</tr>
--->
<cfelse>
	<div class="alert alert-info">
					<p>
						<label for="fulltotal">Due Today <span id="summarytotalr2">#dollarFormat( json.breakdown.total )#</span></label></p>
					 
				  </div>
			</cfif>
			
			<!---
			<tr class="success amount-with-insurance" style="display: none;">
					<td>Total Amount w/insurance</td>
					<td align="right">
				<cfif val( numdaysout ) gte 60 and isDefined('url.paychoice') and url.paychoice is 'half'>
						<b>#DollarFormat(json.breakdown.totalInsurance/2)#</b>
					<cfelse>
						<b>#DollarFormat(json.breakdown.totalInsurance)#</b>
					</cfif>
					</td>
				
			</tr>
--->
			
		</table>
		
		
	</cfif>

	<h3>Protect Your Trip</h3>
	<b>Travel Insurance</b> - Protect your payments should you have to cancel.<br /><br />
	
	<div class="alert alert-info">
    <p><input type="radio" name="travel_insurance" class="travel_insurance" value="add_insurance" id="addinsurance" <cfif (structKeyExists( url, 'ti' ) and url.ti is 'add_insurance')>checked="checked"</cfif>>
		<label for="addinsurance">Add travel insurance for #Dollarformat(json.breakdown.travelInsurance)#</label></p>
	  <p><input type="radio" name="travel_insurance" class="travel_insurance" value="remove_insurance" id="removeinsurance" <cfif structKeyExists( url, 'ti' ) and url.ti is 'remove_insurance'>checked="checked"</cfif>>
		<label class="nothanks" for="removeinsurance">No thanks, I am not interested in travel insurance</label></p>
  </div>
	
	<!--- This script loads the data from the API call to the hidden input fields in the checkout form --->

	<script type="text/javascript">
	   <cfif val( numdaysout ) gte variables.defaultDaysOut and isDefined('url.paychoice') and url.paychoice is 'half' AND not StructKeyExists(json,'promoCode')>
	   	// console.log('here1');
			<cfset ti_total = json.breakdown.totalInsurance / 2 />
			<cfset half_total = json.breakdown.total /2 />
			$('input##TotalWithInsurance').val("#ti_total#");
		    $('input##originalTotal').val("#json.breakdown.total#");
		    $('input##Total').val("#variables.depositTotal#");
			
			console.log('#variables.depositTotal#');
			
			$('input##tripinsuranceamount').val("#json.breakdown.travelInsurance#");
			$('##BookingValue').val('#variables.depositTotal#');
			$('##payHalf').val(true);
		<cfelse>
			// console.log('here2');
		   	$('input##TotalWithInsurance').val("#json.breakdown.totalInsurance#");
			$('input##originalTotal').val("#json.breakdown.total#");
			$('input##Total').val("#json.breakdown.total#");
			$('input##tripinsuranceamount').val("#json.breakdown.travelInsurance#");
			$('##BookingValue').val('#json.breakdown.total#');
			$('##payHalf').val(false);
		</cfif>
	</script>
</cfoutput>