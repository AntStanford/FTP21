<cfif CGI.HTTP_REFERER eq "https://southernresorts.com/vacation-rentals/results" and isdefined('session.booking.strcheckin') and LEN(session.booking.strcheckin)>
	<cfset thisCheckin = session.booking.strcheckin>
<cfelseif isdefined('url.strcheckin') and LEN(url.strcheckin)>
  <cfset thisCheckin = url.strcheckin>
<cfelseif isdefined('session.booking.resort.strcheckin') and LEN(session.booking.resort.strcheckin)>
 <cfset thisCheckin = session.booking.resort.strcheckin>
<cfelseif isdefined('session.booking.strcheckin') and LEN(session.booking.strcheckin)>
 <cfset thisCheckin = session.booking.strcheckin>
</cfif>

<cfif CGI.HTTP_REFERER eq "https://southernresorts.com/vacation-rentals/results" and isdefined('session.booking.strcheckout') and LEN(session.booking.strcheckout)>
	<cfset thisCheckout = session.booking.strcheckout>
<cfelseif isdefined('url.strcheckout') and LEN(url.strcheckout)>
  <cfset thisCheckout = url.strcheckout>
<cfelseif isdefined('session.booking.resort.strcheckout') and LEN(session.booking.resort.strcheckout)>
 <cfset thisCheckout = session.booking.resort.strcheckout>
<cfelseif isdefined('session.booking.strcheckout') and LEN(session.booking.strcheckout)>
 <cfset thisCheckout = session.booking.strcheckout>
</cfif>

<div class="property-dates-wrap resort-dates-wrap">
  <div id="resortDatesAnchor" style="height: 0px;"><!-- TRAVEL DATES STICKY ANCHOR FOR SCROLL --></div>
	<div class="refine-item refine-dates destination-calendar resorts-calendar">
	  <div id="resortDates" class="property-dates resort-dates">
		  <form role="form" id="refineForm" class="refine-form" method="post" action="/resort/<cfoutput>#cgi.query_string#</cfoutput>">
			<input type="hidden" name="camefromsearchform">
		  <input type="hidden" name="neighborhoods" value="<cfoutput>#request.resortID#</cfoutput>">
		  <input type="hidden" name="resortID" value="<cfoutput>#request.resortID#</cfoutput>">
		    <fieldset>
  		    <h3 class="property-name">Pick Your Dates</h3>
		      <div class="refine-dates">
	          <span class="datepicker-wrap">
		          <div class="refine-text">
						    <span class="datepicker-arrival-wrap">
						 	    <span class="refine-arrival">
										<cfif isdefined('thisCheckin') and len(thisCheckin)>
										  <input type="text" name="strCheckin" class="date-entered checkInValueResort" id="startDateRefine" placeholder="Arrival" value="<cfoutput>#thisCheckin#</cfoutput>" readonly>
										<cfelse>
										  <input type="text" name="strCheckin" class="checkInValueResort" id="startDateRefine" placeholder="Arrival Date" value="" readonly>
										</cfif>
										<div id="arrivalDayDetail" class="arrival-day"><cfif isdefined('thisCheckin') and len(thisCheckin)><cfoutput>#DateFormat(thisCheckin,"DD")#</cfoutput><cfelse>Day</cfif></div>
					          <div id="arrivalMonthDetail" class="arrival-month"><cfif isdefined('thisCheckin') and len(thisCheckin)><cfoutput>#DateFormat(thisCheckin,"MMM")#</cfoutput><cfelse>Month</cfif></div>
					          <i class="fa fa-chevron-down" aria-hidden="true"></i>
			            </span>
			          </span>
		            <span class="datepicker-departure-wrap">
			            <span class="refine-departure">
			              <i class="fa fa-calendar site-color-2" aria-hidden="true"></i>
										<cfif isdefined('thisCheckout') and len(thisCheckout)>
						          <input type="text" name="strCheckout" class="date-entered checkOutValueResort" id="endDateRefine" placeholder="Departure" value="<cfoutput>#thisCheckout#</cfoutput>" readonly>
										<cfelse>

						          <input type="text" name="strCheckout" class="checkOutValueResort" id="endDateRefine" placeholder="Departure Date" value="" readonly>
						 				</cfif>
							      <div id="departureDayDetail" class="arrival-day departure-day"><cfif isdefined('thisCheckout') and len(thisCheckout)><cfoutput>#DateFormat(thisCheckout,"DD")#</cfoutput><cfelse>Day</cfif></div>
				            <div id="departureMonthDetail" class="arrival-month departure-month"><cfif isdefined('thisCheckout') and len(thisCheckout)><cfoutput>#DateFormat(thisCheckout,"MMM")#</cfoutput><cfelse>Month</cfif></div>
				            <i class="fa fa-chevron-down" aria-hidden="true"></i>
			            </span>
			          </span>
			        </div><!--END refine-text-->
			        <div class="refine-dropdown datepicker-wrap hidden">
					      <div id="refineDatepicker"></div>
					      <a href="javascript:;" class="btn btn-sm btn-default text-center pull-left refine-close site-color-1-bg text-white">Close</a>
					      <a href="javascript:;" class="btn btn-sm btn-default text-center pull-left <!---refine-clear--->" onclick="$('#startDateRefine').val('');$('#endDateRefine').val('');$('#refineForm').submit()">Clear Dates</a>

			          <a href="javascript:;" class="btn btn-sm btn-default text-center pull-right refine-apply site-color-2-bg text-white" <!---id="refineDatesApply"---> onclick="$('#refineForm').submit()">Apply</a>
					    </div>
