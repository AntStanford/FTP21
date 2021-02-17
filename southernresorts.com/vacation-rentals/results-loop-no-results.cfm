  <style>
    #bottom-result { display: none; }
    div#map-all-results { display: none; }
   /* .results-list-wrap { width: 100%; }*/
  </style>
<div class="alert alert-danger no-search-results">
    Sorry, there are no properties matching your search criteria. <br />However, here are 2 random properties that you may like:
  </div>

  <cfset randomProperties = application.bookingObject.getRandomProperties()>

  <div class="results-list-properties results-list-suggested-properties">
    <div class="row">
      <cfloop query="randomProperties">
        <cfset detailPage = '/#settings.booking.dir#/#seoDestinationName#/#seoPropertyName#'>
        <cfoutput>
  	      <div class="<cfif cgi.script_name eq "/destination-page.cfm">col-xlg-4 col-lg-4 col-md-6 col-sm-6<cfelse>col-xlg-4 col-lg-6 col-md-6 col-sm-6 suggested-col-non-dest</cfif>">
  	        <div class="results-list-property">
  	          <div class="results-list-property-img-wrap">
	  	          <div class="view-prop-overlay">
	                  #description#
	                  <a href="#detailPage#" class="btn" target="_blank">View Property</a>
	              </div>
  	            <cfif len(defaultPhoto)>
                  <div class="owl-gallery-wrap">
		                <a href="javascript:;" class="results-list-property-favorite add-to-fav-results" <cfif isDefined("request.resortContent")>style="display: none;"</cfif>>
		  	              <i class="fa fa-heart-o overlay" aria-hidden="true"></i>
		  	              <i class="fa fa-heart under" aria-hidden="true"></i>
		  	            </a>
                    <div class="owl-carousel owl-theme owl-quick-gallery">
                      <!---<cfloop query="getUnitInfo">--->
                      <cfloop>
						            <cfif isDefined("getUnitinfo.nodeID") AND len(getUnitInfo.nodeid)>
													<cfquery datasource="#settings.dsn#" name="qryImages">
														 select * from track_nodes_images where nodeid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getunitinfo.nodeID#">
													</cfquery>
													<cfloop query="qryImages">
														<div class="item">
														  <a href="#detailPage#" class="results-list-property-link" target="_blank"><img class="owl-lazy" data-src="#original#"></a>
														</div>
													</cfloop>
												<cfelse>
												  <cfloop>
												    <div class="item">
													    <a href="#detailPage#" class="results-list-property-link" target="_blank"><img class="owl-lazy" data-src="https://img.trackhs.com/565x367/#defaultPhoto#"></a>
												    </div>
												  </cfloop>
												</cfif>
                        <!--- <div class="item"> --->
                      </cfloop>
                    </div>
                  </div>
                <cfelse>
                  <span class="results-list-property-img" style="background:url('/#settings.booking.dir#/images/no-img.jpg');"></span></a>
                </cfif>
								<!---
	              <cfif len(defaultPhoto)>
	                <span class="results-list-property-img" style="background:url('#defaultPhoto#');"></span>
	              <cfelse>
	              	<span class="results-list-property-img" style="background:url('/#settings.booking.dir#/images/no-img.jpg');"></span>
	              </cfif>
								--->

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
<!---         	            	<span class="results-list-property-info-type">#type#</span> hidden per client req--->
        	            </cfif>
  	                </span>
  	              </span>
  	            </a>

              </div><!-- END results-list-property-img-wrap -->

              <div class="results-list-property-info-wrap">
                <!--- PROPERTY INFO --->
                <ul class="results-list-property-info">
                   <cfif bedrooms gt 0>
                    <li><!--- <i class="fa fa-bed site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Bedrooms"></i> --->Bedrooms: #bedrooms#</li>
                  <cfelseif bedrooms eq 0>
                    <li><i class="fa fa-bed site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Bedrooms"></i> Studio</li>
                  </cfif>
                  <cfif bathrooms gt 0>
                    <li><!--- <i class="fa fa-bath site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Bathrooms"></i> --->Baths: #bathrooms# Full<cfif halfBathrooms GT 0>, #halfBathrooms# Half</cfif></li></cfif>
                  <cfif sleeps gt 0>
                    <li><!--- <i class="fa fa-users site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Guests"></i> --->#sleeps# Guests</li>
                  </cfif>
					<!---
                  <cfquery dbtype="query" NAME="GetPropertyViews">
                    SELECT DISTINCT TrackingEmail,UserTrackerValue
                    FROM GetPropertyViewsAll
                    where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#propertyid#">
                    GROUP BY TrackingEmail,UserTrackerValue
                  </cfquery>

                    <cfif GetPropertyViews.recordcount gte 10>
                        <li><i class="fa fa-binoculars site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="User Views"></i> #GetPropertyViews.recordcount#  Views</li>
                  </cfif>
