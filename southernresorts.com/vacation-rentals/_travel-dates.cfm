<cfif isdefined('url.strcheckin') and LEN(url.strcheckin)>
  <cfset thisCheckin = url.strcheckin>
<cfelseif isdefined('session.booking.strcheckin') and LEN(session.booking.strcheckin)>
 <cfset thisCheckin = session.booking.strcheckin>
</cfif>
<cfif isdefined('url.strcheckout') and LEN(url.strcheckout)>
  <cfset thisCheckout = url.strcheckout>
<cfelseif isdefined('session.booking.strcheckout') and LEN(session.booking.strcheckout)>
 <cfset thisCheckout = session.booking.strcheckout>
</cfif>

<div id="travelDatesAnchor"><!-- TRAVEL DATES STICKY ANCHOR FOR SCROLL --></div>
<div id="travelDates" class="property-dates">

  <cfset twentyFourHrs = Dateadd('h','-24',Now())>

  <cfquery datasource="#settings.dsn#" name="GetPropertyViews">
    SELECT DISTINCT TrackingEmail,UserTrackerValue
    FROM be_prop_view_stats WHERE createdAt >= <cfqueryparam value="#twentyFourHrs#" cfsqltype="CF_SQL_TIMESTAMP">
    and unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#property.propertyid#">
    GROUP BY TrackingEmail,UserTrackerValue desc
  </cfquery>

  <cfif GetPropertyViews.recordcount gt 0>
    <strong class="alert-views">
      <i class="fa fa-fire" aria-hidden="true"></i>
      This Property has been looked at
      <cfif GetPropertyViews.recordcount eq 1>
        <strong>1</strong> time
      <cfelse>
        <strong><cfoutput>#GetPropertyViews.recordcount#</cfoutput></strong> times
      </cfif>
      in 24 hours
    </strong>
  </cfif>

  <form role="form" id="refineForm" class="refine-form">
    <input type="hidden" name="formtype" value="details-datepicker">
    <input type="hidden" name="page" value="0" />
    <cfoutput><input type="hidden" name="propertyid" value="#property.propertyid#"></cfoutput>
    <cfoutput><input type="hidden" name="unitshortname" value="#property.name#"></cfoutput>
    <cfif settings.travel_insurance_vendor eq 'Red Sky'>
      <input type="hidden" name="redskyclient" value="yes">
    <cfelse>
      <input type="hidden" name="redskyclient" value="no">
    </cfif>

    <fieldset>
      <h3 class="property-name">Pick Your Dates</h3>
      <div class="refine-dates">
        <cfoutput>
          <span class="datepicker-wrap">
            <span class="datepicker-arrival-wrap">
	            <input name="strCheckin" type="text" id="startDateDetail" class="pdp-start-date" value="<cfif isdefined('thisCheckin')>#thisCheckin#</cfif>" placeholder="Arrival Date" readonly>
              <!--- 	            <div class="arrival-day">DD</div> --->
              <div id="arrivalDayDetail" class="arrival-day refine-dates-day"><cfif isdefined('thisCheckin') AND Len(thisCheckin)>#Dateformat(thisCheckin,'DD')#<cfelse>Day</cfif></div>
              <!--- 	            <input type="text" name="" class="arrival-day refine-dates-day" id="checkinValueDetail" placeholder="DD" value="<cfif isdefined('session.booking.strcheckin')>#Dateformat(session.booking.strcheckin,'DD')#</cfif>" readonly=""> --->
	            <div class="arrival-month" id="arrivalMonthDetail"><cfif isdefined('thisCheckin') and len(thisCheckin)><cfoutput>#DateFormat(thisCheckin,"MMM")#</cfoutput><cfelse>Month</cfif></div>
	            <i class="fa fa-chevron-down" aria-hidden="true"></i>
            </span>
            <span class="datepicker-departure-wrap">
	            <input name="strCheckout" type="text" id="endDateDetail" class="pdp-end-date" value="<cfif isdefined('thisCheckout')>#thisCheckout#</cfif>" placeholder="Departure Date" readonly>
              <!--- 	            <div class="arrival-day departure-day">DD</div> --->
              <div id="checkoutValueDetail" class="arrival-day departure-day refine-dates-day"><cfif isdefined('thisCheckout') AND Len(thisCheckout)>#Dateformat(thisCheckout,'DD')#<cfelse>Day</cfif></div>
              <!--- 	            <input type="text" name="" class="arrival-day departure-day refine-dates-day" id="checkoutValueDetail" placeholder="DD" value="<cfif isdefined('session.booking.strcheckout')>#Dateformat(session.booking.strcheckout,'DD')#</cfif>" readonly=""> --->
	            <div class="arrival-month departure-month" id="departureMonthDetail"><cfif isdefined('thisCheckout') and len(thisCheckout)><cfoutput>#DateFormat(thisCheckout,"MMM")#</cfoutput><cfelse>Month</cfif></div>
	            <i class="fa fa-chevron-down" aria-hidden="true"></i>
            </span>
            <div id="detailDatepickerCheckin" class="detail-datepicker-checkin datepicker-container"></div>
            <div id="detailDatepickerCheckout" class="detail-datepicker-checkout datepicker-container"></div>
          </span>
          <div class="refine-dropdown datepicker-wrap hidden">
			      <div id="refineDatepicker"></div>
			      <a href="javascript:;" class="btn btn-sm btn-default text-center pull-left refine-close site-color-1-bg text-white">Close</a>
			      <a href="javascript:;" class="btn btn-sm btn-default text-center pull-left refine-clear">Clear Dates</a>
			      <a href="javascript:;" class="btn btn-sm btn-default text-center pull-right refine-apply site-color-2-bg text-white" id="refineDatesApply">Apply</a>
			    </div>
        </cfoutput>
      </div><!-- END refine-dates -->
      <cfif !isdefined('thisCheckin') OR (isdefined('thisCheckin') and thisCheckin eq '')>
        <button id="selectDates" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white southern-btn" type="button">Get My Quote<i class="fa fa-chevron-right" aria-hidden="true"></i></button>
