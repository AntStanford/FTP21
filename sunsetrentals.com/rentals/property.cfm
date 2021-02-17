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

  <cfquery name="getextprop" datasource="#settings.dsn#">
  select *
  from track_properties
  where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#property.propertyid#" />
  </cfquery>

  <cfquery name="reviewschema" datasource="#settings.dsn#">
  select *
  from be_reviews
  where unitcode = <cfqueryparam cfsqltype="cf_sql_integer" value="#property.propertyid#" />
  and approved = 'Yes'
  </cfquery>

  <cfset reviewSchemaCount = 1 />
  <cfset reviewSchemaSoreTotal = 0 />
  <cfset reviewSchemaSoreAVG = 0 />
  <cfset reviewSchemaDesc = reReplace( property.description,'[^0-9A-Za-z\s]','','all' ) />
  <cfset reviewSchemaDesc = reReplace( reviewSchemaDesc, '[\n\r]', ' ', 'all' ) />

  <cfoutput>
    <script type="application/ld+json">
    {
      "name":"#property.name#",
      "image":"#getextprop.coverImage#",
      "description":"#left( reviewSchemaDesc, 150 )#",
      "@id": "#getextprop.website#"
      <cfif isdefined('reviewschema') and reviewschema.recordcount gt 0>
        ,"reviews":[
          <cfloop query="reviewschema">
            <cfset cleanReview = reReplaceNoCase( review, '<[^>]*>', '', 'all' ) />

            <cfif isNull( rating )>
              <cfset rating = 5 />
            </cfif>

            <cfset reviewSchemaSoreTotal = reviewSchemaSoreTotal + val( rating ) />
            {
                    "@type": "Review",
                    "name": "#trim( rereplace( cleanReview,'[^0-9A-Za-z ]','','all' ) )#",
                    "author": "<cfif len( firstname )>#firstname# #left( lastname,1 )#<cfelse>null</cfif>",
                    "datePublished": "#dateformat( createdat, 'yyyy-mm-dd' )#",
                    "description": null,
                    "reviewRating": [
                      {
                        "@type": "Rating",
                        "bestRating": "5",
                        "ratingValue": "#val( rating )#",
                        "worstRating": "1"
                      }
                    ]
                  }<cfif reviewSchemaCount lt reviewschema.recordcount>,</cfif>
                  <cfset reviewSchemaCount = reviewSchemaCount + 1 />
          </cfloop>
        ],
        "@context": "http://schema.org",
        "@type": "Product",
        "aggregateRating": {
          "@type": "aggregateRating",
          "ratingValue": "#(reviewSchemaSoreTotal/reviewschema.recordcount)#",
          "reviewCount": "#reviewschema.recordcount#",
          "bestRating": "5",
          "worstRating": "1"
        }
      </cfif>
    }
    </script>
  </cfoutput>

  <div class="property-wrap">
    <cfoutput>
    <div id="propertyDetails" class="property-details-wrap" data-unitcode="#property.propertyid#" data-id="#property.propertyid#">
    </cfoutput>
      <!-- Property Banner/Gallery/Map -->
      <cfinclude template="_property-photos-map.cfm">

      <!-- Property Base Info -->
      <cfinclude template="_property-info.cfm">

      <!-- Property Specials -->
      <cfinclude template="_property-specials.cfm">

      <!-- Property Tabs -->
      <div class="property-tabs-wrap">
        <div id="propertyTabsAnchor"><!-- TRAVEL STICKY TABS ANCHOR FOR SCROLL --></div>
        <ul id="propertyTabs" class="property-tabs tabs tab-group">
          <li><a href="#description"><i class="fa fa-align-left" aria-hidden="true"></i> <span>Description</span></a></li>
          <li><a href="#calendar"><i class="fa fa-calendar-check-o" aria-hidden="true"></i> <span>Calendar</span></a></li>
          <!--- <li><a href="#rates"><i class="fa fa-tags" aria-hidden="true"></i> <span>Rates</span></a></li> --->
          <li><a href="#amenities"><i class="fa fa-list" aria-hidden="true"></i> <span>Amenities</span></a></li>
          <li><a href="#reviews"><i class="fa fa-pencil-square-o" aria-hidden="true"></i> <span>(<cfoutput>#numReviews#</cfoutput>) Reviews</span></a></li>
          <li><a href="#qanda"><i class="fa fa-question-circle" aria-hidden="true"></i> <span>Q&A</span></a></li>
        </ul><!-- END propertyTabs -->
      </div>

      <!-- Property Description | #description -->
      <cfinclude template="_description-tab.cfm">

      <!-- Property Availability Calendar | #calendar -->
        <cfinclude template="_calendar-tab.cfm">
			

      <!-- Property Rates Table | #rates -->
      <!--- <cfinclude template="_rates-tab.cfm"> --->

      <!-- Property Amenities | #amenities -->
      <cfinclude template="_amenities-tab.cfm">

      <!-- Property Reviews | #reviews -->
      <cfinclude template="_reviews-tab.cfm">

      <!-- Property Inquire Form | #qanda -->
      <cfinclude template="_q-and-a-property.cfm">

      <!-- JUMP LINK IN _travel-dates.cfm Request More Info Button -->
      <cfinclude template="_request-info.cfm">

    </div><!-- END propertyDetails -->

    <div class="property-dates-wrap">
      <cfinclude template="_travel-dates.cfm">
    </div><!-- END property-dates-container -->

    <div class="mobile-dates-toggle-wrap">
      <button id="mobileDatesToggle" class="btn site-color-1-bg site-color-3-bg-hover text-white" type="button"><i class="fa fa-chevron-right" aria-hidden="true"></i> Get My Quote</button>
      <small>Find Available Dates For this Property</small>
    </div>
  </div><!-- END property-wrap -->

  <button id="returnToTop" class="btn site-color-3-bg site-color-4-bg-hover text-white" type="button"><i class="fa fa-chevron-up" aria-hidden="true"></i></button>

	<cfinclude template="/#settings.booking.dir#/components/property-modals.cfm">
	<cfinclude template="/#settings.booking.dir#/components/footer.cfm">

</cfif>

<cfcatch>
  <cfif cgi.remote_host eq '172.110.82.184'>
    <cfdump var="#cfcatch#" abort="true" />
  </cfif>
</cfcatch>

</cftry>