--->

                </ul><!-- END results-list-property-info -->

                <!--- PROPERTY PRICE --->
                <span class="results-list-property-info-price">
                  <cfif session.booking.searchByDate>
                        <cfif isdefined('verifySpecial') and verifySpecial.recordcount gt 0>
                          <!---
                            At this point, we know we have a valid special, now we just need to
                            see if the current property in the loop has any rates defined.
                          --->
                          <cfquery name="checkForSpecialRates" dataSource="#settings.dsn#">
                            select * from cms_specials_properties where specialID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#verifySpecial.id#">
                            and unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#propertyid#">
                          </cfquery>
                          <cfif
                            checkForSpecialRates.recordcount gt 0 and
                            len(checkForSpecialRates.pricewas) and
                            len(checkForSpecialRates.pricereducedto) and
                            checkForSpecialRates.pricewas gt 0 and
                            checkForSpecialRates.pricereducedto gt 0>
                            <span>
                              Price was: <sup>$</sup>#checkForSpecialRates.pricewas# - Price reduced to: <sup>$</sup>#checkForSpecialRates.pricereducedto#
                            </span>
                          <cfelse>
                            <!--- Search by dates, no special --->
                            <cfif isDefined("request.resortContent")>
                            <cfset baseRate = application.bookingObject.getPriceBasedOnDates(propertyid,session.booking.strcheckin,session.booking.strcheckout)>
                            #baseRate#
                            <cfelse>
								<cfset priceRange = application.bookingObject.getPropertyPriceRange(propertyid)>
                     #priceRange#
                                <!--- #Dollarformat(minprice)# - #DollarFormat(maxprice)# /Night--->
                             </cfif>
                          </cfif>
                        <cfelse>
                             <!--- Search by dates, no special --->
                          <cfif isDefined("request.resortContent")>
                          <cfset baseRate = application.bookingObject.getPriceBasedOnDates(propertyid,session.booking.strcheckin,session.booking.strcheckout)>
                          #baseRate#
                              <cfelse>
                             <cfset priceRange = application.bookingObject.getPropertyPriceRange(propertyid)>
                     #priceRange#
                         </cfif>
                        </cfif>
                  <cfelse>
                    <!--- Non-dated search, show price range --->
                     <cfif isDefined("request.resortContent")>
                     <cfset priceRange = application.bookingObject.getPropertyPriceRange(propertyid)>
                     #priceRange#
                     <cfelse>
                         <cfset priceRange = application.bookingObject.getPropertyPriceRange(propertyid)>
                     #priceRange#
                     </cfif>
                  </cfif>
                  <div class="plus">plus taxes &amp; fees</div>
                </span>
                <!--- END PROPERTY PRICE --->
	  	          <cfif isDefined(".weddingDescription") and len(weddingDescription) gt 1 AND 0 EQ 1><div class="results-wedding-desc"><cfoutput><br> #weddingDescription#</cfoutput> <a href="#detailPage#" class="btn" target="_blank">Explore Venue</a></div><cfelse></cfif>
              </div><!-- END results-list-property-info-wrap -->


  	        </div>
  	      </div>
  	  	</cfoutput>
      </cfloop><!--END randomProperties-->
    </div>
  </div><!-- END results-list-properties results-list-suggested-properties -->