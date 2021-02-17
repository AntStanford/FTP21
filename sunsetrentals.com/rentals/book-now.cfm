<cftry>

<cfif NOT isdefined('url.strCheckin')>Check-In not defined<cfabort></cfif>
<cfif NOT isdefined('url.strCheckout')>Check-Out not defined<cfabort></cfif>
<cfif isdefined('url.strcheckin') and !isValid('date',url.strcheckin)>Check-In date not valid.<cfabort></cfif>
<cfif isdefined('url.strcheckout') and !isValid('date',url.strcheckout)>Check-Out date not valid.<cfabort></cfif>
<cfif NOT isdefined('url.propertyid')><!---you are a bot--->Propertyid is required.<cfabort></cfif>

<!--- QUERY TO GET PROPERTY INFO --->
<cfset property = application.bookingObject.getProperty(url.propertyid)>

	<cfquery name="GetCMSTerms" dataSource="#settings.dsn#">
	  select terms from cms_terms
	</cfquery>

<cfinclude template="/#settings.booking.dir#/components/header.cfm">

<!---START: NEW CART ABANDOMENT FEATURE--->
<!---set the cookie b/c you made it to the booknow page--->
<cfcookie name="CartAbandonmentFooter" value="#url.propertyid#" expires="NEVER">
<cfcookie name="CartAbandonmentFooterCheckIn" value="#url.strCheckin#" expires="NEVER">
<cfcookie name="CartAbandonmentFooterCheckOut" value="#url.strCheckOut#" expires="NEVER">
<!---END: NEW CART ABANDONMENT FEATURE--->

	<div class="booking book-now container-fluid">

		<div class="row clearfix" style="padding-top:20px">
			<div class="col-md-12">
    		<cfif cgi.http_referer does not contain 'results.cfm'>
    			<!--- Only show the 'Back' button if the user came from the PDP --->
    			<cfoutput><a href="javascript:history.go(-1)" class="btn pull-right site-color-1-bg site-color-3-bg-hover text-white"><i class="fa fa-chevron-left"></i> Back</a></cfoutput>
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

								<div id="summaryContainer">

									<h3>Summary of Fees</h3>
									<div id="apiresponse"><img src="/images/layout/loader.gif"/></div> <!--- Here is where the summary of fees are loaded in via Ajax --->

									<hr>

									<form id="promocodeform">
										<cfoutput>
											<input type="hidden" name="propertyid" value="#url.propertyid#">
											<input type="hidden" name="strcheckin" value="#url.strcheckin#">
											<input type="hidden" name="strcheckout" value="#url.strcheckout#">
											<input type="hidden" name="addInsurancePromoCode" value="remove_insurance">
                                            <input type="hidden" name="petfeePromoCode" id="petfeePromoCode" value="">
										</cfoutput>
										<div class="input-group form-group">
											<label class="promo-code"><h3>Promo Code</h3></label>
											<input id="promocode" type="text" class="form-control" autocomplete="off" name="promocode" value=""><br />
											<input class="btn btn-sm site-color-2-bg text-white" type="submit" name="submit" value="Submit">
										</div>
									</form>

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

        <cfoutput>
				<form role="form" method="post" action="#settings.booking.bookingURL#/#settings.booking.dir#/book-now-confirm.cfm" id="bookNowForm" class="validate">

					<!--- These input fields are common to any PMS --->
					<input type="hidden" name="propertyId" id="propertyid" value="#url.propertyid#">
					<input type="hidden" name="propertyName" value="#property.name#">
					<input type="hidden" name="propertyCity" value="#property.city#">
					<input type="hidden" name="propertyState" value="#property.state#">
					<input type="hidden" name="strCheckin" id="strCheckin" value="#url.strCheckin#">
					<input type="hidden" name="strCheckout" id="strCheckout" value="#url.strCheckout#">
					<input type="hidden" name="hiddenPromoCode" value="">
					<input type="hidden" name="key" value="#cfid##cftoken#">
					<input type="hidden" name="TotalTotal" value="" id="TotalTotal">
					<input type="hidden" name="TotalTotalWithInsurance" value="" id="TotalTotalWithInsurance">
					<input type="hidden" name="Total" value="" id="Total">
					<input type="hidden" name="TotalWithInsurance" value="" id="TotalWithInsurance">
					<input type="hidden" name="travelInsurance" value="false" id="travelInsurance">
					<input type="hidden" name="tripinsuranceamount" value="" id="tripinsuranceamount">
					<input type="hidden" name="payHalf" id="payHalf" value="true">
		          	<input type="hidden" id="allAddOns" name="allAddOns" value="" />
		          	<input type="hidden" id="allAddOnsTotalValue" value="0" />	<!---TT 113353--->
		          	<!---
		          	<cfif ICNDeyesOnly>
		          		<input type="hidden" id="hasCarPassInput" name="hasCarPassInput" value="" />
		          	</cfif>
		          	--->
					</cfoutput>
				
					<div class="panel panel-default">
  					<div class="panel-heading site-color-1-bg">
							<p class="h3 text-white nomargin">First, We'll Need Your Contact Information</p>
  					</div>
						<div class="panel-body booking-panel">
							<fieldset>
							  <cfinclude template="_remind-book-later.cfm">
							  <br>
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
									<div class="col-xs-12 col-sm-6 num">
										<label># Visitors</label>
										<select name="numAdults" class="form-control required">
											<cfloop from="1" to="#property.sleeps#" index="i">
											<option><cfoutput>#i#</cfoutput></option>
											</cfloop>
										</select>
									</div>
									<div class="col-xs-12 col-sm-6 num">
										<cfif property.petsallowed eq 'Pets Allowed'>
											<label># of Pets</label>

											<select name="numPets" id="numPets" class="form-control required">
												<cfloop from="0" to="#property.maxPets#" index="i">
												<option><cfoutput>#i#</cfoutput></option>
												</cfloop>
											</select>
										</cfif>
									</div>
								</div>
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
								<!---
								<cfif ICNDeyesOnly>
									<cfif isDefined('cookie.carpass_maxQuantity')>
										<cfset cpmax = cookie.carpass_maxQuantity />
									<cfelse>
										<cfset cpmax = 0 />
									</cfif>

									<div class="row form-group carpass-div" style="display:none;">
										<div class="col-xs-12 col-sm-6">
											<label>Gate Pass</label>

											<p style="font-size: smaller;"><em>Your reservation comes with one pass; if you are bringing more than one car please select additional passes below.</em></p>
											
											<select name="numCarPass" id="numCarPass" class="form-control required">
												<option value="0" <cfif isDefined('url.carpass') and val( url.carpass ) eq 0>selected="selected"</cfif>>0</option>

												<cfloop from="1" to="#cpmax#" index="i">
													<cfoutput>
														<option value="#i#" <cfif isDefined('url.carpass') and val( url.carpass ) eq i>selected="selected"</cfif>>#i#</option>
													</cfoutput>
												</cfloop>
											</select>
										</div>
									</div>
								</cfif>
								--->
								<div class="row form-group">
									<div class="col-xs-12 col-sm-12">
  									<label class="control-label" for="comments">Comments</label>
        								<textarea class="form-control" cols="40" id="comments" name="comments" rows="5"></textarea>
									</div>
								</div>
							</fieldset>
						</div>
	        </div><!-- END panel -->
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
                <!---
                <div class="row form-group">
                  <div class="col-xd-12 col-sm-12">
                    <div class="alert alert-info" style="margin:0;">
                      We are currently experiencing an outage with the <b>American Express</b> portal - please call us direct at 1-800-276-8991 if you would like to pay with this method.
                    </div>
                  </div>
                </div>
                --->
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
				 	
				 	<cfoutput>#GetCMSTerms.terms#</cfoutput>
				 	
              </div>

  		      	<div class="well input-well terms-and-conditions-agree" id="termsAndConditionsAgree">
    						<input type="checkbox" id="termsAndConditions" name="termsAndConditions" class="required"><label for="termsAndConditions">I Agree to the <!---<a href="#termsAndConditionsAlert" data-toggle="modal">Terms and Conditions</a>--->Terms and Conditions</label>
    					</div>

  		      	<div class="well input-well">
  						  <input type="checkbox" id="optinBooking" name="optin" value="yes"><label for="optinBooking">I agree to receive information about your rentals, services and specials via phone, email or SMS.<br>
  						  You can unsubscribe at anytime. <a href="<cfoutput>https://#settings.website#</cfoutput>" target="_blank" class="site-color-1" title="Click here to View the Enrolment Information"><strong>Privacy Policy</strong></a></label>
			      	</div>

							<input type="submit" id="confirmBooking" class="btn btn-lg btn-block site-color-2-bg site-color-3-bg-hover text-white booking-btn" value="Confirm Booking">

						</div>
					</div><!-- END panel -->
				</form>
			</div><!-- END #bookingform -->
		</div>
	</div>

