<!--- <cfdump var="#session.booking.getResults#" abort="true"> --->
<cfif isdefined('session.booking.unitCodeList') and ListLen(session.booking.unitCodeList) gt 0 and isdefined('session.booking.getResults')>
  <!--- Counting each marker to use for highlighting on the map --->
  <cfif !isdefined('session.mapMarkerID') or !isdefined('form.page') or (isdefined('form.page') and LEN(form.page) eq 0)>
    <cfset session.mapMarkerID ="0">
  </cfif>

  <cfset ThreeDaysEarlier = dateadd('d','-3',Now())>

  <cfquery datasource="#settings.dsn#" NAME="GetPropertyViewsAll">
  select distinct trackingemail,usertrackervalue,unitcode
  from be_prop_view_stats
  where createdat >= <cfqueryparam value="#threedaysearlier#" cfsqltype="cf_sql_timestamp">
  and unitcode in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.booking.unitcodelist#" list="yes">)
  group by trackingemail,usertrackervalue desc
  </cfquery>

  <cfquery name="GetFeaturedProps" datasource="#settings.dsn#">
  select strpropid as propertyid
  from cms_featured_properties
  WHERE 1 = 0 <!--- Prevents Executing this code --->
  </cfquery>

  <cfset featuredList = valueList( GetFeaturedProps.propertyid ) />
  <cfset unitCodeListFeatured = '' />
  <cfset unitCodeListNotFeatured = '' />

  <cfloop list="#session.booking.unitCodeList#" index="i">
    <cfif listFind( featuredList, i )>
      <cfset unitCodeListFeatured = listappend( unitCodeListFeatured, i ) />
    <cfelse>
      <cfset unitCodeListNotFeatured = listappend( unitCodeListNotFeatured, i ) />
    </cfif>
  </cfloop>

  <cfif ((isdefined('unitCodeListFeatured') and ListLen(unitCodeListFeatured) gt 0) or (isdefined('unitCodeListNotFeatured') and ListLen(unitCodeListNotFeatured) gt 0) ) and isdefined('session.booking.getResults')>
    <cfif isDefined('url.scroll')>
    <cfelseif listlen(unitCodeListFeatured) gt 0>
      <cfset featured = true>
      <cfset unitCodeListForUse = unitCodeListFeatured>
      <cfinclude template="results-loop_.cfm">
    </cfif>

    <cfset featured = false>
    <cfset unitCodeListForUse = session.booking.unitCodeList>
    <cfinclude template="results-loop_.cfm">
  </cfif>
