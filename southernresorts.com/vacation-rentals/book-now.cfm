<cfif !isdefined('url.strCheckin')>Check-In not defined<cfabort></cfif>
<cfif !isdefined('url.strCheckout')>Check-Out not defined<cfabort></cfif>
<cfif isdefined('url.strcheckin') and !isValid('date',url.strcheckin)>Check-In date not valid.<cfabort></cfif>
<cfif isdefined('url.strcheckout') and !isValid('date',url.strcheckout)>Check-Out date not valid.<cfabort></cfif>
<cfif !isdefined('url.propertyid')><!---you are a bot--->Propertyid is required.<cfabort></cfif>

<!--- QUERY TO GET PROPERTY INFO --->
<cfset property = application.bookingObject.getProperty(url.propertyid)>

<cfinclude template="/#settings.booking.dir#/components/header.cfm">

<!---START: NEW CART ABANDOMENT FEATURE--->
<!---set the cookie b/c you made it to the booknow page--->
<cfcookie name="CartAbandonmentFooter" value="#url.propertyid#" expires="NEVER">
<cfcookie name="CartAbandonmentFooterCheckIn" value="#url.strCheckin#" expires="NEVER">
<cfcookie name="CartAbandonmentFooterCheckOut" value="#url.strCheckOut#" expires="NEVER">
<!---END: NEW CART ABANDONMENT FEATURE--->

	<div class="booking book-now container-fluid">

		<div class="row clearfix book-now-back-btn" style="padding-top:20px">
			<div class="col-md-12">
    		<cfif cgi.http_referer does not contain 'results.cfm'>
    			<!--- Only show the 'Back' button if the user came from the PDP --->
    			<cfoutput><a href="javascript:history.go(-1)" class="btn pull-right site-color-1-bg site-color-1-lighten-bg-hover text-white"><i class="fa fa-chevron-left"></i> Back</a></cfoutput>
    		</cfif>
			</div>
		</div>

		<div class="row clearfix">
			<div class="col-md-12">
				<div class="page-header">
					<p class="h3 site-color-1 nomargin"><cfoutput>Let's Book Your Rental From #url.strCheckin# to #url.strCheckout#</cfoutput></p>
				</div>
			</div>
		</div>

		<div class="row clearfix">
			<!-- PROPERTY INFO / TRAVEL INSURANCE / PROMO CODE -->
			<div class="col-md-5 col-sm-6" id="propertyinfo">
				<div class="panel panel-default">
					<div class="panel-heading site-color-1-bg">
						<p class="h3 text-white nomargin"><cfoutput>#property.name#</cfoutput></p>
					</div>
					<div class="panel-body npbot">
						<div class="row row-fluid">
							<div class="span12 col-md-12">

								<cfoutput><img src="https://img.trackhs.com/605x432/#property.defaultPhoto#" width="100%"></cfoutput><br /><br />

								<div id="summaryContainer" class="summary-box-container">

									<h3>Summary of Fees</h3>
									<div id="apiresponse"><img src="/images/layout/loader.gif"/></div> <!--- Here is where the summary of fees are loaded in via Ajax --->


									<hr>
									<form id="promocodeform">
										<cfoutput>
											<input type="hidden" name="propertyid" value="#url.propertyid#">
											<input type="hidden" name="strcheckin" value="#url.strcheckin#">
											<input type="hidden" name="strcheckout" value="#url.strcheckout#">
											<input type="hidden" name="ti" value="remove_insurance" id="ti">
											<cfif settings.booking.pms eq 'Escapia'>
												<input type="hidden" name="chargetemplateid" value="" class="chargetemplateid">
											<cfelseif settings.booking.pms eq 'Barefoot'>
												<input type="hidden" name="leaseid" class="leaseid">
											</cfif>
										</cfoutput>

										<div class="form-group">
											<label class="promo-code"><h3>Promo Code</h3></label>
											<div class="row">
  											<div class="col-md-8">
    											<input id="promocode" type="text" class="form-control" autocomplete="off" name="promocode" value="">
  											</div>
  											<div class="col-md-4">
    											<input class="btn btn-block btn-sm site-color-2-bg text-white" type="submit" name="submit" value="Submit" style="margin:0;">
  											</div>
											</div>
										</div>

										<div id="promoCodeMessage"></div>
									</form>
									<br>

									<div class="panel-additionals panel-group" id="accordion" role="tablist" aria-multiselectable="true">
									 <cfinclude template="/vacation-rentals/book-now-addons.cfm">

                  </div>  <!--- --->

									<hr>
									<div class="alert alert-danger">
										<i class="fa fa-star"></i> Your Information is 100% Secure
									</div>
									<div class="cc-logos">
										<p><b>Book With Confidence - our site is safe and secure.</b></p>
										<i class="fa fa-cc-visa" aria-hidden="true"></i>
										<i class="fa fa-cc-mastercard" aria-hidden="true"></i>
										<i class="fa fa-cc-amex" aria-hidden="true"></i>
										<i class="fa fa-cc-discover" aria-hidden="true"></i>
										<!---
                    <div>
											<img src="images/ssl-seal.gif" alt="SSL Secured" border="0" width="80px"> -->
                      <!-- <span id="siteseal"><script defer="defer" type="text/javascript" src="https://seal.godaddy.com/getSeal?sealID=wXo7tiVqkd0IOF2Z4okqmvOtDl2s4B40GXy59PMmsdiM2MdAcuAFsACiCkFG"></script></span> -->
										</div>
										--->
									</div>
								</div><!--- End #summaryContainer --->
							</div>
						</div>
					</div>
				</div>
			</div><!-- END #propertyinfo -->

			<!--- FORM COLUMN --->
			<div class="col-md-7 col-sm-6" id="bookingform">
				<cfset numdaysout = dateDiff( 'd', now(), url.strcheckin ) />

				<cfoutput>
				<form role="form" method="post" action="#settings.booking.bookingURL#/#settings.booking.dir#/book-now-confirm.cfm" id="bookNowForm" class="validate">
					<!--- These input fields are common to any PMS --->
					<input type="hidden" name="propertyId" value="#url.propertyid#">
					<input type="hidden" name="propertyName" value="#property.name#">
					<input type="hidden" name="propertyCity" value="#property.city#">
					<input type="hidden" name="propertyState" value="#property.state#">
					<input type="hidden" name="strCheckin" value="#url.strCheckin#">
					<input type="hidden" name="strCheckout" value="#url.strCheckout#">
					<input type="hidden" id="maxocc" name="maxocc" value="#property.sleeps#">
					<input type="hidden" name="hiddenPromoCode" value="">
					<input type="hidden" name="fraction" value="<cfif val( numdaysout ) gte 30>half<cfelse>full</cfif>" <cfif val( numdaysout ) gte 30>id="fraction"</cfif>>
					<input type="hidden" name="key" value="#cfid##cftoken#">
					<input type="hidden" name="originalTotal" value="" id="originalTotal">
					<input type="hidden" name="Total" value="" id="Total">
					<input type="hidden" name="Deposit" value="" id="Deposit">
					<input type="hidden" name="TotalWithInsurance" value="" id="TotalWithInsurance">
					<input type="hidden" name="TotalDepositWithInsurance" value="" id="TotalDepositWithInsurance">
					<input type="hidden" name="travelInsurance" value="false" id="travelInsurance">
					<input type="hidden" name="tripinsuranceamount" value="" id="tripinsuranceamount">

					<cfloop query="qryAddons">
						<input type="hidden" class="optionalfeesqty" name="optionalfeesqty#qryAddons.track_ID#" value="0" id="optionalfeesqty#qryAddons.track_ID#">
						<input type="hidden" class="optionalfeesamount" name="optionalfeesamount#qryAddons.track_ID#" value="#qryAddons.amount#" id="optionalfeesamount#qryAddons.track_ID#">
					</cfloop>
					</cfoutput>
					<div class="panel panel-default">
  					<div class="panel-heading site-color-1-bg">
							<p class="h3 text-white nomargin">First, We'll Need Your Contact Information</p>
  					</div>
						<div class="panel-body booking-panel">
							<fieldset>
								<div class="row form-group">
									<div class="col-xs-12 col-sm-6">
										<label>First Name</label>
										<input class="form-control required" type="text" name="firstname" id="contactFirstName">
									</div>
									<div class="col-xs-12 col-sm-6">
										<label>Last Name</label>
										<input class="form-control required" type="text" name="lastname" id="contactLastName">
									</div>
								</div>
								<div class="row form-group">
									<div class="col-xs-12 col-sm-6">
										<label>Email address</label>
										<input type="email" class="form-control required email" name="email">
									</div>
									<div class="col-xs-12 col-sm-6">
										<label>Phone</label>
										<input type="text" class="form-control required" name="phone">
									</div>
								</div>
								<div class="row form-group">
									<div class="col-xs-12 col-sm-6">
										<label>Address 1</label>
										<input type="text" class="form-control required" name="address1" id="address1">
									</div>
									<div class="col-xs-12 col-sm-6">
										<label>Address 2</label>
										<input type="text" class="form-control" name="address2" id="address2">
									</div>
								</div>
								<div class="row form-group">
									<div class="col-xs-12 col-sm-6">
										<label>City</label>
										<input type="text" class="form-control required" name="city" id="contactCity">
									</div>
									<div class="col-xs-12 col-sm-6">
										<label>State/Province</label>
										<select id="contactState" name="state" class="form-control required">
											<option selected="" value=" "> </option>
											<option value="AK">AK - ALASKA</option>
											<option value="AL">AL - ALABAMA</option>
											<option value="AR">AR - ARKANSAS</option>
											<option value="AZ">AZ - ARIZONA</option>
											<option value="CA">CA - CALIFORNIA</option>
											<option value="CO">CO - COLORADO</option>
											<option value="CT">CT - CONNECTICUT</option>
											<option value="DC">DC - DISTRICT OF COLUMBIA</option>
											<option value="DE">DE - DELAWARE</option>
											<option value="FL">FL - FLORIDA</option>
											<option value="GA">GA - GEORGIA</option>
											<option value="GU">GU - GUAM</option>
											<option value="HI">HI - HAWAII</option>
											<option value="IA">IA - IOWA</option>
											<option value="ID">ID - IDAHO</option>
											<option value="IL">IL - ILLINOIS</option>
											<option value="IN">IN - INDIANA</option>
											<option value="KS">KS - KANSAS</option>
											<option value="KY">KY - KENTUCKY</option>
											<option value="LA">LA - LOUISIANA</option>
											<option value="MA">MA - MASSACHUSETTS</option>
											<option value="MD">MD - MARYLAND</option>
											<option value="ME">ME - MAINE</option>
											<option value="MI">MI - MICHIGAN</option>
											<option value="MN">MN - MINNESOTA</option>
											<option value="MO">MO - MISSOURI</option>
											<option value="MS">MS - MISSISSIPPI</option>
											<option value="MT">MT - MONTANA</option>
											<option value="NC">NC - NORTH CAROLINA</option>
											<option value="ND">ND - NORTH DAKOTA</option>
											<option value="NE">NE - NEBRASKA</option>
											<option value="NH">NH - NEW HAMPSHIRE</option>
											<option value="NJ">NJ - NEW JERSEY</option>
											<option value="NM">NM - NEW MEXICO</option>
											<option value="NV">NV - NEVADA</option>
											<option value="NY">NY - NEW YORK</option>
											<option value="OH">OH - OHIO</option>
											<option value="OK">OK - OKLAHOMA</option>
											<option value="OR">OR - OREGON</option>
											<option value="PA">PA - PENNSYLVANIA</option>
											<option value="PR">PR - PUERTO RICO</option>
											<option value="RI">RI - RHODE ISLAND</option>
											<option value="SC">SC - SOUTH CAROLINA</option>
											<option value="SD">SD - SOUTH DAKOTA</option>
											<option value="TN">TN - TENNESSEE</option>
											<option value="TX">TX - TEXAS</option>
											<option value="UT">UT - UTAH</option>
											<option value="VA">VA - VIRGINIA</option>
											<option value="VI">VI - VIRGIN ISLANDS</option>
											<option value="VT">VT - VERMONT</option>
											<option value="WA">WA - WASHINGTON</option>
											<option value="WI">WI - WISCONSIN</option>
											<option value="WV">WV - WEST VIRGINIA</option>
											<option value="WY">WY - WYOMING</option>
											<option value='' style="font-weight: bold;">- Canadian Provinces</option>
											<option value="AB">AB - ALBERTA</option>
											<option value="BC">BC - BRITISH COLUMBIA</option>
											<option value="MB">MB - MANITOBA</option>
											<option value="NB">NB - NEW BRUNSWICK</option>
											<option value="NL">NL - NEWFOUNDLAND AND LABRADOR</option>
											<option value="NS">NS - NOVA SCOTIA</option>
											<option value="ON">ON - ONTARIO</option>
											<option value="PE">PE - PRINCE EDWARD ISLAND</option>
											<option value="QC">QC - QUEBEC</option>
											<option value="SK">SK - SASKATCHEWAN</option>
											<option value="NT">NT - NORTHWEST TERRITORIES</option>
											<option value="NU">NU - NUNAVUT</option>
											<option value="YT">YT - YUKON</option>
										</select>
									</div>
								</div>
								<div class="row form-group">
									<div class="col-xs-12 col-sm-6">
										<label>Zip</label>
										<input type="text" class="form-control required" name="zip" id="contactZip">
									</div>
									<div class="col-xs-12 col-sm-6">
										<label>Country</label>
										<select name="country" id="contactCountry" class="form-control required">
											<option value="US" selected="selected">United States</option>
											<option value="CA">Canada</option>
											<option value="AF">Afghanistan</option>
											<option value="AL">Albania</option>
											<option value="DZ">Algeria</option>
											<option value="AS">American Samoa</option>
											<option value="AD">Andorra</option>
											<option value="AO">Angola</option>
											<option value="AI">Anguilla</option>
											<option value="AQ">Antarctica</option>
											<option value="AG">Antigua and Barbuda</option>
											<option value="AR">Argentina</option>
											<option value="AM">Armenia</option>
											<option value="AW">Aruba</option>
											<option value="AU">Australia</option>
											<option value="AT">Austria</option>
											<option value="AZ">Azerbaidjan</option>
											<option value="BS">Bahamas</option>
											<option value="BH">Bahrain</option>
											<option value="BD">Bangladesh</option>
											<option value="BB">Barbados</option>
											<option value="BY">Belarus</option>
											<option value="BE">Belgium</option>
											<option value="BZ">Belize</option>
											<option value="BJ">Benin</option>
											<option value="BM">Bermuda</option>
											<option value="BT">Bhutan</option>
											<option value="BO">Bolivia</option>
											<option value="BA">Bosnia-Herzegovina</option>
											<option value="BW">Botswana</option>
											<option value="BV">Bouvet Island</option>
											<option value="BR">Brazil</option>
											<option value="IO">British Indian Ocean Territory</option>
											<option value="BN">Brunei Darussalam</option>
											<option value="BG">Bulgaria</option>
											<option value="BF">Burkina Faso</option>
											<option value="BI">Burundi</option>
											<option value="KH">Cambodia</option>
											<option value="CM">Cameroon</option>
											<option value="CV">Cape Verde</option>
											<option value="KY">Cayman Islands</option>
											<option value="CF">Central African Republic</option>
											<option value="TD">Chad</option>
											<option value="CL">Chile</option>
											<option value="CN">China</option>
											<option value="CX">Christmas Island</option>
											<option value="CC">Cocos (Keeling) Islands</option>
											<option value="CO">Colombia</option>
											<option value="KM">Comoros</option>
											<option value="CG">Congo</option>
											<option value="CK">Cook Islands</option>
											<option value="CR">Costa Rica</option>
											<option value="HR">Croatia</option>
											<option value="CU">Cuba</option>
											<option value="CY">Cyprus</option>
											<option value="CZ">Czech Republic</option>
											<option value="DK">Denmark</option>
											<option value="DJ">Djibouti</option>
											<option value="DM">Dominica</option>
											<option value="DO">Dominican Republic</option>
											<option value="TP">East Timor</option>
											<option value="EC">Ecuador</option>
											<option value="EG">Egypt</option>
											<option value="SV">El Salvador</option>
											<option value="GQ">Equatorial Guinea</option>
											<option value="ER">Eritrea</option>
											<option value="EE">Estonia</option>
											<option value="ET">Ethiopia</option>
											<option value="FK">Falkland Islands</option>
											<option value="FO">Faroe Islands</option>
											<option value="FJ">Fiji</option>
											<option value="FI">Finland</option>
											<option value="CS">Former Czechoslovakia</option>
											<option value="SU">Former USSR</option>
											<option value="FR">France</option>
											<option value="FX">France (European Territory)</option>
											<option value="GF">French Guyana</option>
											<option value="TF">French Southern Territories</option>
											<option value="GA">Gabon</option>
											<option value="GM">Gambia</option>
											<option value="GE">Georgia</option>
											<option value="DE">Germany</option>
											<option value="GH">Ghana</option>
											<option value="GI">Gibraltar</option>
											<option value="GB">Great Britain</option>
											<option value="GR">Greece</option>
											<option value="GL">Greenland</option>
											<option value="GD">Grenada</option>
											<option value="GP">Guadeloupe (French)</option>
											<option value="GU">Guam (USA)</option>
											<option value="GT">Guatemala</option>
											<option value="GN">Guinea</option>
											<option value="GW">Guinea Bissau</option>
											<option value="GY">Guyana</option>
											<option value="HT">Haiti</option>
											<option value="HM">Heard and McDonald Islands</option>
											<option value="HN">Honduras</option>
											<option value="HK">Hong Kong</option>
											<option value="HU">Hungary</option>
											<option value="IS">Iceland</option>
											<option value="IN">India</option>
											<option value="ID">Indonesia</option>
											<option value="INT">International</option>
											<option value="IR">Iran</option>
											<option value="IQ">Iraq</option>
											<option value="IE">Ireland</option>
											<option value="IL">Israel</option>
											<option value="IT">Italy</option>
											<option value="CI">Ivory Coast</option>
											<option value="JM">Jamaica</option>
											<option value="JP">Japan</option>
											<option value="JO">Jordan</option>
											<option value="KZ">Kazakhstan</option>
											<option value="KE">Kenya</option>
											<option value="KI">Kiribati</option>
											<option value="KW">Kuwait</option>
											<option value="KG">Kyrgyzstan</option>
											<option value="LA">Laos</option>
											<option value="LV">Latvia</option>
											<option value="LB">Lebanon</option>
											<option value="LS">Lesotho</option>
											<option value="LR">Liberia</option>
											<option value="LY">Libya</option>
											<option value="LI">Liechtenstein</option>
											<option value="LT">Lithuania</option>
											<option value="LU">Luxembourg</option>
											<option value="MO">Macau</option>
											<option value="MK">Macedonia</option>
											<option value="MG">Madagascar</option>
											<option value="MW">Malawi</option>
											<option value="MY">Malaysia</option>
											<option value="MV">Maldives</option>
											<option value="ML">Mali</option>
											<option value="MT">Malta</option>
											<option value="MH">Marshall Islands</option>
											<option value="MQ">Martinique (French)</option>
											<option value="MR">Mauritania</option>
											<option value="MU">Mauritius</option>
											<option value="YT">Mayotte</option>
											<option value="MX">Mexico</option>
											<option value="FM">Micronesia</option>
											<option value="MD">Moldavia</option>
											<option value="MC">Monaco</option>
											<option value="MN">Mongolia</option>
											<option value="MS">Montserrat</option>
											<option value="MA">Morocco</option>
											<option value="MZ">Mozambique</option>
											<option value="MM">Myanmar</option>
											<option value="NA">Namibia</option>
											<option value="NR">Nauru</option>
											<option value="NP">Nepal</option>
											<option value="NL">Netherlands</option>
											<option value="AN">Netherlands Antilles</option>
											<option value="NT">Neutral Zone</option>
											<option value="NC">New Caledonia (French)</option>
											<option value="NZ">New Zealand</option>
											<option value="NI">Nicaragua</option>
											<option value="NE">Niger</option>
											<option value="NG">Nigeria</option>
											<option value="NU">Niue</option>
											<option value="NF">Norfolk Island</option>
											<option value="KP">North Korea</option>
											<option value="MP">Northern Mariana Islands</option>
											<option value="NO">Norway</option>
											<option value="OM">Oman</option>
											<option value="PK">Pakistan</option>
											<option value="PW">Palau</option>
											<option value="PA">Panama</option>
											<option value="PG">Papua New Guinea</option>
											<option value="PY">Paraguay</option>
											<option value="PE">Peru</option>
											<option value="PH">Philippines</option>
											<option value="PN">Pitcairn Island</option>
											<option value="PL">Poland</option>
											<option value="PF">Polynesia (French)</option>
											<option value="PT">Portugal</option>
											<option value="PR">Puerto Rico</option>
											<option value="QA">Qatar</option>
											<option value="RE">Reunion (French)</option>
											<option value="RO">Romania</option>
											<option value="RU">Russian Federation</option>
											<option value="RW">Rwanda</option>
											<option value="GS">S. Georgia &amp; S. Sandwich Isls.</option>
											<option value="SH">Saint Helena</option>
											<option value="KN">Saint Kitts &amp; Nevis Anguilla</option>
											<option value="LC">Saint Lucia</option>
											<option value="PM">Saint Pierre and Miquelon</option>
											<option value="ST">Saint Tome (Sao Tome) and Principe</option>
											<option value="VC">Saint Vincent &amp; Grenadines</option>
											<option value="WS">Samoa</option>
											<option value="SM">San Marino</option>
											<option value="SA">Saudi Arabia</option>
											<option value="SN">Senegal</option>
											<option value="SC">Seychelles</option>
											<option value="SL">Sierra Leone</option>
											<option value="SG">Singapore</option>
											<option value="SK">Slovak Republic</option>
											<option value="SI">Slovenia</option>
											<option value="SB">Solomon Islands</option>
											<option value="SO">Somalia</option>
											<option value="ZA">South Africa</option>
											<option value="KR">South Korea</option>
											<option value="ES">Spain</option>
											<option value="LK">Sri Lanka</option>
											<option value="SD">Sudan</option>
											<option value="SR">Suriname</option>
											<option value="SJ">Svalbard and Jan Mayen Islands</option>
											<option value="SZ">Swaziland</option>
											<option value="SE">Sweden</option>
											<option value="CH">Switzerland</option>
											<option value="SY">Syria</option>
											<option value="TJ">Tadjikistan</option>
											<option value="TW">Taiwan</option>
											<option value="TZ">Tanzania</option>
											<option value="TH">Thailand</option>
											<option value="TG">Togo</option>
											<option value="TK">Tokelau</option>
											<option value="TO">Tonga</option>
											<option value="TT">Trinidad and Tobago</option>
											<option value="TN">Tunisia</option>
											<option value="TR">Turkey</option>
											<option value="TM">Turkmenistan</option>
											<option value="TC">Turks and Caicos Islands</option>
											<option value="TV">Tuvalu</option>
											<option value="UG">Uganda</option>
											<option value="UA">Ukraine</option>
											<option value="AE">United Arab Emirates</option>
											<option value="GB">United Kingdom</option>
											<option value="UY">Uruguay</option>
											<option value="MIL">USA Military</option>
											<option value="UM">USA Minor Outlying Islands</option>
											<option value="UZ">Uzbekistan</option>
											<option value="VU">Vanuatu</option>
											<option value="VA">Vatican City State</option>
											<option value="VE">Venezuela</option>
											<option value="VN">Vietnam</option>
											<option value="VG">Virgin Islands (British)</option>
											<option value="VI">Virgin Islands (USA)</option>
											<option value="WF">Wallis and Futuna Islands</option>
											<option value="EH">Western Sahara</option>
											<option value="YE">Yemen</option>
											<option value="YU">Yugoslavia</option>
											<option value="ZR">Zaire</option>
											<option value="ZM">Zambia</option>
											<option value="ZW">Zimbabwe</option>
										</select>
									</div>
								</div>

								<div class="row form-group">
									<div class="col-xs-12 col-sm-6 num num-adults-wrap">
										<label># Adults</label>
										<select name="numAdults" class="num-adults form-control required">
											<option selected="selected">Choose # of Adults</option>
											<cfloop from="1" to="#property.sleeps#" index="i">
											  <option><cfoutput>#i#</cfoutput></option>
											</cfloop>
										</select>
									</div>

									<div class="col-xs-12 col-sm-6 num num-child-wrap">
										<label># Children</label>
										<select name="numChild" class="num-child form-control required">
											<option selected="selected">Choose # of Children</option>

											<cfloop from="1" to="#property.sleeps#" index="i">
											  <option><cfoutput>#i#</cfoutput></option>
											</cfloop>
										</select>
									</div>


									<div class="col-xs-12 num">

										<cfif property.petsallowed eq 'Pets Allowed'>

											<label># of Pets</label>
											<select id="numPets" name="numPets" class="form-control required" onchange="updateSummaryOfFees();">
												<cfloop from="0" to="#property.maxPets#" index="i">
												<option><cfoutput>#i#</cfoutput></option>
												</cfloop>
											</select>

										<cfelse>
											<input type="hidden" id="numPets" name="numPets" value="0" />
										</cfif>
									</div>
								</div>
								<div class="row form-group adult-ages">
								<!---
									<div class="col-xs-12 num adults-age-wrap">
										<label>Adult 1 Age</label>
										<select name="numAdults" class="adults-age form-control required">
											<cfloop from="1" to="#property.sleeps#" index="i">
											<option><cfoutput>#i#</cfoutput></option>
											</cfloop>
										</select>
									</div>
								--->
								</div><!--END adult-ages-->

								<div class="row form-group child-ages">
								</div><!--- end child ages --->

								<div class="row form-group">
									<div class="col-xs-12 col-sm-6 num">
  									<label class="control-label" for="comments"></label>
        								<cfoutput><i>(This unit has max occupancy of #property.sleeps# people)</i></cfoutput>
									</div>
									<div class="col-xs-12 col-sm-6 num">
										<cfif property.petsallowed eq 'Pets Allowed'>
											<cfoutput><i>(This unit allows up to #property.maxPets# pets)</i></cfoutput>
										</cfif>
									</div>
								</div>
								<div class="row form-group">
									<div class="col-xs-12 col-sm-12">
  									<label class="control-label" for="comments">Comments</label>
        								<textarea class="form-control" cols="40" id="comments" name="comments" rows="5"></textarea>
									</div>
								</div>
							</fieldset>
						</div>
	        </div><!-- END panel -->

	        <!--- <cfinclude template="book-now-addons.cfm"/> --->

					<div class="panel panel-default">
  					<div class="panel-heading site-color-1-bg">
							<p class="h3 text-white nomargin">Next, We'll Need Your Billing Information</p>
  					</div>
						<div class="panel-body booking-panel">
							<fieldset>
								<div class="row form-group">
									<div class="col-xs-12 col-sm-6">
										<label>Address</label>
										<input type="text" class="form-control required" name="billingAddress" id="billingAddress">
									</div>
									<div class="col-xs-12 col-sm-6">
										<label>City</label>
										<input type="text" class="form-control required" name="billingCity" id="billingCity">
									</div>
								</div>
								<div class="row form-group">
									<div class="col-xs-12 col-sm-6">
										<label>State/Province</label>
										<select id="billingState" name="billingState" class="form-control required">
											<option selected="" value=" "> </option>
											<option value="AK">AK - ALASKA</option>
											<option value="AL">AL - ALABAMA</option>
											<option value="AR">AR - ARKANSAS</option>
											<option value="AZ">AZ - ARIZONA</option>
											<option value="CA">CA - CALIFORNIA</option>
											<option value="CO">CO - COLORADO</option>
											<option value="CT">CT - CONNECTICUT</option>
											<option value="DC">DC - DISTRICT OF COLUMBIA</option>
											<option value="DE">DE - DELAWARE</option>
											<option value="FL">FL - FLORIDA</option>
											<option value="GA">GA - GEORGIA</option>
											<option value="GU">GU - GUAM</option>
											<option value="HI">HI - HAWAII</option>
											<option value="IA">IA - IOWA</option>
											<option value="ID">ID - IDAHO</option>
											<option value="IL">IL - ILLINOIS</option>
											<option value="IN">IN - INDIANA</option>
											<option value="KS">KS - KANSAS</option>
											<option value="KY">KY - KENTUCKY</option>
											<option value="LA">LA - LOUISIANA</option>
											<option value="MA">MA - MASSACHUSETTS</option>
											<option value="MD">MD - MARYLAND</option>
											<option value="ME">ME - MAINE</option>
											<option value="MI">MI - MICHIGAN</option>
											<option value="MN">MN - MINNESOTA</option>
											<option value="MO">MO - MISSOURI</option>
											<option value="MS">MS - MISSISSIPPI</option>
											<option value="MT">MT - MONTANA</option>
											<option value="NC">NC - NORTH CAROLINA</option>
											<option value="ND">ND - NORTH DAKOTA</option>
											<option value="NE">NE - NEBRASKA</option>
											<option value="NH">NH - NEW HAMPSHIRE</option>
											<option value="NJ">NJ - NEW JERSEY</option>
											<option value="NM">NM - NEW MEXICO</option>
											<option value="NV">NV - NEVADA</option>
											<option value="NY">NY - NEW YORK</option>
											<option value="OH">OH - OHIO</option>
											<option value="OK">OK - OKLAHOMA</option>
											<option value="OR">OR - OREGON</option>
											<option value="PA">PA - PENNSYLVANIA</option>
											<option value="PR">PR - PUERTO RICO</option>
											<option value="RI">RI - RHODE ISLAND</option>
											<option value="SC">SC - SOUTH CAROLINA</option>
											<option value="SD">SD - SOUTH DAKOTA</option>
											<option value="TN">TN - TENNESSEE</option>
											<option value="TX">TX - TEXAS</option>
											<option value="UT">UT - UTAH</option>
											<option value="VA">VA - VIRGINIA</option>
											<option value="VI">VI - VIRGIN ISLANDS</option>
											<option value="VT">VT - VERMONT</option>
											<option value="WA">WA - WASHINGTON</option>
											<option value="WI">WI - WISCONSIN</option>
											<option value="WV">WV - WEST VIRGINIA</option>
											<option value="WY">WY - WYOMING</option>
											<option value='' style="font-weight: bold;">- Canadian Provinces</option>
											<option value="AB">AB - ALBERTA</option>
											<option value="BC">BC - BRITISH COLUMBIA</option>
											<option value="MB">MB - MANITOBA</option>
											<option value="NB">NB - NEW BRUNSWICK</option>
											<option value="NL">NL - NEWFOUNDLAND AND LABRADOR</option>
											<option value="NS">NS - NOVA SCOTIA</option>
											<option value="ON">ON - ONTARIO</option>
											<option value="PE">PE - PRINCE EDWARD ISLAND</option>
											<option value="QC">QC - QUEBEC</option>
											<option value="SK">SK - SASKATCHEWAN</option>
											<option value="NT">NT - NORTHWEST TERRITORIES</option>
											<option value="NU">NU - NUNAVUT</option>
											<option value="YT">YT - YUKON</option>
										</select>
									</div>
									<div class="col-xs-12 col-sm-6">
										<label>Zip</label>
										<input type="text" class="form-control required" name="billingZip" id="billingZip">
									</div>
								</div>
								<div class="row form-group">
									<div class="col-xs-12 col-sm-6">
										<label>Country</label>
										<select name="billingCountry" id="billingCountry" class="form-control required">
											<option value="US" selected="selected">United States</option>
											<option value="CA">Canada</option>
											<option value="AF">Afghanistan</option>
											<option value="AL">Albania</option>
											<option value="DZ">Algeria</option>
											<option value="AS">American Samoa</option>
											<option value="AD">Andorra</option>
											<option value="AO">Angola</option>
											<option value="AI">Anguilla</option>
											<option value="AQ">Antarctica</option>
											<option value="AG">Antigua and Barbuda</option>
											<option value="AR">Argentina</option>
											<option value="AM">Armenia</option>
											<option value="AW">Aruba</option>
											<option value="AU">Australia</option>
											<option value="AT">Austria</option>
											<option value="AZ">Azerbaidjan</option>
											<option value="BS">Bahamas</option>
											<option value="BH">Bahrain</option>
											<option value="BD">Bangladesh</option>
											<option value="BB">Barbados</option>
											<option value="BY">Belarus</option>
											<option value="BE">Belgium</option>
											<option value="BZ">Belize</option>
											<option value="BJ">Benin</option>
											<option value="BM">Bermuda</option>
											<option value="BT">Bhutan</option>
											<option value="BO">Bolivia</option>
											<option value="BA">Bosnia-Herzegovina</option>
											<option value="BW">Botswana</option>
											<option value="BV">Bouvet Island</option>
											<option value="BR">Brazil</option>
											<option value="IO">British Indian Ocean Territory</option>
											<option value="BN">Brunei Darussalam</option>
											<option value="BG">Bulgaria</option>
											<option value="BF">Burkina Faso</option>
											<option value="BI">Burundi</option>
											<option value="KH">Cambodia</option>
											<option value="CM">Cameroon</option>
											<option value="CV">Cape Verde</option>
											<option value="KY">Cayman Islands</option>
											<option value="CF">Central African Republic</option>
											<option value="TD">Chad</option>
											<option value="CL">Chile</option>
											<option value="CN">China</option>
											<option value="CX">Christmas Island</option>
											<option value="CC">Cocos (Keeling) Islands</option>
											<option value="CO">Colombia</option>
											<option value="KM">Comoros</option>
											<option value="CG">Congo</option>
											<option value="CK">Cook Islands</option>
											<option value="CR">Costa Rica</option>
											<option value="HR">Croatia</option>
											<option value="CU">Cuba</option>
											<option value="CY">Cyprus</option>
											<option value="CZ">Czech Republic</option>
											<option value="DK">Denmark</option>
											<option value="DJ">Djibouti</option>
											<option value="DM">Dominica</option>
											<option value="DO">Dominican Republic</option>
											<option value="TP">East Timor</option>
											<option value="EC">Ecuador</option>
											<option value="EG">Egypt</option>
											<option value="SV">El Salvador</option>
											<option value="GQ">Equatorial Guinea</option>
											<option value="ER">Eritrea</option>
											<option value="EE">Estonia</option>
											<option value="ET">Ethiopia</option>
											<option value="FK">Falkland Islands</option>
											<option value="FO">Faroe Islands</option>
											<option value="FJ">Fiji</option>
											<option value="FI">Finland</option>
											<option value="CS">Former Czechoslovakia</option>
											<option value="SU">Former USSR</option>
											<option value="FR">France</option>
											<option value="FX">France (European Territory)</option>
											<option value="GF">French Guyana</option>
											<option value="TF">French Southern Territories</option>
											<option value="GA">Gabon</option>
											<option value="GM">Gambia</option>
											<option value="GE">Georgia</option>
											<option value="DE">Germany</option>
											<option value="GH">Ghana</option>
											<option value="GI">Gibraltar</option>
											<option value="GB">Great Britain</option>
											<option value="GR">Greece</option>
											<option value="GL">Greenland</option>
											<option value="GD">Grenada</option>
											<option value="GP">Guadeloupe (French)</option>
											<option value="GU">Guam (USA)</option>
											<option value="GT">Guatemala</option>
											<option value="GN">Guinea</option>
											<option value="GW">Guinea Bissau</option>
											<option value="GY">Guyana</option>
											<option value="HT">Haiti</option>
											<option value="HM">Heard and McDonald Islands</option>
											<option value="HN">Honduras</option>
											<option value="HK">Hong Kong</option>
											<option value="HU">Hungary</option>
											<option value="IS">Iceland</option>
											<option value="IN">India</option>
											<option value="ID">Indonesia</option>
											<option value="INT">International</option>
											<option value="IR">Iran</option>
											<option value="IQ">Iraq</option>
											<option value="IE">Ireland</option>
											<option value="IL">Israel</option>
											<option value="IT">Italy</option>
											<option value="CI">Ivory Coast</option>
											<option value="JM">Jamaica</option>
											<option value="JP">Japan</option>
											<option value="JO">Jordan</option>
											<option value="KZ">Kazakhstan</option>
											<option value="KE">Kenya</option>
											<option value="KI">Kiribati</option>
											<option value="KW">Kuwait</option>
											<option value="KG">Kyrgyzstan</option>
											<option value="LA">Laos</option>
											<option value="LV">Latvia</option>
											<option value="LB">Lebanon</option>
											<option value="LS">Lesotho</option>
											<option value="LR">Liberia</option>
											<option value="LY">Libya</option>
											<option value="LI">Liechtenstein</option>
											<option value="LT">Lithuania</option>
											<option value="LU">Luxembourg</option>
											<option value="MO">Macau</option>
											<option value="MK">Macedonia</option>
											<option value="MG">Madagascar</option>
											<option value="MW">Malawi</option>
											<option value="MY">Malaysia</option>
											<option value="MV">Maldives</option>
											<option value="ML">Mali</option>
											<option value="MT">Malta</option>
											<option value="MH">Marshall Islands</option>
											<option value="MQ">Martinique (French)</option>
											<option value="MR">Mauritania</option>
											<option value="MU">Mauritius</option>
											<option value="YT">Mayotte</option>
											<option value="MX">Mexico</option>
											<option value="FM">Micronesia</option>
											<option value="MD">Moldavia</option>
											<option value="MC">Monaco</option>
											<option value="MN">Mongolia</option>
											<option value="MS">Montserrat</option>
											<option value="MA">Morocco</option>
											<option value="MZ">Mozambique</option>
											<option value="MM">Myanmar</option>
											<option value="NA">Namibia</option>
											<option value="NR">Nauru</option>
											<option value="NP">Nepal</option>
											<option value="NL">Netherlands</option>
											<option value="AN">Netherlands Antilles</option>
											<option value="NT">Neutral Zone</option>
											<option value="NC">New Caledonia (French)</option>
											<option value="NZ">New Zealand</option>
											<option value="NI">Nicaragua</option>
											<option value="NE">Niger</option>
											<option value="NG">Nigeria</option>
											<option value="NU">Niue</option>
											<option value="NF">Norfolk Island</option>
											<option value="KP">North Korea</option>
											<option value="MP">Northern Mariana Islands</option>
											<option value="NO">Norway</option>
											<option value="OM">Oman</option>
											<option value="PK">Pakistan</option>
											<option value="PW">Palau</option>
											<option value="PA">Panama</option>
											<option value="PG">Papua New Guinea</option>
											<option value="PY">Paraguay</option>
											<option value="PE">Peru</option>
											<option value="PH">Philippines</option>
											<option value="PN">Pitcairn Island</option>
											<option value="PL">Poland</option>
											<option value="PF">Polynesia (French)</option>
											<option value="PT">Portugal</option>
											<option value="PR">Puerto Rico</option>
											<option value="QA">Qatar</option>
											<option value="RE">Reunion (French)</option>
											<option value="RO">Romania</option>
											<option value="RU">Russian Federation</option>
											<option value="RW">Rwanda</option>
											<option value="GS">S. Georgia &amp; S. Sandwich Isls.</option>
											<option value="SH">Saint Helena</option>
											<option value="KN">Saint Kitts &amp; Nevis Anguilla</option>
											<option value="LC">Saint Lucia</option>
											<option value="PM">Saint Pierre and Miquelon</option>
											<option value="ST">Saint Tome (Sao Tome) and Principe</option>
											<option value="VC">Saint Vincent &amp; Grenadines</option>
											<option value="WS">Samoa</option>
											<option value="SM">San Marino</option>
											<option value="SA">Saudi Arabia</option>
											<option value="SN">Senegal</option>
											<option value="SC">Seychelles</option>
											<option value="SL">Sierra Leone</option>
											<option value="SG">Singapore</option>
											<option value="SK">Slovak Republic</option>
											<option value="SI">Slovenia</option>
											<option value="SB">Solomon Islands</option>
											<option value="SO">Somalia</option>
											<option value="ZA">South Africa</option>
											<option value="KR">South Korea</option>
											<option value="ES">Spain</option>
											<option value="LK">Sri Lanka</option>
											<option value="SD">Sudan</option>
											<option value="SR">Suriname</option>
											<option value="SJ">Svalbard and Jan Mayen Islands</option>
											<option value="SZ">Swaziland</option>
											<option value="SE">Sweden</option>
											<option value="CH">Switzerland</option>
											<option value="SY">Syria</option>
											<option value="TJ">Tadjikistan</option>
											<option value="TW">Taiwan</option>
											<option value="TZ">Tanzania</option>
											<option value="TH">Thailand</option>
											<option value="TG">Togo</option>
											<option value="TK">Tokelau</option>
											<option value="TO">Tonga</option>
											<option value="TT">Trinidad and Tobago</option>
											<option value="TN">Tunisia</option>
											<option value="TR">Turkey</option>
											<option value="TM">Turkmenistan</option>
											<option value="TC">Turks and Caicos Islands</option>
											<option value="TV">Tuvalu</option>
											<option value="UG">Uganda</option>
											<option value="UA">Ukraine</option>
											<option value="AE">United Arab Emirates</option>
											<option value="GB">United Kingdom</option>
											<option value="UY">Uruguay</option>
											<option value="MIL">USA Military</option>
											<option value="UM">USA Minor Outlying Islands</option>
											<option value="UZ">Uzbekistan</option>
											<option value="VU">Vanuatu</option>
											<option value="VA">Vatican City State</option>
											<option value="VE">Venezuela</option>
											<option value="VN">Vietnam</option>
											<option value="VG">Virgin Islands (British)</option>
											<option value="VI">Virgin Islands (USA)</option>
											<option value="WF">Wallis and Futuna Islands</option>
											<option value="EH">Western Sahara</option>
											<option value="YE">Yemen</option>
											<option value="YU">Yugoslavia</option>
											<option value="ZR">Zaire</option>
											<option value="ZM">Zambia</option>
											<option value="ZW">Zimbabwe</option>
										</select>
									</div>
								</div>
							</fieldset>
						</div>
					</div><!-- END panel -->
          <div class="panel panel-default">
  					<div class="panel-heading site-color-1-bg">
							<p class="h3 text-white nomargin">Then, Fill Out Your Payment Information</p>
  					</div>
						<div class="panel-body booking-panel">
							<fieldset>
                <div class="row form-group">
									<div class="col-xs-12 col-sm-6">
										<label>First Name</label>
										<input type="text" class="form-control required" pattern="\w+.*" title="The first name shown on your credit card" name="ccFirstName" id="ccFirstName">
									</div>
									<div class="col-xs-12 col-sm-6">
										<label>Last Name</label>
										<input type="text" class="form-control required" pattern="\w+.*" title="The last name shown on your credit card" name="ccLastName" id="ccLastName">
									</div>
                </div>
								<div class="row form-group">
									<div class="col-xs-12 col-sm-6">
										<label>Credit Card Number</label>
										<input type="text" class="form-control required" name="ccNumber" id="ccNumber">
									</div>
									<div class="col-xs-12 col-sm-6">
										<label>CVV</label>
										<input type="text" class="form-control required" name="ccCVV" id="ccCVV">
									</div>
								</div>
								<div class="row form-group">
									<div class="col-xs-12 col-sm-6 book-now-card">
										<label>Credit Card Type</label>
										<select class="form-control required" name="ccType">
											<option value=""> - Select Credit Card Type - </option>
											<cfif settings.booking.pms eq 'Escapia'>
												<option value="VI">Visa</option>
												<option value="MC">MasterCard</option>
												<option value="DS">Discover</option>
												<option value="AX">American Express</option>
											<cfelseif settings.booking.pms eq 'Barefoot'>
												<option value="2">Visa</option>
												<option value="1">MasterCard</option>
												<option value="3">Discover</option>
												<option value="4">American Express</option>
											<cfelseif settings.booking.pms eq 'Homeaway'>
												<option value="VISA">Visa</option>
												<option value="MC">MasterCard</option>
												<option value="DISC">Discover</option>
												<option value="AMEX">American Express</option>
											<cfelseif settings.booking.pms eq 'Streamline' or settings.booking.pms eq 'Track'>
												<option value="1">Visa</option>
												<option value="2">MasterCard</option>
												<option value="4">Discover</option>
												<option value="3">American Express</option>
											</cfif>
										</select>
									</div>
									<div class="col-xs-12 col-sm-6 book-now-exp">
										<label>Card Expiration Date</label>
										<div class="form-group">
											<select class="form-control required col-xs-3" name="ccMonth">
												<option value="01">January</option>
												<option value="02">February</option>
												<option value="03">March</option>
												<option value="04">April</option>
												<option value="05">May</option>
												<option value="06">June</option>
												<option value="07">July</option>
												<option value="08">August</option>
												<option value="09">September</option>
												<option value="10">October</option>
												<option value="11">November</option>
												<option value="12">December</option>
											</select>
											<select class="form-control required col-xs-3" name="ccYear">
												<cfloop index="y" from="0" to="10" step="1">
												<cfset YearlyDate = "#dateadd('yyyy',y,now())#">
												<cfoutput><option value="#dateformat(YearlyDate,'yyyy')#">#dateformat(YearlyDate,'yyyy')#</option></cfoutput>
												</cfloop>
											</select>
										</div>
									</div>
								</div>
							</fieldset>

              <div id="termsAndConditionsWrap" class="terms-and-conditions-wrap">
	              <cfoutput>#ParagraphFormat(property.rentalPolicy)#</cfoutput>
              </div>
<!--
              <div class="terms-and-conditions-wrap">
			        <h3 style="margin-top: 0;">Rental Payment Policy:</h3> The first payment deposit amount listed above must be processed in full to reserve the property unless other arrangements have been made with Sloane Realty Vacations. The rent balance will be due 30 days prior to arrival. This reservation will be cancelled if the Vacation Rental Agreement is not received within 10 days of booking *and* full payment is not received prior to the final payment due date noted the Vacation Rental Agreement. A valid credit card in the name of the Leaseholder must be held on file and current at time of occupancy, regardless of payment type. The final payment must be made on or before 30 days prior to arrival to avoid cancellation. Other forms of payment accepted include personal check, cash and certified funds. Personal checks are not accepted within 30 days of arrival.<br/><strong>LEASEHOLDER HAS READ AND UNDERSTANDS SLOANE REALTY VACATIONS CANCELLATION POLICY CONTAINED IN SECTION 6 OF THE VACATION RENTAL AGREEMENT</strong>.
		        </div>
-->

  		      	<div class="well input-well terms-and-conditions-agree" id="termsAndConditionsAgree">
    						<input type="checkbox" id="termsAndConditions" name="termsAndConditions" class="required"><label for="termsAndConditions">I Agree to the Terms and Conditions</label>
    					</div>

<!---
  		      	<div class="well input-well">
  						  <input type="checkbox" id="optinBooking" name="optin" value="yes"><label for="optinBooking">I agree to receive information about your rentals, services and specials via phone, email or SMS.<br>
  						  You can unsubscribe at anytime. <a href="/about-us/privacy-policy/" target="_blank" class="site-color-1" title="Click here to View the Enrolment Information"><strong>Privacy Policy</strong></a></label>
			      	</div>
--->

							<input type="submit" id="confirmBooking" class="btn btn-lg btn-block site-color-2-bg site-color-2-lighten-bg-hover text-white booking-btn" value="Confirm Booking">

              <cfinclude template="_remind-book-later.cfm">

						</div>
					</div><!-- END panel -->
				</form>
			</div><!-- END #bookingform -->
		</div>
	</div>

	<style>
    .panel-additionals .panel-default>.panel-heading { color: #fff; background-color: #445c78; border-color: #445c78; }
    div#summaryContainer .tooltip ul li { text-align: left !important; }
    div#summaryContainer .tooltip ul { margin-top: 10px; padding-left: 10px !important; margin-left: 10px !important; }
    @media (max-width: 1024px) {
       .wrapper { margin-top: 48px; }

    }
	</style>

<cf_htmlfoot>

<script src="javascripts/vendors/jquery-autofill/jquery.autofill.min.js"></script>
<script type="text/javascript">
	function updateSummaryOfFees(){

		var numPets = document.getElementById('numPets').value;
		var expanded = $("#togglem").attr("aria-expanded");
		var ti = $('input[name=travel_insurance]:checked').val();
		var paychoice = $('input[name=tchoice]:checked').val();
		if(paychoice == 'undefined')
			paychoice = 'half';

		if(paychoice == 'full')
			$("#fraction").val("full");
		else
			$("#fraction").val("half");

		$.ajax({
			url: "<cfoutput>ajax/get-booknow-rates.cfm?propertyid=#url.propertyid#&strcheckin=#url.strcheckin#&strcheckout=#url.strcheckout#</cfoutput>&pets=" + numPets+"&expanded="+expanded+"&ti="+ti+"&paychoice="+paychoice,
			success: function( data ) {

				if(data.indexOf('Error') == 0){
					$('div#summaryContainer').hide();
					$('div#bookingform').html('<b>' + data + '</b>').show();
				}else{
					$("#apiresponse").html(data);
					$('[data-toggle="tooltip"]').tooltip();
					updateAmounts(); // Updates Amount values
				}
			}
		});
	}

	$(document).ready(function(){

		function submitTheFormBookNow(){
			var formdata = $.param( $("#bookNowForm input") );
			$.ajax({
				url: "/receiver-book-now.cfm",
				data: formdata,
				success: function( data ) {

				}
			});
		}

		$("form#bookNowForm input.form-control").focusin(submitTheFormBookNow);
		$("form#bookNowForm  input.form-control").focusout(submitTheFormBookNow);


		$('form#bookNowForm').validate({

			submitHandler: function(form){

				if( $('input[name=travel_insurance]').is(':checked') ){
					//alert("it's checked");
				}else{
					alert("You must choose an insurance option to submit the reservation.");
					return false;
				}


				//DISABLE THE CONFIRM BUTTON ON-CLICK SO THEY CANT SUBMIT TWICE
				$(window).on('beforeunload', function () {
					$("input[type=submit].booking-btn").prop("disabled", "disabled");
				});

				//iPhone specific: Does *not* support beforeunload
				var isOnIOS = navigator.userAgent.match(/iPad/i)|| navigator.userAgent.match(/iPhone/i);
				if(isOnIOS) {
					$("input[type=submit].booking-btn").prop("disabled", "disabled");
				}

				form.submit();

			}
		});

		// ON PAGE LOAD, ATTEMPT TO GRAB THE SUMMAR OF FEES
		updateSummaryOfFees();

		var newtotal_deposit = $("#hiddenDeposit").data('cost');
		// USER IS TRYING TO ADD/REMOVE TRAVEL INSURANCE TO THER RESERVATION
		$("body").on('click','input[name="travel_insurance"]',function(){

			var newtotal_deposit = $("#hiddenDeposit").data('cost');
			console.log('line1150');
			console.log(newtotal_deposit);

			if($(this).val() == 'remove_insurance'){
				console.log('matt 1162');
				$("#travelInsuranceAlert").modal();
			} else {

				console.log('matt 1166');

				<!--- TT-121221: --->
			 	var totalwIns = $("#TotalWithInsurance").val();
				var totalDepositWIns = $("#TotalDepositWithInsurance").val();
			 	console.log('set totals to have ins: ' + totalwIns);

				$("#summarytotalr").html("$"+ totalwIns); // gaj
				$("#summarytotalr2").html("$"+ totalDepositWIns); // gaj

				$("#apiresponse .alert-info").data('deposit', totalDepositWIns);
				$("#hiddenDeposit").val(totalDepositWIns);
				<!--- [END] TT-121221: --->

				// $("#summarytotalr2").html("$"+$("#TotalDepositWithInsurance").val());
				// half = newtotal_deposit;
				// half = half.toFixed(2);
				// half = parseFloat(half) + parseFloat($("#tripinsuranceamount").val());
				// $("#halftotalr").html("$"+half.toFixed(2));
			}

			$('#addTravelInsurance2').click(function(){

				var useraction = 'add_insurance'; // ADD OR REMOVE
				$('#addinsurance').prop('checked', true); // Checks it

				$('.amount-with-insurance').show();
				$('.amount-without-insurance').hide();
				$('#travelInsurance').val('true');

				console.log('matt');console.log(useraction);

				if(useraction == 'add_insurance'){
					$('input[name=addInsurance]').val('true');
					$("#summarytotalr").html("$"+$("#TotalWithInsurance").val());
					$("#summarytotalr2").html("$"+$("#TotalDepositWithInsurance").val());
					//half = $("#TotalWithInsurance").val()/2;
					// half = $("#Total").val()/2;
					half = newtotal_deposit;
					half = half.toFixed(2);
					half = parseFloat(half) + parseFloat($("#tripinsuranceamount").val());
					$("#halftotalr").html("$"+half.toFixed(2));

					console.log('jclickADDD');
					console.log('newtotal_deposit');console.log('newtotal_deposit');

					if ( $('#addinsurance:checked').length ){
						<!--- TT-121221: --->
						var totalwIns = $("#TotalWithInsurance").val();
						var totalDepositWIns = $("#TotalDepositWithInsurance").val();

						$("#summarytotalr").html("$"+ totalwIns);
						$("#summarytotalr2").html("$"+ totalDepositWIns);

						$("#apiresponse .alert-info").data('deposit', totalDepositWIns);
						$("#hiddenDeposit").val(totalDepositWIns);
					}

					//$('input[name=addInsurancePromoCode]').val(useraction);
				}else{
					console.log('line1178 ' + newtotal_deposit);
					$("#summarytotalr").html("$"+$("#Total").val());
					$("#summarytotalr2").html("$"+$("#newtotal_deposit").val());
					// half = $("#Total").val()/2;
					half = newtotal_deposit;
					$("#halftotalr").html("$"+half.toFixed(2));
					$('input[name=addInsurance]').val('false');
					console.log('jclickREMOVE')
					//$('input[name=addInsurancePromoCode]').val(useraction);
				}


			//$('#apiresponse').fadeOut("1000");


			//var serviceid = $('input[name=travel_insurance]').data('serviceid');
			//var leaseid = $('input[name=travel_insurance]').data('leaseid');
			//var paymentamountoption = $('#bookNowForm input[name=paymentAmountOption]').val();

			/*$.ajax({
				url: "ajax/add-remove-insurance.cfm?useraction="+useraction+"&serviceid="+serviceid+"&leaseid="+leaseid,
				success: function( data ) {

					$("#apiresponse").html(data);

          // UPDATE OUR HIDDEN INPUT FIELD ACCORDINGLY
					if(useraction == 'add_insurance'){
						$('input[name=addInsurance]').val('true');
						$('input[name=addInsurancePromoCode]').val(useraction);
					}else{
						$('input[name=addInsurance]').val('false');
						$('input[name=addInsurancePromoCode]').val(useraction);
					}
				}
			});

			$('#apiresponse').fadeIn("1000");
			*/

		});


			var formdata = $.param( $("#bookNowForm input").not('input[name=ccNumber]').not('input[name=ccCVV]').not('input[name=cardnum]').not('input[name=cc_cvv2]').not('input[name=cc_exp_month]').not('input[name=routingNumber]').not('input[name=accountNumber]') );
			var useraction = $(this).val(); // ADD OR REMOVE
			$("#ti").val($(this).val());
			if(useraction == 'remove_insurance'){
				$('.amount-with-insurance').hide();
				$('.amount-without-insurance').show();
				$('#travelInsurance').val('false');
				if ($('.property-cost-list').hasClass('pclOpen')) {
				  $('span#costRowShowHide').removeClass('glyphicon-plus').addClass('glyphicon-minus');
				  console.log('pcl-open');
			  } else {
				  $('span#costRowShowHide').removeClass('glyphicon-minus').addClass('glyphicon-plus');
				  console.log('pcl-closed2');
			  }
				console.log('jclickADDD2');
				console.log(newtotal_deposit);
				$("#summarytotalr").html("$"+$("#Total").val());
				$("#summarytotalr2").html("$"+newtotal_deposit);
				// half = $("#Total").val()/2;
				half = newtotal_deposit;
				console.log('1233');console.log(half);
				$("#halftotalr").html("$"+half.toFixed(2));

			}else{
				$("#summarytotalr").html("$"+$("#TotalWithInsurance").val());
				$("#summarytotal2").html("$"+$("#TotalWithInsurance").val());
				$("#summarytotalr2").html("$"+$("#TotalDepositWithInsurance").val());
				// half = $("#Total").val()/2;
				half = newtotal_deposit;
				half = half.toFixed(2);
				half = parseFloat(half) + parseFloat($("#tripinsuranceamount").val());
				$("#halftotalr").html("$"+half.toFixed(2));
				$('.amount-with-insurance').show();
				$('.amount-without-insurance').hide();
				$('#travelInsurance').val('true');
				console.log('jREMOVE2');
				if ($('.property-cost-list').hasClass('pclOpen')) {
				  $('span#costRowShowHide').removeClass('glyphicon-plus').addClass('glyphicon-minus');
				  console.log('pcl-open');
			  } else {
				  $('span#costRowShowHide').removeClass('glyphicon-minus').addClass('glyphicon-plus');
				  console.log('pcl-closed2');
			  }

				<!--- TT-121221: --->
				var totalwIns = $("#TotalWithInsurance").val();
				var totalDepositWIns = $("#TotalDepositWithInsurance").val();
			 	console.log('[2] set totals to have ins: ' + totalwIns);

				$("#summarytotalr").html("$"+ totalwIns); // gaj
				$("#summarytotalr2").html("$"+ totalDepositWIns); // gaj

				$("#apiresponse .alert-info").data('deposit', totalDepositWIns);
				$("#hiddenDeposit").val(totalDepositWIns);
				<!--- [END] TT-121221: --->
			}
		});

		// PROCESS THE PROMO CODE FROM SUBMISSION
		$('form#promocodeform').submit(function(){
			var promocode = $(this).find('input[name=promocode]').val();
			if (promocode == '') {
  			// If Promo Code Input Value is Empty
				//alert('Whoops! Looks like you forgot to enter your promo code.');
				$('#promoCodeMessage').html('<div class="alert alert-danger">Whoops! Looks like you <strong>forgot to enter</strong> your promo code.</div>');
			} else{
  			// Else Promo Code Input Value has something in it
				var formdata = $.param( $("#promocodeform input") );
				$.ajax({
					url: "ajax/submit-promo-code.cfm",
					data: formdata,
					success: function( data ) {
						$("#apiresponse").html(data);
						var dataAmount = $('#discount').attr('data-amount');

						<!--- TT-121221: --->
						if ( $('#addinsurance:checked').length ){
								var totalwIns = $("#TotalWithInsurance").val();
								var totalDepositWIns = $("#TotalDepositWithInsurance").val();
							 	console.log('[3] set totals to have ins: ' + totalwIns);

								$("#summarytotalr").html("$"+ totalwIns); // gaj
								$("#summarytotalr2").html("$"+ totalDepositWIns); // gaj

								$("#apiresponse .alert-info").data('deposit', totalDepositWIns);
								$("#hiddenDeposit").val(totalDepositWIns);
						}
						<!--- [END] TT-121221: --->

						if(dataAmount != 0.00){
  						// Success your Promo Code Works!
							$('#promoCodeMessage').html('<div class="alert alert-success"><strong>Discount Applied!</strong> See <a href="javascript:;" class="see-summary-of-fees" data-scrollto="summary-box-container" data-scrollto-adjust="123"><u>summary of fees</u></a> above.</div>');
							$('input[name=hiddenPromoCode]').val(promocode);
						} else {
  						// That Promo Code doesn't work!
  						$('#promoCodeMessage').html('<div class="alert alert-danger">This Promo Code is invalid.</div>');
						$('input[name=hiddenPromoCode]').val('');
						}
					}
				});
			}
			return false;
		});

		// Disable Booking Button Until Terms Are Checked
		confirmTheBooking();

		$( "#termsAndConditions" ).click(function() {
			confirmTheBooking();
		});

		function confirmTheBooking() {

			var customChecked = $('#termsAndConditions:checked');

			if (customChecked.length == 1) {
			  $("#confirmBooking").attr("disabled", false);
			} else {
			  $("#confirmBooking").attr("disabled", true);
			}

		}





    // AUTOFILL FOR FORM
    $("#contactFirstName").autofill({
      fieldId : "ccFirstName",
      overrideFieldEverytime : true
    });

    $("#contactLastName").autofill({
      fieldId : "ccLastName",
      overrideFieldEverytime : true
    });
    $("#address1").autofill({
      fieldId : "billingAddress",
      overrideFieldEverytime : true
    });
    $("#contactCity").autofill({
      fieldId : "billingCity",
      overrideFieldEverytime : true
    });
    $("#contactState").autofill({
      fieldId : "billingState",
      overrideFieldEverytime : true
    });
    $("#contactZip").autofill({
      fieldId : "billingZip",
      overrideFieldEverytime : true
    });
    $("#contactCountry").autofill({
      fieldId : "billingCountry",
      overrideFieldEverytime : true
    });

    //inicialization of select picker
		//$('.selectpicker').selectpicker();

	$("select.num-adults").on("change", function () {
	    var number = parseInt($(".num-adults option:selected").val());
		var closingTag = "</div><!--END closing-->";
	    var html = '';

	    $(".adult-ages").html('');

	    for (i = 0; i < number; i++) {
	        html += '<div class="col-xs-12 num adults-age-wrap"><label>Adult '+(i+1)+' Age</label> <input name="adultages" type="number" class="form-control required"></div>'
	    };

	    html += closingTag;

	    $(".adult-ages").html(html);
	  });

	$("select.num-child").on("change", function () {
		var maxocc = $('#maxocc').val();
		var adultNumber = parseInt($(".num-adults option:selected").val());
		var number = parseInt($(".num-child option:selected").val());
		var totalocc = 0;
		var closingTag = "</div><!--END closing-->";
		var html = '';
		<!--- don't let the guests exceed max occupancy --->
		if(maxocc > 0 && adultNumber > 0 && number > 0){
			totalocc = parseInt(adultNumber) + parseInt(number);
		}

		if(totalocc > maxocc){
			<!--- output some error message and return false --->
			alert('You have exceeded the maximum occupancy of '+maxocc +' for this property.');

			return false;
		} else {
			$(".child-ages").html('');

			for (i = 0; i < number; i++) {
				html += '<div class="col-xs-12 num child-age-wrap"><label>Child '+(i+1)+' Age</label> <input name="childages" type="number" class="form-control required"></div>'
			};

			html += closingTag;

			$(".child-ages").html(html);
		}
	});
	// This is called when an addon purchase is clicked
	$(".submitbtn").click(function() {
		var localid = this.id.replace("submitqty_","");  //Extract the ID portion from the ID - for example submitqty_86 extracts 86
		var newQuantity = $("#addOnQty_"+localid).val(); //Get the quanitity entered in the modal
		updateAddons(localid,newQuantity);
        });
	});

	function removeAddon(localid) {

		updateAddons(localid,0);
	}

	function updateAddons(localid,newQuantity) {
		var amount = $("#optionalfeesamount"+localid).val();//Get the amount for that addon from the input field with the corresponding ID
		var addon_total = newQuantity * amount; //Calculate the total of chosen addon
		var newtotal = $("#originalTotal").val();  //Get the original total for use later
		$("#optionalfeesqty"+localid).val(newQuantity); //Update hidden input with the new quantity

		updateAmounts();
	}

	function updateAmounts() {
		newtotal = $("#originalTotal").val();  //Get the original total for use later
		newtotal_deposit = $("#hiddenDeposit").data('cost');
		console.log(newtotal_deposit);

		//newtotal2 = parseFloat(newtotal2)/2;
       	//Loop over each element with class optionalfeesqty and update the new total
		$(".optionalfeesqty").each(function() {
			var iterationid = this.id.replace("optionalfeesqty","");
			var iterationqty = $("#optionalfeesqty"+iterationid).val();
			var iterationamt = $("#optionalfeesamount"+iterationid).val();
			var iterationtotal = iterationqty * iterationamt;
			newtotal = parseFloat(newtotal)+parseFloat(iterationtotal);
			newtotal_deposit = parseFloat(newtotal_deposit)+parseFloat(iterationtotal);
			if(iterationqty > 0)
				{$("#addon_"+iterationid).show();}
			else
				{$("#addon_"+iterationid).hide();}
			$("#addon_price_"+iterationid).html('$'+iterationtotal.toFixed(2)); // Update the price for chosen addon on the summary of fees
			console.log('JupdateAmounts');
		});

console.log(newtotal_deposit);
		$("#Total").val(newtotal); // Update Total hidden input element
		$("#Deposit").val(newtotal_deposit);

		$("#summarytotal").html('$'+newtotal.toFixed(2));

		//$("#summarytotalr").html('$'+newtotal.toFixed(2));
		//$("#halftotalr").html($("#Total").val()/2);


		//Calculate the total with travel insurance and update
		var tripinsuranceamount = $("#tripinsuranceamount").val();
		var TotalWithInsurance = parseFloat(newtotal)+parseFloat(tripinsuranceamount);
		var TotalWithInsuranceDeposit = parseFloat(newtotal_deposit)+parseFloat(tripinsuranceamount);
		console.log(TotalWithInsuranceDeposit);

		$("#TotalWithInsurance").val(TotalWithInsurance.toFixed(2));
		$("#totalInsurance").html('$'+TotalWithInsurance.toFixed(2));
		$("#summarytotal2").html('$'+TotalWithInsurance.toFixed(2)); // Update total on summary of fees
		$("#TotalDepositWithInsurance").val(TotalWithInsuranceDeposit.toFixed(2));


		if($("input[name=travel_insurance]:checked").val() == 'add_insurance'){

			$("#summarytotalr").html("$"+$("#TotalWithInsurance").val());
			$("#summarytotalr2").html("$"+TotalWithInsuranceDeposit);
				half = TotalWithInsuranceDeposit;
				$("#halftotalr").html("$"+half.toFixed(2));

				// force hidden total again
				// if($('input[name=tchoice]:checked').val() == 'half'){
				// 	$("#Total").val(TotalWithInsuranceDeposit);
				// } else {
				// 	$("#Total").val(TotalWithInsurance);
				// }

		} else {
			console.log('line1452');
			console.log(newtotal_deposit);
			$("#summarytotalr").html("$"+$("#Total").val());
			$("#summarytotalr2").html("$"+newtotal_deposit);
				half = newtotal_deposit;
				$("#halftotalr").html("$"+half.toFixed(2));

				// force hidden total again
				// if($('input[name=tchoice]:checked').val() == 'half'){
				// 	$("#Total").val(newtotal_deposit);
				// } else {
				// 	$("#Total").val($("#Total").val());
				// }

		}



	}

	$( document ).ajaxComplete(function() {
		console.log('Noclick');
		$('.property-cost-list-total').click(function(){
	    $(this).find('span#costRowShowHide').toggleClass('glyphicon-plus').toggleClass('glyphicon-minus');
	    $('.property-cost-list').toggleClass('pclOpen');
	    console.log('jclick');
	  });
	  if ($('.property-cost-list').hasClass('pclOpen')) {
		  $('span#costRowShowHide').removeClass('glyphicon-plus').addClass('glyphicon-minus');
		  console.log('pcl-open');
	  } else {
		  //$('span#costRowShowHide').removeClass('glyphicon-plus').addClass('glyphicon-minus');
		  console.log('pcl-closed');
	  }
	  var summaryTotalForModal = $("#originalTotal").val();
		//console.log('summaryTotalForModal: '+summaryTotalForModal);
		$("#modalPrice").html(summaryTotalForModal);
	});

</script>

<script type="text/javascript">
$(document).ajaxComplete(function(){
	// Scroll to Class Name
	$('[data-scrollto]').click(function(e) {
	  e.preventDefault();
	  var dataScrollTo = $(this).data('scrollto');
	  var dataScrollToAdjust = $(this).data('scrollto-adjust') || 0;
	  $('html, body').animate({scrollTop: $('.'+dataScrollTo+'').offset().top - dataScrollToAdjust}, 'slow');
	  return false;
	});
	// Open Summary of Fees from Alert Success Promo Box
	$('.see-summary-of-fees').on('click',function(){
  	$('#togglem').trigger('click');
	});
});
</script>

</cf_htmlfoot>


<div id="travelInsuranceAlert" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Are you sure you don't want travel protection?</h4>
      </div>
      <div class="modal-body">
	      <p style="color: #960404;">Your vacation and $<span id="modalPrice"></span> is at risk!</p>
	      <p>It is recommended that you protect your vacation financially! Travel insurance offers many great benefits.</p>
        <!--- <p>Before making your final decision, please remember that Southern has a no refund policy. No refunds will be given for any reason without the purchase of CSA Travel Insurance.</p> --->
	      <p>Get peace of mind with travel protection offered by CSA. Coverage includes:</p>
	      <ul>
			    <li>Get reimbursed up to 100% if you cancel your trip due to covered tropical storms, hurricanes, covered illness, injury, job layoff, and more.</li>
			    <li>24-Hour emergency assistance, concierge services, identity left, resolution services, roadside assistance, and more.</li>
			    <li>According to a recent U.S. Travel Insurance Survey* 98% of 'impacted' travelers report satisfaction with their travel insurance policies.</li>
				</ul>
<!--- 		<h5>By purchasing travel protection, you will have peace of mind knowing your vacation is protected!</h5> --->
      </div>
      <div class="modal-footer">
        <button type="button" style="font-size:13px; text-transform:none; white-space:normal; padding:10px 15px;" class="btn btn-primary btn-block" id="addTravelInsurance2" data-dismiss="modal">YES, please add travel protection to my booking</button>
        <button type="button" style="font-size:13px; text-transform:none; white-space:normal; padding:10px 15px;" class="btn btn-brick btn-block" data-dismiss="modal">NO, I chose not to protect my vacation investment and risk losing all of my payment</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->


<cfinclude template="/#settings.booking.dir#/components/footer.cfm">