<!---
			        <div class="form-group">
			          <select id="guest" name="sleeps" title="Guests" class="selectpicker form-control">
			          <!---<option value=""></option> --->
			            <option selected disabled value>Guests</option>
			            <cfloop from="2" to="12" index="i">
							      <cfoutput><option value="#i#" <cfif isDefined("session.booking.sleeps") and session.booking.sleeps EQ i>selected</cfif>>#i#</option></cfoutput>
			            </cfloop>
		            </select>
		          </div>
--->
		          <div class="form-group">
<!---
		            <select id="beds" name="bedrooms" title="Bedrooms" class="selectpicker form-control">
			          <!---<option value=""></option> --->
			            <option selected disabled value>Beds</option>

			            <cfloop from="1" to="12" index="i">
							      <cfoutput><option value="#i#" <cfif isDefined("session.booking.bedrooms") and session.booking.bedrooms EQ i>selected</cfif>>#i#</option></cfoutput>
			            </cfloop>

		            </select>
		            <div class="check-group petFriendly">
				  				<input type="checkbox" id="petFriendly" name="must_haves" value="Pet Friendly" <cfif isDefined("session.booking.must_haves") AND ListFind(session.booking.must_haves,"Pet Friendly")>checked</cfif>><label class="petfriendly" for="petFriendly">Pet Friendly</label>
				  			</div>
				  			<div class="check-group fullView">
				  				<input type="checkbox" id="fullView" name="amenities" value="Full View" <cfif isDefined("session.booking.amenities") AND ListFind(session.booking.amenities,"Full View")>checked</cfif>><label class="fullview" for="fullView">Full View</label>
				  			</div>
				  			<div class="check-group beachService">
				  				<input type="checkbox" id="beachService" name="amenities" value="Complimentary Beach Service in Season - 2 Chairs & Umbrella" <cfif isDefined("session.booking.amenities") AND ListFind(session.booking.amenities,"Complimentary Beach Service in Season - 2 Chairs & Umbrella")>checked</cfif>><label class="beachservice" for="beachService" >Complimentary Beach Service in Season - 2 Chairs & Umbrella</label>
				  			</div>
--->
				  			<!---<button class="btn site-color-3-bg site-color-3-lighten-bg-hover text-white clear-filters" id="clearfilters">Clear Filters</button>--->
		            <button class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white southern-btn" type="submit" id="chkavail">Check Availability</button>
		          </div><!--END form-group-->
		        </span><!-- END datepicker-wrap -->
		      </div><!-- END refine-dates -->
	      </fieldset>
	    </form><!-- END refineForm -->
	  </div><!--END property-dates-->
	</div><!--END refine-item refine-dates destination-calendar-->
</div><!-- END property-dates-container -->

<a id="resortDatesBottom" style="height: 1px;"></a>

<!--- 

