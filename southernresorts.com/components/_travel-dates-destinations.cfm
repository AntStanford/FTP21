<style>
	.destination-availability .refine-dates .arrival-day, .property-dates form#refineForm input[type=text]#checkinValueDetail, .property-dates form#refineForm input[type=text]#checkoutValueDetail, .destination-availability .refine-dates .date-entered+.arrival-day { bottom: auto; top: -7px; }
</style>
<div class="col-xs-12 col-sm-3 refine-item refine-dates destination-calendar">
  <div id="" class="property-dates">
	  <form role="form" id="refineForm" class="refine-form" method="post" action="/vacation-rentals/results">
		<input type="hidden" name="camefromsearchform">
		  <input type="hidden" name="town" value="<cfoutput>#getdestination.title#</cfoutput>">
		  <cfif isdefined('session.booking.strSortBy') and len(session.booking.strSortBy)>
    <cfoutput><input type="hidden" name="strSortBy" value="#session.booking.strSortBy#"></cfoutput>
  <cfelse>
    <input type="hidden" name="strSortBy" value="P">
  </cfif>
	    <fieldset>
	      <div class="refine-dates">
          <span class="datepicker-wrap">
          <div class="refine-text">
			     <span class="datepicker-arrival-wrap">
			 	    <span class="refine-arrival">
						<cfif isdefined('session.booking.strcheckin') and len(session.booking.strcheckin)>
						  <input type="text" name="strCheckin" id="startDateRefine" placeholder="Arrival" value="<cfoutput>#session.booking.strcheckin#</cfoutput>" readonly class="date-entered">
						<cfelse>
						  <input type="text" name="strCheckin" id="startDateRefine" placeholder="Arrival" value="" readonly>
						</cfif>
						<div id="arrivalDayDetail" class="arrival-day">Day</div>
	            <div id="arrivalMonthDetail" class="arrival-month">Month</div>
	            <i class="fa fa-chevron-down" aria-hidden="true"></i>
            </span>
          </span>
          <span class="datepicker-departure-wrap">
      <span class="refine-departure">
        <i class="fa fa-calendar site-color-2" aria-hidden="true"></i>
				<cfif isdefined('session.booking.strcheckout') and len(session.booking.strcheckout)>
          <input type="text" name="strCheckout" id="endDateRefine" placeholder="Departure" value="<cfoutput>#session.booking.strcheckout#</cfoutput>" readonly class="date-entered">
				<cfelse>
          <input type="text" name="strCheckout" id="endDateRefine" placeholder="Departure" value="" readonly>
				</cfif>
				 <div id="departureDayDetail" class="arrival-day departure-day">Day</div>
	            <div id="departureMonthDetail" class="arrival-month departure-month">Month</div>
	            <i class="fa fa-chevron-down" aria-hidden="true"></i>
        </span>
            </span>
        </div><!--END refine-text-->
        <div class="refine-dropdown datepicker-wrap hidden">
		      <div id="refineDatepicker"></div>
		      <a href="javascript:;" class="btn btn-sm btn-default text-center pull-left refine-close site-color-1-bg text-white">Close</a>
		      <!---<a href="javascript:;" class="btn btn-sm btn-default text-center pull-right refine-apply site-color-2-bg text-white" id="refineDatesApply">Apply</a>--->
		    </div>
        <div class="form-group">
          <select id="guest" name="sleeps" title="Guests" class="selectpicker form-control">
<!--- 			  <option value=""></option> ---><option selected disabled value>Guests</option>
            <cfloop from="2" to="12" index="i">
                  <cfoutput><option value="#i#">#i#</option></cfoutput>
                </cfloop>
          </select>
          <button  class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white southern-btn" type="submit">Check Availability</button>
        </div>
        </span><!-- END datepicker-wrap -->
	      </div><!-- END refine-dates -->
      </fieldset>
    </form><!-- END refineForm -->
  </div><!--END property-dates-->
</div><!--END refine-item refine-dates destination-calendar