<cfoutput>
	<!--- Loop through all the taxes and fees and tally up the total amount --->
	<!--- <cfdump var="#json#" abort="false"> --->
	<cfif StructKeyExists(json,'breakdown') and StructKeyExists(json.breakdown,'charges') and StructKeyExists(json.breakdown.charges,'itemized')>
		<cfset taxesAndFees = 0 />
		<cfset daysout = dateDiff( 'd', dateFormat( now(), 'yyyy-mm-dd' ), url.strcheckin ) />
		<cfset today = dateFormat( now(), 'yyyy-mm-dd' ) />
		<cfset duetoday = 0 />
		<cfset duelater = 0 />

		<cfset dogcount = ( isDefined('arguments.petcount') AND LEN(arguments.petcount) ? arguments.petcount  : 0)>

		<cfif structKeyExists( json, 'paymentPlan' )>
			<cfset pp_array = structKeyArray( json.paymentPlan ) />
			<!---
				If the arrival date is <= 30 days, there is only one paymentPlan
				If it's > 30 days, there are two
			--->
			<cfif arrayLen( pp_array ) eq 2>
				<!--- the array of days aren't in order so we check which amount matches today --->
				<cfif json.paymentPlan[pp_array[1]] eq json.paymentPlan['#today#']>
					<cfset duetoday += json.paymentPlan[pp_array[1]] />
					<cfset duelater += json.paymentPlan[pp_array[2]] />
				<cfelse>
					<cfset duetoday += json.paymentPlan[pp_array[2]] />
					<cfset duelater += json.paymentPlan[pp_array[1]] />
				</cfif>
			<cfelse>
				<cfset duetoday += json.paymentPlan[pp_array[1]] />
			</cfif>
		<cfelse>
			<cfset duetoday += json.breakdown.total />
		</cfif>

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

				<cfif charge.name contains 'Pet Fee'>
					<tr>
						<td>#charge.name#</td>
						<td align="right">#DollarFormat(charge.value)#</td>
					</tr>
				<cfelseif !charge.name contains 'Fee'>
					<tr>
						<td>#charge.name#</td>
						<td align="right">#DollarFormat(charge.value)#</td>
					</tr>
				</cfif>
			</cfloop>

		<!--- Add-Ons Rows to display selected Add-ons --->
		<cfset variables.addOns = json.charges.addOn>

		<cfloop index="i" from="1" to="#arrayLen(variables.addOns)#">
			<tr id="addOnRow#variables.addOns[i].id#" style="display:none;">
				<td>#variables.addOns[i].name# (<span id="addOnQty#variables.addOns[i].id#">1</span>)</td>
				<td align="right"><span id="addOnPrice#variables.addOns[i].id#"></span></td>
			</tr>
		</cfloop>
		
			<tr id="travelInsuranceRow" style="display: none;">
				<td>Travel Insurance</td>
				<td align="right">#DollarFormat(json.breakdown.travelInsurance)#</td>
			</tr>

			<cfset taxesAndFees = taxesAndFees + json.breakdown.taxes.total>
			<tr>
				<td>Taxes & Fees</td>
				<td align="right" id="taxAndFeeDisplay">#DollarFormat(taxesAndFees)#</td>
		<cfset variables.taxAndFeeDisplay = taxesAndFees>
			</tr>

			<cfif StructKeyExists(json,'promoCode') and json.breakdown.discount neq 0>
				<tr id="promoCodeTr">
					<td>Discount</td>
					<td align="right">(#DollarFormat(json.breakdown.discount)#)</td>
				</tr>
				<!---<tr><td colspan="2">Promo code applied!</td></tr>--->
			</cfif>

			<tr class="success">
				<td>Total Amount</td>
				<td align="right" id="totalAmountDisplay">#DollarFormat(json.breakdown.total)#</td>
		<cfset variables.totalAmountDisplay = json.breakdown.total>
			</tr>
			<tr style="background-color: ##f5f5dc;">
				<td>Due Today</td>
				<td align="right" id="DueTodayDisplay">#dollarFormat( duetoday )#</td>
			</tr>
			<!---
			<cfif val( duelater ) gt 0>
				<tr class="success">
					<td>Due Later</td>
					<td align="right">#dollarFormat( duelater )#</td>
				</tr>
			</cfif>
			--->
		</table>

		<table class="table table-striped" id="insuranceTable">
			<tr>
				<td colspan="2"><b>Insurance</b></td>
			</tr>
			<tr>
				<td>Travel Insurance</td>
				<td align="right">#DollarFormat(json.breakdown.travelInsurance)#</td>
			</tr>
			<tr>
				<td><b>Total Due Today w/Insurance</b></td>
				<td align="right"><b><span id="DueTodaywInsuranceDisplay">#dollarFormat( json.breakdown.travelInsurance + duetoday )#</span></b></td>
			</tr>
			<tr>
				<td><b>Total w/Insurance</b></td>
				<td align="right"><b><span id="TotalwInsuranceDisplay">#DollarFormat(json.breakdown.totalInsurance)#</span></b></td>
			</tr>
		</table>
	</cfif>

  <div class="enhancements-popup-wrap">
	<!---<p>Complete your stay by adding bikes, golf, cribs, and other items here.</p>--->
	<p>Complete your stay by adding additional gate passes (your reservation comes with one gate pass), bikes and more here.</p>

	<button type="button" class="btn enhancements-btn site-color-2-bg site-color-1-bg-hover text-white" id="bookingEnhancementsBtn"><strong>View Now</strong></button>
	
	<div id="enhancementsPopup" class="enhancements-popup hidden">
	  <div class="enhancements-body">
		<ul class="enhancements-list">
		  <li class="title-row">
			<div class="enhancement-item enhancement-select">Quantity</div>
			<div class="enhancement-item enhancement-option">Enhancement Item</div>
			<div class="enhancement-item enhancement-price">Price</div>
		  </li>
		 <!--- Loop Start --->
			<cfset arrayToQuery = application.bookingObject.associativeArrayToQuery( variables.addOns ) />
			<!---
			The client wants add-ons to display a certain order (car pass first)
			It wasn't working with the array so I wrote a function to turn the array into a query
			--->
			<cfquery name="sortAddons" dbtype="query">
			SELECt *
			FROM arrayToQuery
			WHERE itemPrice > 0
			AND maxQuantity > 0
			ORDER BY sort
			</cfquery>

			<cfloop query="sortAddons">
				<li <cfif itemPrice lte 0>class="hide"</cfif> >
					<div class="enhancement-item enhancement-select">
						<select class="form-control" id="enhancements_#id#" name="enhancements_#id#">
							<option value="0">0</option>
						  
							<cfif maxQuantity gt 50>
								<cfset variables.maxQty = 50>
							<cfelse>
								<cfset variables.maxQty = maxQuantity>
							</cfif>
						  
							<cfloop index="j" from="1" to="#variables.maxQty#">
								<option value="#j#">#j#</option>
							</cfloop>
						</select>
					</div>

					<div class="enhancement-item enhancement-option">
						#name#
					</div>

					<div class="enhancement-item enhancement-price">
						#dollarFormat( itemPrice )#
					
						<cfif taxable is 'Yes' and itemTax gt 0>
							+ #dollarFormat( itemTax )# tax
						</cfif>
					</div>
				</li>
			</cfloop>
		</ul>
	  </div>

	  <div class="enhancements-btns">
		<button type="button" id="enhancementsClose" class="btn btn-close pull-left site-color-1-bg site-color-2-bg-hover text-white"><i class="fa fa-times"></i> <strong>Close</strong></button>
		<button type="button" id="enhancementsApply" class="btn btn-close pull-right site-color-2-bg site-color-1-bg-hover text-white"><i class="fa fa-chevron-right"></i> <strong>Apply</strong></button>
	  </div>
	</div>
  </div>

  <script>
	$(document).ready(function(){
<!---
	  function currencyFormat(num) {
		return '$' + num.toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')
	  }
--->

	  $('##bookingEnhancementsBtn').on('click', function(){
		$(this).next('##enhancementsPopup').toggleClass('hidden');
	  });
	  $('##enhancementsClose').on('click', function(){
		$(this).parent().parent().addClass('hidden');
	  });
	  $('##enhancementsApply').on('click', function(){
		$(this).parent().parent().addClass('hidden');

				<!--- DefaultTotal Amounts that need to add to the Taxes and Total fields from Add-ons --->
				var allAddOns = '';
				var addAddOnsTotal = 0;
				var addTaxes = #variables.taxAndFeeDisplay#;
				var addTotal = #variables.totalAmountDisplay#;
				var addTotalOriginalValue = addTotal;
				<!--- Loop through Add-ons to create Javascript necessary to hide and adjust Quantity and Amount fields each Add-on Row --->
				<cfloop index="i" from="1" to="#arrayLen(variables.addOns)#">
					var qty = $('##enhancements_#variables.addOns[i].id#').val();
					if(qty > 0){
						var amt = qty*#variables.addOns[i].itemPrice#;
						addTaxes = addTaxes + (qty*#variables.addOns[i].itemTax#);
						addAddOnsTotal = addAddOnsTotal + amt + (qty*#variables.addOns[i].itemTax#);
						addTotal = addTotal + amt + (qty*#variables.addOns[i].itemTax#);
						document.getElementById('addOnQty#variables.addOns[i].id#').innerHTML = qty;
						document.getElementById('addOnPrice#variables.addOns[i].id#').innerHTML = '$' + amt.toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,');
						document.getElementById('addOnRow#variables.addOns[i].id#').style.display = '';
						if(allAddOns != ''){
							allAddOns = allAddOns.concat(',');
						}
						allAddOns = allAddOns.concat('#variables.addOns[i].id#-',qty);
					} else {
						document.getElementById('addOnRow#variables.addOns[i].id#').style.display = 'none';
						document.getElementById('addOnQty#variables.addOns[i].id#').innerHTML = 0;
						document.getElementById('addOnPrice#variables.addOns[i].id#').innerHTML = 0;
					}
				</cfloop>
				<!--- Adjust Tax and Total Amounts based on selected Add-ons --->
				document.getElementById('taxAndFeeDisplay').innerHTML = '$' + addTaxes.toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,');
				document.getElementById('totalAmountDisplay').innerHTML = '$' + addTotal.toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,');
				var dueToday = addTotal / 2;
				document.getElementById('DueTodayDisplay').innerHTML = '$' + dueToday.toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,');
			  $('input##TotalTotal').val(addTotal.toFixed(2));
				$('input##Total').val(dueToday.toFixed(2));
				var dueTodaywInsurance = #json.breakdown.travelInsurance# + dueToday;
				document.getElementById('DueTodaywInsuranceDisplay').innerHTML = '$' + dueTodaywInsurance.toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,');
				$('input##TotalWithInsurance').val(dueTodaywInsurance.toFixed(2));
				var totalwInsurance = #json.breakdown.travelInsurance# + addTotal;
				document.getElementById('TotalwInsuranceDisplay').innerHTML = '$' + totalwInsurance.toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,');
			  $('input##TotalTotalWithInsurance').val(totalwInsurance.toFixed(2));
				$('input##allAddOns').val(allAddOns);
				$('input##allAddOnsTotalValue').val(addAddOnsTotal);

				<!---TT 113353 start--->
					if($('##addinsurance').is(':checked')) {
						$("##addinsurance").trigger("click");
					}
				<!---TT 113353 end--->

		// UPDATE apiresponse HERE
	  });
	});
  </script>

	<h3>Protect Your Trip</h3>
	<b>Travel Insurance</b> - Protect your payments should you have to cancel.<br /><br />
	<p><input type="radio" name="travel_insurance" value="add_insurance" id="addinsurance"
		<cfif isDefined('travelInsuranceSelected') AND travelInsuranceSelected EQ "true">
			checked="checked"
		</cfif>
	> <label for="addinsurance">Add travel insurance for #Dollarformat(json.breakdown.travelInsurance)#</label></p>
	<p><input type="radio" name="travel_insurance" value="remove_insurance" id="removeinsurance"
		<cfif isDefined('travelInsuranceSelected') AND travelInsuranceSelected EQ "false">
			checked="checked"
		</cfif>
	> <label class="nothanks" for="removeinsurance">No thanks, I am not interested in travel insurance</label></p>

	<!--- This script loads the data from the API call to the hidden input fields in the checkout form --->
	<script type="text/javascript">
	   $('input##TotalTotalWithInsurance').val("#json.breakdown.totalInsurance#");
	   $('input##petfeePromoCode').val("#dogcount#");
	   $('input##TotalTotal').val("#variables.totalAmountDisplay#");
	   $('input##TotalWithInsurance').val("#json.breakdown.totalInsurance#");
	   $('input##Total').val("#duetoday#");
	   $('input##tripinsuranceamount').val("#json.breakdown.travelInsurance#");
	   $('##BookingValue').val('#json.breakdown.total#');
	</script>
</cfoutput>