<div class="property-dates-wrap resort-dates-wrap">
  <div id="resortDatesAnchor" style="height: 0px;"><!-- TRAVEL DATES STICKY ANCHOR FOR SCROLL --></div>
	<div class="refine-item refine-dates destination-calendar resorts-calendar">
	  <div id="resortDates" class="property-dates resort-dates">
		  <form role="form" id="refineForm" class="refine-form" method="post" action="/resort/<cfoutput>#cgi.query_string#</cfoutput>">
			<input type="hidden" name="camefromsearchform">
		  <input type="hidden" name="neighborhoods" value="<cfoutput>#request.resortID#</cfoutput>">
		  <input type="hidden" name="resortID" value="<cfoutput>#request.resortID#</cfoutput>">
		    <fieldset>
  		    <h3 class="property-name">Pick Your Dates</h3>
		      <div class="refine-dates">
	          <span class="datepicker-wrap">
		          <div class="refine-text">
						    <span class="datepicker-arrival-wrap">
						 	    <span class="refine-arrival">
										<cfif isdefined('session.booking.strcheckin') and len(session.booking.strcheckin)>
										  <input type="text" name="strCheckin" class="date-entered checkInValueResort" id="startDateRefine" placeholder="Arrival" value="<cfoutput>#session.booking.strcheckin#</cfoutput>" readonly>
										<cfelse>
										  <input type="text" name="strCheckin" class="checkInValueResort" id="startDateRefine" placeholder="Arrival Date" value="" readonly>
										</cfif>
										<div id="arrivalDayDetail" class="arrival-day"><cfif isdefined('session.booking.strcheckin') and len(session.booking.strcheckin)><cfoutput>#DateFormat(session.booking.strcheckin,"DD")#</cfoutput><cfelse>Day</cfif></div>
					          <div id="arrivalMonthDetail" class="arrival-month"><cfif isdefined('session.booking.strcheckin') and len(session.booking.strcheckin)><cfoutput>#DateFormat(session.booking.strcheckin,"MMM")#</cfoutput><cfelse>Month</cfif></div>
					          <i class="fa fa-chevron-down" aria-hidden="true"></i>
			            </span>
			          </span>
		            <span class="datepicker-departure-wrap">
			            <span class="refine-departure">
			              <i class="fa fa-calendar site-color-2" aria-hidden="true"></i>
										<cfif isdefined('session.booking.strcheckout') and len(session.booking.strcheckout)>
						          <input type="text" name="strCheckout" class="date-entered checkOutValueResort" id="endDateRefine" placeholder="Departure" value="<cfoutput>#session.booking.strcheckout#</cfoutput>" readonly>
										<cfelse>

						          <input type="text" name="strCheckout" class="checkOutValueResort" id="endDateRefine" placeholder="Departure Date" value="" readonly>
						 				</cfif>
							      <div id="departureDayDetail" class="arrival-day departure-day"><cfif isdefined('session.booking.strcheckout') and len(session.booking.strcheckout)><cfoutput>#DateFormat(session.booking.strcheckout,"DD")#</cfoutput><cfelse>Day</cfif></div>
				            <div id="departureMonthDetail" class="arrival-month departure-month"><cfif isdefined('session.booking.strcheckout') and len(session.booking.strcheckout)><cfoutput>#DateFormat(session.booking.strcheckout,"MMM")#</cfoutput><cfelse>Month</cfif></div>
				            <i class="fa fa-chevron-down" aria-hidden="true"></i>
			            </span>
			          </span>
			        </div><!--END refine-text-->
			        <div class="refine-dropdown datepicker-wrap hidden">
					      <div id="refineDatepicker"></div>
					      <a href="javascript:;" class="btn btn-sm btn-default text-center pull-left refine-close site-color-1-bg text-white">Close</a>
					      <a href="javascript:;" class="btn btn-sm btn-default text-center pull-left <!---refine-clear--->" onclick="$('#startDateRefine').val('');$('#endDateRefine').val('');$('#refineForm').submit()">Clear Dates</a>

			          <a href="javascript:;" class="btn btn-sm btn-default text-center pull-right refine-apply site-color-2-bg text-white" <!---id="refineDatesApply"---> onclick="$('#refineForm').submit()">Apply</a>
					    </div>
<!---
			        <div class="form-group">
			          <select id="guest" name="sleeps" title="Guests" class="selectpicker form-control">
			          <!---<option value=""></option> --->
			            <option selected disabled value>Guests</option>
			            <cfloop from="2" to="12" index="i">
							      <cfoutput><option value="#i#" <cfif isDefined("session.booking.sleeps") and session.booking.sleeps EQ i>selected</cfif>>#i#</option></cfoutput>
			            </cfloop>
		            </select>
		          </div>
--->
		          <div class="form-group">
<!---
		            <select id="beds" name="bedrooms" title="Bedrooms" class="selectpicker form-control">
			          <!---<option value=""></option> --->
			            <option selected disabled value>Beds</option>

			            <cfloop from="1" to="12" index="i">
							      <cfoutput><option value="#i#" <cfif isDefined("session.booking.bedrooms") and session.booking.bedrooms EQ i>selected</cfif>>#i#</option></cfoutput>
			            </cfloop>

		            </select>
		            <div class="check-group petFriendly">
				  				<input type="checkbox" id="petFriendly" name="must_haves" value="Pet Friendly" <cfif isDefined("session.booking.must_haves") AND ListFind(session.booking.must_haves,"Pet Friendly")>checked</cfif>><label class="petfriendly" for="petFriendly">Pet Friendly</label>
				  			</div>
				  			<div class="check-group fullView">
				  				<input type="checkbox" id="fullView" name="amenities" value="Full View" <cfif isDefined("session.booking.amenities") AND ListFind(session.booking.amenities,"Full View")>checked</cfif>><label class="fullview" for="fullView">Full View</label>
				  			</div>
				  			<div class="check-group beachService">
				  				<input type="checkbox" id="beachService" name="amenities" value="Complimentary Beach Service in Season - 2 Chairs & Umbrella" <cfif isDefined("session.booking.amenities") AND ListFind(session.booking.amenities,"Complimentary Beach Service in Season - 2 Chairs & Umbrella")>checked</cfif>><label class="beachservice" for="beachService" >Complimentary Beach Service in Season - 2 Chairs & Umbrella</label>
				  			</div>
--->
				  			<!---<button class="btn site-color-3-bg site-color-3-lighten-bg-hover text-white clear-filters" id="clearfilters">Clear Filters</button>--->
		            <button class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white southern-btn" type="submit" id="chkavail">Check Availability</button>
		          </div><!--END form-group-->
		        </span><!-- END datepicker-wrap -->
		      </div><!-- END refine-dates -->
	      </fieldset>
	    </form><!-- END refineForm -->
	  </div><!--END property-dates-->
	</div><!--END refine-item refine-dates destination-calendar-->
</div><!-- END property-dates-container -->

<a id="resortDatesBottom" style="height: 1px;"></a>



 --->