<!---         <a class="southern-btn" href="">View Our Specials<i class="fa fa-arrow-right"></i></a> --->
      </cfif>
    </fieldset>
  </form><!-- END refineForm -->

  <div id="APIresponse" class="property-cost">
    <cfif isdefined('APIresponse')><cfoutput>#APIresponse#</cfoutput></cfif>
    <!---<cfinclude template = "_remind-book-later.cfm">--->
  </div>

<!---   <div class="hr">OR</div> --->

  <!-- INQUIRE BUTTON -->
<!---   <button id="requestInfoBtn" class="btn site-color-2-bg site-color-2-lighten-bg-hover text-white" type="button" ><i class="fa fa-question-circle" aria-hidden="true"></i> Request More Info</button> --->

<!---

  <div class="social-sharing-wrap">
    <h3 class="text-center">Share This Property!</h3>
   <div class="addthis_inline_share_toolbox"></div>
  </div>
--->

  <button id="mobileClose" class="btn site-color-3-lighten-bg site-color-3-bg-hover"><i class="fa fa-close" aria-hidden="true"></i></button>
  <style>
  @media (min-width: 1025px) {
    .property-wrap { z-index: 1; }
    .property-dates-wrap { position: sticky; }
    #travelDates.property-dates { position: relative !important; width: auto !important; max-width: none !important; margin-bottom: 125px !important; top: 115px !important; }
  }
  </style>
  <div class="pdp-activities">
    <div class="pdp-gulf-coast-activites" style="margin-top:15px;">
      <a href="/reserve-with-confidence-vacation-with-ease" target="_blank">
      <div class=""><span class="pdp-gca-heading">Reserve with Confidence</span><br><span class="pdp-gca-subheading">Vacation with Ease</span></div>
      <img src="/images/layout/reserve-with-confidence.jpg" alt="Reserve with Confidence" class="img-responsive"></a>
    </div>
    <div class="pdp-gulf-coast-activites" style="margin-top:15px;">
      <a href="/southerns-clean-initiative" target="_blank">
      <div class=""><span class="pdp-gca-heading">Southern's Clean Initiative</span><br><span class="pdp-gca-subheading">Learn More</span></div>
      <img src="/images/layout/Clean-Initiative-Callout.jpg" alt="Southern's Clean Initiative" class="img-responsive"></a>
    </div>
    <div class="pdp-gulf-coast-activites" style="margin-top:15px;">
      <a href="/southern-perks" target="_blank">
      <div class=""><span class="pdp-gca-heading">Southern Perks</span><br><span class="pdp-gca-subheading">Book an Activity</span></div>
      <img src="/images/layout/southern-perks-thumbnail.jpg" alt="Southern Perks" class="img-responsive"></a>
    </div>
  </div>
  <a id="travelDatesBottom" style="height: 1px;"></a>
</div><!-- END travelDates -->