<cfelse>

  <!--- HIDES LOADER ANIMATION --->
  <style>
    #bottom-result { display: none; }
  </style>

  <div class="alert alert-danger no-search-results">
    Sorry, there are no properties matching your search criteria. <br />However, here are 2 alternate properties that you may like:
  </div>

  <cfset randomProperties = application.bookingObject.getRandomProperties()>

  <div class="results-list-properties results-list-suggested-properties">
    <div class="row">
      <cfloop query="randomProperties">
      	<cfquery name="getphotos" datasource="#settings.dsn#" cachedwithin="#createTimespan( 0, 1, 0, 0 )#">
      	select *
        from track_properties_images
        where propertyId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#propertyid#" />
        order by `order`
        limit 3
      	</cfquery>

        <cfset detailPage = '/#settings.booking.dir#/#seoPropertyName#'>
        <cfoutput>
          <div class="col-xlg-4 col-lg-6 col-md-6 col-sm-6">
            <div class="results-list-property">
              <div class="results-list-property-img-wrap">
                <a href="javascript:;" class="results-list-property-favorite add-to-fav-results">
                  <i class="fa fa-heart-o overlay" aria-hidden="true"></i>
                  <i class="fa fa-heart under" aria-hidden="true"></i>
                </a>

                <a href="#detailPage#" class="results-list-property-link" target="_blank">
                  <span class="results-list-property-title-wrap">
                    <cfif len(avgRating)>
                      <span class="results-list-property-rating">
                        <cfif ceiling(avgRating) eq 1>
                          <i class="fa fa-star" aria-hidden="true"></i>
                          <i class="fa fa-star-o" aria-hidden="true"></i>
                          <i class="fa fa-star-o" aria-hidden="true"></i>
                          <i class="fa fa-star-o" aria-hidden="true"></i>
                          <i class="fa fa-star-o" aria-hidden="true"></i>
                        <cfelseif ceiling(avgRating) eq 2>
                          <i class="fa fa-star" aria-hidden="true"></i>
                          <i class="fa fa-star" aria-hidden="true"></i>
                          <i class="fa fa-star-o" aria-hidden="true"></i>
                          <i class="fa fa-star-o" aria-hidden="true"></i>
                          <i class="fa fa-star-o" aria-hidden="true"></i>
                        <cfelseif ceiling(avgRating) eq 3>
                          <i class="fa fa-star" aria-hidden="true"></i>
                          <i class="fa fa-star" aria-hidden="true"></i>
                          <i class="fa fa-star" aria-hidden="true"></i>
                          <i class="fa fa-star-o" aria-hidden="true"></i>
                          <i class="fa fa-star-o" aria-hidden="true"></i>
                        <cfelseif ceiling(avgRating) eq 4>
                          <i class="fa fa-star" aria-hidden="true"></i>
                          <i class="fa fa-star" aria-hidden="true"></i>
                          <i class="fa fa-star" aria-hidden="true"></i>
                          <i class="fa fa-star" aria-hidden="true"></i>
                          <i class="fa fa-star-o" aria-hidden="true"></i>
                        <cfelseif ceiling(avgRating) eq 5>
                          <i class="fa fa-star" aria-hidden="true"></i>
                          <i class="fa fa-star" aria-hidden="true"></i>
                          <i class="fa fa-star" aria-hidden="true"></i>
                          <i class="fa fa-star" aria-hidden="true"></i>
                          <i class="fa fa-star" aria-hidden="true"></i>
                        </cfif>
                      </span>
                    </cfif>
                    <!--- PROPERTY NAME AND LOCATION --->
                    <span class="results-list-property-title">
                      <h3>#name# <cfif petsallowed eq 'Pets Allowed' or petsallowed eq '-1' or petsallowed contains 'Pets Allowed'><span class="results-list-property-pet-friendly"><i class="fa fa-paw" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Pet Friendly"></i></span></cfif></h3>
                      <!--- PROPERTY TYPE --->
                      <cfif len(type)>
                        <span class="results-list-property-info-type">#type#</span>
                      </cfif>
                    </span>
                  </span>

                  <cfif len(defaultPhoto)>
                    <span class="results-list-property-img lazy" data-src="https://img.trackhs.com/565x367/#defaultPhoto#"></span>
                  <cfelse>
                    <span class="results-list-property-img lazy" data-src="/#settings.booking.dir#/images/no-img.jpg"></span>
                  </cfif>
                </a>
  	            <div class="srp-img-placeholder">
                  <div class="cssload-container">
                    <div class="cssload-tube-tunnel"></div>
                  </div>
  	            </div>

	              <!--- PROPERTY IMAGE --->
		            <cfif getphotos.recordcount gt 0>
  	              <div class="owl-carousel owl-theme result-property-carousel">
    	              <cfloop query="getphotos">
                      <a href="#detailPage#" class="item results-list-property-img owl-lazy" data-src="https://img.trackhs.com/565x367/#original#" target="_blank">
                        <span class="hidden">Prop Image</span>
                      </a>
    	              </cfloop>
  	              </div>

  	              <span class="owl-prev-custom">
  	                <i class="fa fa-chevron-left text-white"></i>
  	              </span>
  	              <span class="owl-next-custom">
  	                <i class="fa fa-chevron-right text-white"></i>
  	              </span>

  	      			<cfelse>

              		<a href="#detailPage#" class="results-list-property-link-img">
        						<cfif len(getUnitInfo.defaultPhoto)>
        							<span class="results-list-property-img lazy" data-src="https://img.trackhs.com/565x367/#getUnitInfo.defaultPhoto#"></span>
        						<cfelse>
        							<span class="results-list-property-img lazy" data-src="/#settings.booking.dir#/images/no-img.jpg"></span>
        						</cfif>
              		</a>
              	</cfif>

              </div><!-- END results-list-property-img-wrap -->

              <div class="results-list-property-info-wrap">
                <span class="results-list-property-info-price">
                  <cfset priceRange = application.bookingObject.getPropertyPriceRange(propertyid)>
                  #priceRange#
                </span>

                <ul class="results-list-property-info">
                  <li><i class="fa fa-bed site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="" data-original-title="Bedrooms"></i> #bedrooms#</li>
                  <li><i class="fa fa-bath site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="" data-original-title="Bathrooms"></i> #bathrooms#</li>
                  <li><i class="fa fa-users site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="" data-original-title="Guests"></i> #sleeps#</li>

                  <cfset ThreeDaysEarlier = dateadd('d','-3',Now())>

                  <cfquery datasource="#settings.dsn#" NAME="GetPropertyViews">
                  select distinct trackingemail,usertrackervalue
                  from be_prop_view_stats
                  where createdat >= <cfqueryparam value="#threedaysearlier#" cfsqltype="cf_sql_timestamp">
                  and unitcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#propertyid#">
                  group by trackingemail,usertrackervalue desc
                  </cfquery>
                  <!--- <cfif GetPropertyViews.recordcount gte 10> --->
                  <li><i class="fa fa-binoculars site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="User Views"></i> 25 Views</li>
                  <!--- </cfif> --->
                </ul><!-- END results-list-property-info -->
                <span class="results-list-property-info-type">#type#</span>
               </div><!-- END results-list-property-info-wrap -->
            </div>
          </div>
        </cfoutput>
      </cfloop>
    </div>
  </div><!-- END results-list-properties -->

  <cfset Cffp = CreateObject("component","cfformprotect.cffpVerify").init() />

  <div class="results-inquiry-form-wrap">
    <div class="results-inquiry-form-text">
      <div class="results-inquiry-form-caption">Tell us what you're looking for and someone will contact you with available options.</div>
      <div id="noResultsContactFormMSG"></div>
    </div>
    <form class="results-inquiry-form" id="noResultsContactForm" method="post">
      <cfinclude template="/cfformprotect/cffp.cfm">
      <input type="hidden" name="noResultsContactForm">
      <fieldset>
        <div class="form-group col-xs-12 col-md-6">
          <input id="" name="firstName" type="text" placeholder="First Name" class="form-control required">
        </div>
        <div class="form-group col-xs-12 col-md-6">
          <input id="" name="lastName" type="text" placeholder="Last Name" class="form-control required">
        </div>
        <div class="form-group col-xs-12 col-md-6">
          <input id="" name="phone" type="text" placeholder="Phone" class="form-control">
        </div>
        <div class="form-group col-xs-12 col-md-6">
          <input id="" name="email" type="text" placeholder="Email" class="form-control required">
        </div>
        <div class="form-group col-xs-12 col-md-6">
          <select class="selectpicker" name="numberOfBeds">
            <option data-hidden="true" value="">Number of Bedrooms</option>
            <cfloop from="1" to="6" index="i">
              <option><cfoutput>#i#</cfoutput></option>
            </cfloop>
          </select>
        </div>
        <div class="form-group col-xs-12 col-md-6">
          <input id="" name="budget" type="text" placeholder="Approximate Budget" class="form-control">
        </div>
        <div class="form-group col-xs-12 col-md-6">
          <input id="" name="arrivalDate" type="text" placeholder="Arrival Date" class="form-control datepicker datepicker-start">
        </div>
        <div class="form-group col-xs-12 col-md-6">
          <input id="" name="departureDate" type="text" placeholder="Departure Date" class="form-control datepicker datepicker-end">
        </div>
        <div class="form-group col-xs-12 col-md-6">
          <select class="selectpicker" name="numAdults">
            <option data-hidden="true" value="">Num Adults</option>
            <cfloop from="1" to="20" index="i">
              <option><cfoutput>#i#</cfoutput></option>
            </cfloop>
          </select>
        </div>
        <div class="form-group col-xs-12 col-md-6">
          <select class="selectpicker" name="numChildren">
            <option data-hidden="true" value="">Num Children</option>
            <cfloop from="1" to="20" index="i">
              <option><cfoutput>#i#</cfoutput></option>
            </cfloop>
          </select>
        </div>
        <div class="form-group form-group-full col-xs-12 col-md-12">
          <textarea id="comments" name="comments" placeholder="I am looking for...." class="form-control"></textarea>
        </div>
        <div class="form-group col-xs-12 col-md-12">
          <div class="well input-well">
            <input id="optinNoResults" name="optin" type="checkbox" value="Yes"> <label for="optinNoResults">I agree to receive information about your rentals, services and specials via phone, email or SMS.<br >
            You can unsubscribe at anytime. <a href="/about-us/privacy-policy/" target="_blank">Privacy Policy</a></label>
          </div>
        </div>
        <div class="form-group col-xs-12 col-md-12 nomargin">
          <input type="submit" value="Submit" id="contactform" name="contactform" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white text-white-hover">
        </div>
      </fieldset>
    </form>
  </div><!-- END results-inquiry-form-wrap -->

</cfif>