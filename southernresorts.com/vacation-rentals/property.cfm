<cftry>
<cfinclude template="property_.cfm">
<cfif isdefined('noproperty')>

	<cfsavecontent variable="noUnitMessage">
	<cfoutput>
	<h2>This Property Is No Longer In Our Inventory</h2>
	<p>It looks like we do not have that unit in our inventory any longer, but we've got you covered.</p>
	<p>Here is an alphabetical list of all our available inventory at #settings.company#. Select one of the letters to show rentals starting with that letter.</p>
	</cfoutput>
	</cfsavecontent>
	<cfinclude template="all-properties.cfm">

<cfelse>

  <cfinclude template="/#settings.booking.dir#/components/header.cfm">
  <!-- Property Banner/Gallery/Map -->
  <cfinclude template="_property-photos-map.cfm">
  <div class="property-wrap">
    <cfoutput>
    <div id="propertyDetails" class="property-details-wrap" data-unitcode="#property.propertyid#" data-id="#property.propertyid#">
    </cfoutput>

      <!-- Property Base Info -->
      <cfinclude template="_property-info.cfm">

      <!-- Property Specials -->
      <cfinclude template="_property-specials.cfm">

      <!-- Property Tabs -->
      <div class="property-tabs-wrap">
        <div id="propertyTabsAnchor"><!-- TRAVEL STICKY TABS ANCHOR FOR SCROLL --></div>
        <ul id="propertyTabs" class="property-tabs tabs tab-group">
          <li><a href="#description"><i class="fa fa-align-left" aria-hidden="true"></i> <span>Description</span></a></li>
<!---           <li><a href="#calendar"><i class="fa fa-calendar-check-o" aria-hidden="true"></i> <span>Calendar</span></a></li> --->
          <!--- <li><a href="#rates"><i class="fa fa-tags" aria-hidden="true"></i> <span>Rates</span></a></li> --->
          <li><a href="#amenities"><i class="fa fa-list" aria-hidden="true"></i> <span>Amenities</span></a></li>
<!---           <li><a href="#reviews"><i class="fa fa-pencil-square-o" aria-hidden="true"></i> <span>(<cfoutput>#numReviews#</cfoutput>) Reviews</span></a></li> --->
<!---           <li><a href="#qanda"><i class="fa fa-question-circle" aria-hidden="true"></i> <span>Q&A</span></a></li> --->
<!---
          <cfif len(trim(property.virtualtour)) GT 0>
            <li><a href="#qanda"><i class="fa fa-question-circle" aria-hidden="true"></i> <span>Virtual Tour</span></a></li>
          </cfif>
--->
          <cfif len(property.latitude) and len(property.longitude)><li><a href="#map"><i class="fa fa-question-circle" aria-hidden="true"></i> <span>Map</span></a></li></cfif>
        </ul><!-- END propertyTabs -->
      </div>

      <!-- Property Description | #description -->
      <cfinclude template="_description-tab.cfm">

      <!-- Property Availability Calendar | #calendar -->
      <div class="" style="display: none;">
        <cfinclude template="_calendar-tab.cfm">
      </div>

      <!-- Property Rates Table | #rates -->
      <!--- <cfinclude template="_rates-tab.cfm"> --->

      <!-- Property Amenities | #amenities -->
      <cfinclude template="_amenities-tab.cfm">

      <!-- Property Virtual Reality Tour -->

  	  <!-- Property Videos Tour -->

      <!-- Property Map -->
		  <cfif len(property.latitude) and len(property.longitude)>
	      <div id="" name="map" class="info-wrap">
				  <div class="info-wrap-heading"><i class="fa fa-list" aria-hidden="true"></i> Map</div>
				  <div class="info-wrap-body">
<!--- 					  <div id="propertyMap" class="property-map property-iframe" <!--- style="display: none;" --->> --->
					    <div id="map"></div>
<!--- 					    <cfoutput><iframe src="https://maps.google.com/maps?q=#property.latitude#,#property.longitude#&ie=UTF8&output=embed" width="100%" height="100%" frameborder="0" style="border:0" allowfullscreen></iframe></cfoutput> --->
<!--- 					  </div> --->
				  </div><!-- END info-wrap-body -->
				</div>
		  </cfif>

      <!-- Property Reviews | #reviews -->
<!---       <cfinclude template="_reviews-tab.cfm"> --->

      <!-- Property Inquire Form | #qanda -->
<!---       <cfinclude template="_q-and-a-property.cfm"> --->

      <!-- JUMP LINK IN _travel-dates.cfm Request More Info Button -->
      <cfinclude template="_request-info.cfm">
      <cfinclude template="_pdp-callouts.cfm">
    </div><!-- END propertyDetails -->

    <div class="property-dates-wrap">
      <cfinclude template="_travel-dates.cfm">
    </div><!-- END property-dates-container -->

    <div class="mobile-dates-toggle-wrap">
      <button id="mobileDatesToggle" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white" type="button">
        <i class="fa fa-chevron-right" aria-hidden="true"></i>
        <cfif isdefined('session.booking.strcheckin') and LEN(session.booking.strcheckin)>
          View Rates
        <cfelse>
          Check Availability
        </cfif>
      </button>
      <small>Find Available Dates For this Property</small>
    </div>
  </div><!-- END property-wrap -->

  <button id="returnToTop" class="btn site-color-3-lighten-bg site-color-3-bg-hover text-white" type="button"><i class="fa fa-chevron-up" aria-hidden="true"></i></button>

	<cfinclude template="/#settings.booking.dir#/components/property-modals.cfm">
	<cfinclude template="/#settings.booking.dir#/components/footer.cfm">

</cfif>

<cfcatch>
  <cfif cgi.remote_host eq '75.87.66.209'>
      <cfdump var="#cfcatch#" abort="true" />
    </cfif>
  An error has occurred. Please reload page and try again.
  <cfif isdefined("ravenClient")>
    <cfset ravenClient.captureException(cfcatch)>
  </cfif>
</cfcatch>
</cftry>