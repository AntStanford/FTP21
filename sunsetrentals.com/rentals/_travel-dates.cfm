<div id="travelDatesAnchor"><!-- TRAVEL DATES STICKY ANCHOR FOR SCROLL --></div>
<div id="travelDates" class="property-dates">

  <cfset twentyFourHrs = Dateadd('h','-24',Now())>

  <cfquery datasource="#settings.dsn#" name="GetPropertyViews">
    SELECT DISTINCT TrackingEmail,UserTrackerValue
    FROM be_prop_view_stats WHERE createdAt >= <cfqueryparam value="#twentyFourHrs#" cfsqltype="CF_SQL_TIMESTAMP">
    and unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#property.propertyid#">
    GROUP BY TrackingEmail,UserTrackerValue desc
  </cfquery>

  <cfif GetPropertyViews.recordcount gt 4>
    <strong class="alert-views">
      <i class="fa fa-fire" aria-hidden="true"></i>
        <strong><cfoutput>#GetPropertyViews.recordcount#</cfoutput></strong> people
       have considered renting this property in the last 24 hours. Don't miss out and book now!
    </strong>
  </cfif>
	<style>
		.at-share-btn-elements>.at-svc-email{
			display:none !important;
		}
	</style>
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
      <div class="refine-dates">
        <cfoutput>
          <span class="datepicker-wrap">
            <input name="strcheckin" type="text" name="strCheckin" id="startDateDetail" class="pdp-start-date datepicker" value="<cfif isdefined('session.booking.strcheckin')>#session.booking.strcheckin#</cfif>" placeholder="Arrival" readonly>
            <input name="strcheckout" type="text" name="strCheckout" id="endDateDetail" class="pdp-end-date datepicker" value="<cfif isdefined('session.booking.strcheckout')>#session.booking.strcheckout#</cfif>" placeholder="Departure" readonly>
            <div id="detailDatepickerCheckin" class="detail-datepicker-checkin datepicker-container"></div>
            <div id="detailDatepickerCheckout" class="detail-datepicker-checkout datepicker-container"></div>
          </span>
        </cfoutput>
      </div><!-- END refine-dates -->
      <cfif !isdefined('session.booking.strcheckin') OR (isdefined('session.booking.strcheckin') and session.booking.strcheckin eq '')>
        <button id="selectDates" class="btn site-color-1-bg site-color-3-bg-hover text-white" type="button"><i class="fa fa-chevron-right" aria-hidden="true"></i> Get My Quote</button>
      </cfif>
    </fieldset>
  </form><!-- END refineForm -->

  <div id="APIresponse" class="property-cost">
    <cfif isdefined('APIresponse')><cfoutput>#APIresponse#</cfoutput></cfif>
    <cfinclude template = "_remind-book-later.cfm">
  </div>

  <div class="hr">OR</div>

  <!-- INQUIRE BUTTON -->
  <button id="requestInfoBtn" class="btn site-color-2-bg site-color-3-bg-hover text-white" type="button" ><i class="fa fa-question-circle" aria-hidden="true"></i> Request More Info</button>

  <div class="social-sharing-wrap text-center">
    <h3 class="text-center">Share This Property!</h3>
    <div class="addthis_inline_share_toolbox"></div>
    <cfinclude template = "send-to-friend.cfm">
    <a role="button" data-toggle="modal" data-target="#sendtofriends" tabindex="1" class="at-icon-wrapper at-share-btn" style="border-radius: 0px;"><i class="fa fa-envelope" aria-hidden="true" style="color:white;padding: 10px;font-size: 23px;background-color: rgb(132, 132, 132); "></i></a>
  </div>

  <button id="mobileClose" class="btn site-color-3-bg site-color-4-bg-hover"><i class="fa fa-close" aria-hidden="true"></i></button>
</div><!-- END travelDates -->