<cf_htmlfoot>
	<script src="javascripts/vendors/jquery-autofill/jquery.autofill.min.js"></script>

	<!---<cfif ICNDeyesOnly>
		<script type="text/javascript" src="javascripts/booknow.js"></script>
	<cfelse>--->
		<script type="text/javascript">
			$(document).ready(function(){
				$('form#bookNowForm').validate({
					submitHandler: function(form){
						if( $('input[name=travel_insurance]').is(':checked') ){
							//alert("it's checked");
						}else{
							alert("You must choose an insurance option to submit the reservation.");
							return false;
						}

						<!---//DISABLE THE CONFIRM BUTTON ON-CLICK SO THEY CANT SUBMIT TWICE--->
						$(window).on('beforeunload', function () {
							$("input[type=submit].booking-btn").prop("disabled", "disabled");
						});

						//iPhone specific: Does *not* support beforeunload
						var isOnIOS = navigator.userAgent.match(/iPad/i)|| navigator.userAgent.match(/iPhone/i);
						if(isOnIOS) {
							$("input[type=submit].booking-btn").prop("disabled", "disabled");
						}

						form.submit();

						$("input[type=submit].booking-btn").prop("disabled", "disabled");

					}
				});
				// ON PAGE LOAD, ATTEMPT TO GRAB THE SUMMAR OF FEES
				$.ajax({
					url: "<cfoutput>ajax/get-booknow-rates.cfm?propertyid=#url.propertyid#&strcheckin=#url.strcheckin#&strcheckout=#url.strcheckout#</cfoutput>",
					success: function( data ) {

						if(data.indexOf('Error') == 0){
							$('div#summaryContainer').hide();
							$('div#bookingform').html('<b>' + data + '</b>').show();
						}else{
							$("#apiresponse").html(data);
						}
					}
				});
	
				$('#numPets').change(function(){
					$('#apiresponse').fadeOut("1000");
					var pets = $(this).val();
					var addons = $('#allAddOns').val();

					var travelInsuranceSelected = '';
					var travelInsuranceNotSelected = $("input[id=removeinsurance]").is(":checked");
					travelInsuranceSelected = $("input[id=addinsurance]").is(":checked");

					if(!travelInsuranceSelected && !travelInsuranceNotSelected){
						travelInsuranceSelected = '';
					}


					$.ajax({
						url: "<cfoutput>ajax/get-booknow-rates.cfm?propertyid=#url.propertyid#&strcheckin=#url.strcheckin#&strcheckout=#url.strcheckout#</cfoutput>&pets="+pets+"&addons="+addons+"&travelInsuranceSelected="+travelInsuranceSelected,
						success: function( data ) {
							$("#apiresponse").html(data);
							if(travelInsuranceSelected) {
								$("#addinsurance").trigger("click");
							}
						}
					});

					$('#apiresponse').fadeIn("1000");
				});
	
				$('body').on('click','#enhancementsApply',function(){
					$('#apiresponse').fadeOut("1000");
					var pets = $('#numPets').val();
					var addons = $('#allAddOns').val();
					var carpass = 0;
					var travelInsuranceSelected = '';
					var travelInsuranceNotSelected = $("input[id=removeinsurance]").is(":checked");
					travelInsuranceSelected = $("input[id=addinsurance]").is(":checked");

					if(!travelInsuranceSelected && !travelInsuranceNotSelected){
						travelInsuranceSelected = '';
					}

					$.ajax({
						url: "<cfoutput>ajax/get-booknow-rates.cfm?propertyid=#url.propertyid#&strcheckin=#url.strcheckin#&strcheckout=#url.strcheckout#</cfoutput>&pets="+pets+"&carpass="+carpass+"&addons="+addons+"&travelInsuranceSelected="+travelInsuranceSelected,
						success: function( data ) {
							$("#apiresponse").html(data);
							if(travelInsuranceSelected) {
								$("#addinsurance").trigger("click");
							}
						}
					});

					$('#apiresponse').fadeIn("1000");
				});

				$('body').on('click','#tchoice_half',function(){
					$('#apiresponse').fadeOut("1000");

					var formdata = $.param( $("#bookNowForm input").not('input[name=ccNumber]').not('input[name=ccCVV]').not('input[name=cardnum]').not('input[name=cc_cvv2]').not('input[name=cc_exp_month]').not('input[name=routingNumber]').not('input[name=accountNumber]') );
					var useraction = $(this).val(); // ADD OR REMOVE
					var promocode = $('#promocodeform').find('input[name=promocode]').val();
					var ti = $('.travel_insurance:checked').val();

					<cfoutput>
					var propertyid = '#url.propertyid#';
					var strcheckin = '#url.strcheckin#';
					var strcheckout = '#url.strcheckout#';
					</cfoutput>

					$.ajax({
						url: 'ajax/get-booknow-rates.cfm?useraction='+useraction+'&ti='+ti+'&promocode='+promocode+'&paychoice=half',
						data: formdata,
						success: function( data ) {
							$("#apiresponse").html(data);
						}
					});

					$('#apiresponse').fadeIn("1000");
				});

				$('body').on('click','#tchoice_total',function(){
					$('#apiresponse').fadeOut("1000");

					var formdata = $.param( $("#bookNowForm input").not('input[name=ccNumber]').not('input[name=ccCVV]').not('input[name=cardnum]').not('input[name=cc_cvv2]').not('input[name=cc_exp_month]').not('input[name=routingNumber]').not('input[name=accountNumber]') );
					var useraction = $(this).val(); // ADD OR REMOVE
					var promocode = $('#promocodeform').find('input[name=promocode]').val();
					var ti = $('.travel_insurance:checked').val();

					<cfoutput>
					var propertyid = '#url.propertyid#';
					var strcheckin = '#url.strcheckin#';
					var strcheckout = '#url.strcheckout#';
					</cfoutput>

					$.ajax({
						url: 'ajax/get-booknow-rates.cfm?useraction='+useraction+'&ti='+ti+'&promocode='+promocode+'&paychoice=full',
						data: formdata,
						success: function( data ) {
							$("#apiresponse").html(data);
						}
					});

					$('#apiresponse').fadeIn("1000");
				});

				// USER IS TRYING TO ADD/REMOVE TRAVEL INSURANCE TO THER RESERVATION
				$("body").on('click','input[name="travel_insurance"]',function(){
					var formdata = $.param( $("#bookNowForm input").not('input[name=ccNumber]').not('input[name=ccCVV]').not('input[name=cardnum]').not('input[name=cc_cvv2]').not('input[name=cc_exp_month]').not('input[name=routingNumber]').not('input[name=accountNumber]') );
					var useraction = $(this).val(); // ADD OR REMOVE
					var allAddOnsTotalValue = $("#allAddOnsTotalValue").val();

					if(useraction == 'remove_insurance'){
						$('table#insuranceTable,#travelInsuranceRow').hide();
						$('#travelInsurance').val('false');
						$("#travelInsuranceAlert").modal();

						<!---TT 113353 start--->
						$("#totalAmountDisplay").html("<strong>$" + $('#TotalTotal').val() + "</strong>");
						$("#DueTodayDisplay").html("<strong>$" + parseFloat( $('#Total').val() ) + "</strong>");
						<!---TT 113353 end--->
					}else{
						$('table#insuranceTable,#travelInsuranceRow').show();
						$('#travelInsurance').val('true');

						var twi = $('#tripinsuranceamount').val();
						var total = $('#Total').val();
						var twi_total = parseFloat( total ) + parseFloat( twi );

						$('#TotalWithInsurance').val( twi_total );

						<!---TT 113353 start--->
						$("#totalAmountDisplay").html("<strong>$" + $('#TotalTotalWithInsurance').val() + "</strong>");
						$("#DueTodayDisplay").html("<strong>$" + parseFloat( twi_total.toFixed(2) ) + "</strong>");
						<!---TT 113353 end--->
					}
				});


				$('#addTravelInsurance2').click(function(){
					var formdata = $.param( $("#bookNowForm input").not('input[name=ccNumber]').not('input[name=ccCVV]').not('input[name=cardnum]').not('input[name=cc_cvv2]').not('input[name=cc_exp_month]').not('input[name=routingNumber]').not('input[name=accountNumber]') );

					$("#addinsurance").prop("checked", true);
					$("#addinsurance").trigger("click");	<!---TT 113353--->

					$('table#insuranceTable').show();
					$('#travelInsurance').val('true');
				});


				// PROCESS THE PROMO CODE FROM SUBMISSION
				$('form#promocodeform').submit(function(){
					var promocode = $(this).find('input[name=promocode]').val();

					var travelInsuranceSelected = '';
					var travelInsuranceNotSelected = $("input[id=removeinsurance]").is(":checked");
					travelInsuranceSelected = $("input[id=addinsurance]").is(":checked");

					if(!travelInsuranceSelected && !travelInsuranceNotSelected){
						travelInsuranceSelected = '';
					}

					if(promocode == ''){
						alert('Whoops! Looks like you forgot to enter your promo code.');
					}else{

						var formdata = $.param( $("#promocodeform input") ) + '&addons=' + $("#allAddOns").val() + '&travelInsuranceSelected=' + travelInsuranceSelected;

						$.ajax({
							url: "ajax/submit-promo-code.cfm",
							data: formdata,
							success: function( data ) {

								if(data.indexOf('Error') == 0){
									alert('Sorry, that promo code was invalid.');
								}else{

									$('#apiresponse').fadeOut("1000");
									$("#apiresponse").html(data);
									$('#apiresponse').fadeIn("1000");

									$('input[name=hiddenPromoCode]').val(promocode);


									if($(data).find('#promoCodeTr').length > 0){
										$('.promo-code h3').text('Promo Code Applied');
									}

									if(travelInsuranceSelected) {
										$("#addinsurance").trigger("click");
									}
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
			});
		</script>
	<!---</cfif>--->

	<!--- Keep Here for Book Now Page Only --->
	<script type="text/javascript">
	$(document).ajaxComplete(function(){
	  //Jackpot Message on Book Now Page
	  if ( $('.book-now .jackpot-message').length ) {
	    function jackpotFadeIn() {
	      setTimeout(function(){
	        jackpot.addClass('fade-show');
	      }, 1000);
	    }
	    var jackpot = $('.jackpot-message');
	    var jackpotFromTop = jackpot.offset().top;
	    var jackpotFromBottom = jackpotFromTop - $(window).height();
	    jackpot.text('Jackpot! You got a great rate!');
	    if ( $(window).height() >= jackpotFromTop ) {
	      jackpotFadeIn();
	    } else {
	      $(document).scroll(function() {
	        if ( $(this).scrollTop() > jackpotFromBottom ) {
	          if ( !jackpot.hasClass('fade-show') ) {
	            jackpotFadeIn();
	          }
	        }
	      });
	    }
	  }
	});
	</script>
</cf_htmlfoot>

<div id="travelInsuranceAlert" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Are you sure?</h4>
      </div>
      <div class="modal-body">
    		<p>We highly recommend Travel Insurance for the following reasons:</p>
    		<ul>
      		<li>Unpredictable weather, airport delays, and other forces beyond human control.</li>
      		<li>If anyone in your party becomes ill and cannot travel during your trip.</li>
      		<li>Travel delays such as closed roads and closed airports.</li>
    		</ul>
    		<h6><b>In South Carolina, these scenarios are common.</b>  Before making your final decision, please familiarize yourself with our <a href="/terms-conditions" target="_blank">cancellation policy.</a></h6>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn site-color-4-bg site-color-3-bg-hover text-white" data-dismiss="modal">Decline Travel Insurance</button>
        <button type="button" class="btn site-color-2-bg site-color-3-bg-hover text-white" id="addTravelInsurance2" data-dismiss="modal">Purchase Travel Insurance</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<div id="termsAndConditionsAlert" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Terms &amp; Conditions</h4>
      </div>
      <div class="modal-body">
        <p>-<strong>RATES</strong> - Published rates are weekly rates. Nightly rates are computed by dividing the weekly rate by 5.</p>
        <p>-<strong>PREPAYMENT</strong> - 50% of the total invoice amount and all applicable administrative fees apply initially.   The final balance is due 45 days prior to arrival on all reservations. Final balance payment may be made in the form of a personal check (if received by date payment is due), money order, debit or credit card. Monies will be placed in an interest-bearing account.  South Carolina Real Estate Law specifies such interest shall accrue and the signature below releases all interest to Sunset Rentals, Inc., on this account.</p>
        <p>-<strong>SECURITY DEPOSIT</strong> - An approved credit card number must be on file in the name of the renter to hold as a security deposit in the case of damage to the property. Guest agrees that they will be responsible for the cost to remedy any such damages. Guest will be notified of any incurred charges.</p>
        <p>Guests should not re-arrange villa or home furnishings in any way.   A charge will be incurred should it be necessary to return furniture to its original location. </p>
        <p>-<strong>CANCELLATION POLICY FOR HOMES</strong> - Cancellations made more than 90 days (120 days for Oceanfront and luxury homes) prior to your scheduled arrival are subject to a $500 cancellation fee.  In addition, all administrative fees are non- refundable. A cancellation 90 to 45 days prior to your scheduled arrival would result in the forfeit of your deposit. All monies will be forfeited for any cancellation made within 45 days of arrival.</p>
        <p>-<strong>CANCELLATION POLICY FOR VILLAS</strong> - Cancellations made more than 60 days (120 days for Oceanfront) prior to your scheduled arrival are subject to a $500 cancellation fee. In addition, all administrative fees are non- refundable. If you cancel your reservation between 60 and 45 days prior to your scheduled arrival, you will forfeit your deposit. All monies will be forfeited for any cancellation made within 45 days of arrival.</p>
        <p>-<strong>TRAVEL  INSURANCE</strong> - Travel  insurance  is  provided  to  protect  you  in  the  event  of  unforeseen circumstances requiring cancellation or interruption of your trip.  The cost of this coverage is 7.0% of base rental rate, tax and non-refundable fees. It is non-refundable 10 days after purchase. For complete information on the insurance coverage, please visit the Redsky Travel Insurance website at <a href="http://www.trippreserver.com/sun-trip.html" target="_blank">http://www.trippreserver.com/sun-trip.html</a>. Travel Insurance is an optional fee.</p>
        <p>-<strong>EXTREME WEATHER</strong> - No  refunds  will  be  issued  for  adverse weather  including  hurricane  and hurricane  evacuation.  If a mandatory evacuation is ordered, coverage may be available to travel insurance policy holders. This coverage is afforded per the policy in effect and its conditions.</p>
        <p>-<strong>ADMINISTRATIVE FEES</strong> - All reservations are subject to a non-refundable processing fee and a non- refundable 9% reservation fee.</p>
        <p>-<strong>LINENS</strong> - Linens are provided for stays less than 30 days.  There is a $35.00 linen charge for stays of 30 days or more.</p>
        <p>-<strong>TAXES</strong> - Published rates do not include South Carolina State and Hilton Head local taxes totaling 11%.</p>
        <p>-<strong>ARRIVAL</strong> - Check-in time is 4:00 PM, or after but no rental rate adjustments can be made due to the property not being ready by then.  Arrival instructions will be provided upon receipt of final payment and signed Terms and Conditions document. The 4PM check-in time is not guaranteed.</p>
        <p>-<strong>DEPARTURE</strong> - Check out time is 10:00 AM.  Any late check outs not approved by our office are subject to an additional charge at the regular nightly rate. All homes and villas are cleaned and inspected upon your arrival/departure.</p>
        <p>We are not responsible for items left behind. There is a $35.00 recovery charge.</p>
        <p>-<strong>HOME AND VILLA EQUIPMENT</strong></p>
        <ul>
          <li>&bull; All properties are equipped for basic vacation needs. Linens are provided for the maximum number of guests stated for each home and villa. Kitchen utensils and a starter set of toiletries are supplied.</li>
          <li>&bull; Hairdryers are not provided.</li>
          <li>&bull; Beach chairs and beach towels are not provided. Do not use home or villa linens as beach blankets.</li>
          <li>&bull; The pool of a private home is cleaned twice a week in the summer and once a week the remainder of the year.</li>
          <li>&bull; Pool and spa heat is available for some homes and for an additional charge due to the high cost of propane. This must be arranged 2 weeks before arrival.</li>
          <li>&bull; If additional cleaning of the home or villa, or linens and/or carpet are found to be excessively dirty, the reservation will be charged an additional fee.</li>
          <li>&bull; Telephones are provided. Local calls are free.</li>
          <li>&bull; Wi-Fi is provided. Changing the password on the Wi-Fi will incur a $250 charge to the credit card on file.</li>
        </ul>
        <p>-<strong>RESTRICTIONS</strong> - Motor homes, motorcycles, trailers or boats are not allowed!   Please do not re- arrange villa furnishings in any way. Sunset Rentals reserves the right to change, alter or move renters to another property if necessary due to unforeseen circumstances.  Sunset Rental is not responsible for acts of Mother Nature, including weather, beach conditions, etc.</p>
        <p><strong>NO CHARCOAL GRILLS ALLOWED AT ANY PROPERTY PER ORDER OF THE TOW N OF HILTON HEAD AND THE HILTON HEAD FIRE DEPARTMENT. Elevators within individual homes are for the specific use of the home owner and will remain locked.</strong></p>
        <p><strong>SUNSET  RENTALS  DOES  NOT  RENT  TO  ANY  COLLEGE  OR  YOUTH  GROUPS  WITHOUT SPECIFIC WRITTEN AUTHORIZATION FROM M ANAGEMENT. IN ADDITION, ADULT SUPERVISION IS REQUIRED FOR UNM ARRIED GUESTS LESS THAN 25 YEARS OF AGE</strong></p>
        <p>If it is determined through verification of proper identification that a responsible party of at least 25 years of age is not in residence, the entire group will be escorted from the property with the assistance of local authorities if needed. Re-entry to the property will not be allowed and there will be no monetary refund.</p>
        <p>-<strong>SOCIAL FUNCTIONS</strong> - Parties or social functions (i.e. reunions, receptions, etc.) with guests in attendance in numbers which exceed the stated maximum number of persons per rental are specifically prohibited in any rental property without previous written authorization from Sunset Rentals.</p>
        <p>-<strong>NO SMOKING - ALL PROPERTIES ARE STRICTLY NON-SMOKING!</strong> A $500.00 fee WILL apply for violation of this policy.</p>
        <p>-<strong>PETS</strong> - We accept dogs only.   No pets are allowed in any property unless specifically designated as pet-friendly and a non-refundable fee of $200.00 for the 1st pet and $150 for the 2nd pet plus tax.  A two pet maximum and a weight limit of 75 lbs. per pet is strictly enforced.  <strong>NEITHER SUNSET RENTALS NOR THE PROPERTY OWNER WILL BE RESPONSIBLE FOR ANY PROBLEMS, DAMAGE, OR INJURY CAUSED BY ANY PET. PETS ARE NOT PERMITTED ON THE FURNITURE AT ANY TIME. ADDITIONAL CLEANING AND DAMAGE FEES WILL APPLY.</strong>  A $500 fine in addition to the pet fee WILL apply if any pet is found in a non-pet friendly property.  In addition, Sunset Rentals reserves the right to immediately cancel the reservation for any property where an unauthorized pet is found.</p>
        <p>-<strong>PROPERTY AVAILABILITY</strong> - Should a property become unavailable for guest use through the sale of the premises or other circumstances beyond the reasonable control of the rental agent, the agent may substitute with the best available, comparable accommodations for the same period.  A full refund will be issued, without penalty, should a comparable property not be available.</p>
        <p>-<strong>MAINTENANCE</strong> - Sunset Rentals makes every attempt to make sure the home or villa you have rented is in good working order when you arrive.  If you do encounter a maintenance problem in the home or villa, it will be handled in a timely and professional manner.  Sunset Rentals, Inc. is not responsible for resort amenities, such as scheduled or unscheduled pool and spa closures, etc.  Rental rates will not be adjusted due to any malfunction of equipment.   Sunset Rentals or its Agent may re-enter the rental property at a reasonable time for the purpose of making repairs or for routine maintenance.</p>
        <p>Even though all properties are maintained on a regular basis, at times maintenance repairs may be required.  Sunset Rentals reserves the right to perform maintenance or have an outside vendor perform maintenance at any time during the stay.  If the property is pet-friendly, dogs must be secured while guest is away.  Rental fees will not be refunded or reduced due to maintenance at the property rented or at neighboring properties due to construction.</p>
        <p>-<strong>LIABILITY</strong> - As a guest of the owner and Sunset Rentals, I understand that while using a private or community pool (or spa), you and any guests are swimming at your own risk.    In consideration and on behalf of your guests, Sunset Rentals and the pool owner are released from any liability or claims arising from injury while using the pool. Hilton Head Island is home to many wildlife animals including Alligators. Sunset Rentals is not responsible for any injury caused by guest's negligence that may cause injury by any wildlife animal including Alligators.</p>
        <p><strong>I UNDERSTAND AND AGREE TO THE ABOVE TERMS AND CONDITIONS.  Guest (to include guest invitees) further agrees to indemnify and save Agent, its employees and property owners, free and harmless from any claim or liability for any loss or damage whatsoever including but not limited to personal injury or damage/loss of property, arising from, related to, or in connection with the rental of the above premises or any rental equipment ordered through Sunset Rentals.  Sunset Rentals reserves the right to refund or refuse rental to anyone.</strong></p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn site-color-4-bg site-color-3-bg-hover text-white" data-dismiss="modal">Close</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<cfinclude template="/#settings.booking.dir#/components/footer.cfm">

<cfcatch>
	<cfdump var="#cfcatch#" abort="true" />
</cfcatch>

</cftry>