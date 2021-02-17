<cfset featured = false>
<cfif isDefined('session.booking.getResults') and isquery(session.booking.getResults)>
	<cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate and isdefined('form.specialid') and len(form.specialid) and form.specialid gt 0>
	    <!--- Check for any specials --->
	    <cfquery name="checkForSpecials" dataSource="#settings.dsn#">
		select id
		from cms_specials
		where #createodbcdate(session.booking.strcheckin)# between allowedbookingstartdate and allowedbookingenddate
		and id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.specialid#">
		and active = <cfqueryparam value = "yes" cfsqltype = "cf_sql_varchar">
	    </cfquery>

	    <cfif checkForSpecials.recordcount gt 0>
	    	<!--- We found a special, now get a list of units in the special --->
			<cfquery name="getSpecialUnits" dataSource="#settings.dsn#">
			select unitcode
			from cms_specials_properties
			where specialID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.specialid#">
			AND active = <cfqueryparam value = "yes" CFSQLType = "CF_SQL_VARCHAR">
			</cfquery>

			<cfset unitsWithSpecialList = ValueList(getSpecialUnits.unitcode)>
	    </cfif>
	<cfelseif isdefined('session.booking.searchByDate') and session.booking.searchByDate and isdefined('session.booking.strcheckin')>
	    <!--- if we are searching with dates, check for any valid specials --->
	    <cfquery name="checkForSpecials" dataSource="#settings.dsn#">
		select *
		from cms_specials
		where #now()# between startdate and enddate
		and #createodbcdate(session.booking.strcheckin)# between allowedBookingStartDate and allowedBookingEndDate
		and active = 'yes'
	    </cfquery>

	    <cfif checkForSpecials.recordcount gt 0>
		    <!--- Now that we have found a valid special, find the units in that special --->
			<cfquery name="getSpecialUnits" dataSource="#settings.dsn#">
			select unitcode,pricewas,pricereducedto
			from cms_specials_properties
			where specialid = <cfqueryparam cfsqltype="cf_sql_integer" value="#checkforspecials.id#">
			and active = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">
			</cfquery>

		    <cfset unitsWithSpecialList = ValueList(getSpecialUnits.unitcode)>
	    </cfif>
	</cfif>

	<div class="results-list-properties<cfif StructKeyExists(request,'resortContent')> resorts-list-properties</cfif><cfif featured> results-list-properties-featured</cfif>">
		<cfif featured>
			<div class="well">
				<h3 class="text-center text-upper">Featured Properties</h3>
				<div class="owl-carousel owl-theme results-featured-carousel">
			<cfelse>
				<ul class="row">
		</cfif>
	  	<!---
	      <cf_htmlfoot>
	        <cfif StructKeyExists(request,'ajaxCall') AND request.ajaxCall EQ 1>
	          <script language="javascript" type="application/javascript">
	            function updatePropertyPrice(id) {
	              $.ajax({
	                type: "GET",
	                url: bookingFolder+'/ajax/get-search-results-dated-rates.cfm?propertyid=' + id,
	                dataType: 'text',
	                success: function(data) {
	                  $('#propertyPrice'+id).html(data);
	                },
	                error: function(xhr, textStatus, error){
	                  //console.log(xhr.statusText);
	                  //console.log(textStatus);
	                  //console.log(error);
	                }
	              });
	            }
	          </script>
	        <cfelse>
	          <script language="javascript" type="application/javascript">
	            function updatePropertyPrice(id) {
	              $.ajax({
	                type: "GET",
	                url: bookingFolder+'/ajax/get-search-results-dated-rates.cfm?propertyid=' + id,
	                dataType: 'text',
	                success: function(data) {
	                  $('#propertyPrice'+id).html(data);
	                },
	                error: function(xhr, textStatus, error){
	                  //console.log(xhr.statusText);
	                  //console.log(textStatus);
	                  //console.log(error);
	                }
	              });
	            }
	          </script>
	        </cfif>
	      </cf_htmlfoot>
	  	--->
  		<!--- Use the form page data to override url.loop values for infinite scroll --->
		<cfif featured>
			<cfset url.loopend = ListLen(unitCodeListFeatured)>
		<cfelseif ListLen(unitCodeListFeatured) eq url.loopend>
			<cfset url.loopStart = 1>
			<cfset url.loopend = 12>
		<cfelseif url.loopend gt ListLen(unitCodeListForUse)>
			<cfset url.loopend = ListLen(unitCodeListForUse)>
		</cfif>

		<cfif isdefined('form.page') and featured is false>
			<cfset url.loopStart = form.page * 12 + 1>
			<cfset url.loopend = (form.page + 1) * 12>
		</cfif>

      <cfif url.loopend gt cookie.numresults>
        <cfset url.loopend = cookie.numresults>
      </cfif>

      <cfloop from="#url.loopStart#" to="#url.loopEnd#" index="i">
        <cftry>
          <cfset propertyid = ListGetAt(unitCodeListForUse,i)>
          <cfcatch><cfbreak></cfcatch>
        </cftry>

      	<cfquery name="getUnitInfo" dbtype="query">
        	select * from session.booking.getResults where propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#propertyid#">
      	</cfquery>
      	<!--- get 3 photos for each prop --->
      	<cfquery name="getphotos" datasource="#settings.dsn#" cachedwithin="#createTimespan( 0, 1, 0, 0 )#">
        	select *
          from track_properties_images
          where propertyId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#propertyid#" />
          order by `order`
          limit 3
      	</cfquery>

      	<cfset detailPage = '/#settings.booking.dir#/#getUnitInfo.seoPropertyName#'>

      	<cfoutput>
			<cfif featured>
				<div class="item">
			<cfelse>
				<li class="col-xlg-4 col-lg-6 col-md-6 col-sm-6">
			</cfif>

  	        <div class="results-list-property" data-mapMarkerID="#session.mapMarkerID#" data-unitcode="#propertyid#" data-id="#getUnitInfo.seoPropertyName#" id="#getUnitInfo.seoPropertyName#" data-seoname="#getUnitInfo.seoPropertyName#" data-unitshortname="#getUnitInfo.name#" data-photo="https://img.trackhs.com/565x367/#getUnitInfo.defaultPhoto#" data-latitude="#getUnitInfo.latitude#" data-longitude="#getUnitInfo.longitude#" data-straddress1="#getUnitInfo.address#" data-dblbeds="#getUnitInfo.bedrooms#" data-intoccu="#getUnitInfo.sleeps#" data-strlocation="#getUnitInfo.location#">
  	          <div class="results-list-property-img-wrap">

        				<cfif isdefined('unitsWithSpecialList') and listlen(unitsWithSpecialList) gt 0 and ListFind(unitsWithSpecialList,propertyid)>
	  		            <!--- At this point, we know this unit has a special --->
	  		            <button data-toggle="modal" data-target="##specialModal" class="results-list-property-special site-color-2-bg site-color-2-lighten-bg-hover text-white">
	  		              <i class="fa fa-tag site-color-3" aria-hidden="true"></i> Special
	  		            </button>

	                  	<div class="special-modal-content hidden">
		                    <cfquery name="getSpecial" dbtype="query">
		                    select title,description from checkForSpecials where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#checkForSpecials.id#">
		                    </cfquery>

		                    <cfoutput>
		                      <h4>#getSpecial.title#</h4>
		                      <p>#getSpecial.description#</p>
		                    </cfoutput>
	                  	</div><!-- END special-modal-content -->
  	            	</cfif>

  	            <!--- FAVORITE HEART --->
  	            <a href="javascript:;" class="results-list-property-favorite add-to-favs add-to-fav-results">
  	              <i class="fa fa-heart-o overlay" aria-hidden="true"></i>
  	              <i class="fa fa-heart under<cfif ListFind(cookie.favorites,propertyid)> favorited</cfif>" aria-hidden="true"></i>
  	            </a>
  	            <!--- PROPERTY LINK --->
  	            <a href="#detailPage#" class="results-list-property-link" target="_blank">
  	              <span class="results-list-property-title-wrap">
      						  <cfif len(getUnitInfo.avgRating)>
  		                <!--- PROPERTY RATING --->
  		                <span class="results-list-property-rating">
  		                	<cfif ceiling(getUnitInfo.avgRating) eq 1>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  <cfelseif ceiling(getUnitInfo.avgRating) eq 2>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  <cfelseif ceiling(getUnitInfo.avgRating) eq 3>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  <cfelseif ceiling(getUnitInfo.avgRating) eq 4>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  <cfelseif ceiling(getUnitInfo.avgRating) eq 5>
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
  	                  <h3>#getUnitInfo.name# <cfif getUnitInfo.petsallowed eq 'Pets Allowed' or getUnitInfo.petsallowed eq '-1' or getUnitInfo.petsallowed contains 'Pets Allowed'><span class="results-list-property-pet-friendly"><i class="fa fa-paw" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Pet Friendly"></i></span></cfif></h3>
      	            	<!--- PROPERTY TYPE --->
                      <cfif len(getUnitInfo.type)>
        	            	<span class="results-list-property-info-type">#getUnitInfo.type#</span>
        	            </cfif>
  	                  <!--- <em>#getUnitInfo.location#</em> --->
  	                </span>
  	              </span>
  	            </a>

  	            <div class="srp-img-placeholder">
                  <div class="cssload-container">
                    <div class="cssload-tube-tunnel"></div>
                  </div>
  	            </div>

  	            <cfif featured>
	                <a href="#detailPage#" class="results-list-property-link-img">
        						<cfif len(getUnitInfo.defaultPhoto)>
        							<span class="results-list-property-img lazy" data-src="https://img.trackhs.com/565x367/#getUnitInfo.defaultPhoto#"></span>
        						<cfelse>
        							<span class="results-list-property-img lazy" data-src="/#settings.booking.dir#/images/no-img.jpg"></span>
        						</cfif>
	                </a>
	  	          <cfelse>

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
  	            </cfif>

              </div><!-- END results-list-property-img-wrap -->

  	          <div class="results-list-property-info-wrap">
  	            <!--- PROPERTY PRICE --->
  	            <span class="results-list-property-info-price" id="propertyPrice#propertyid#">
                  <cfif session.booking.searchByDate>
                  	<cfif isdefined('verifySpecial') and verifySpecial.recordcount gt 0>
          						<!---
          						At this point, we know we have a valid special, now we just need to
          						see if the current property in the loop has any rates defined.
          						--->
          						<cfquery name="checkforspecialrates" datasource="#settings.dsn#">
            						select *
            						from cms_specials_properties
            						where specialid = <cfqueryparam cfsqltype="cf_sql_integer" value="#verifyspecial.id#">
            						and unitcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#propertyid#">
            						and active = <cfqueryparam value = "yes" cfsqltype = "cf_sql_varchar">
          						</cfquery>

          						<cfif checkForSpecialRates.recordcount gt 0 and
	                      		len(checkForSpecialRates.pricewas) and
	                        	len(checkForSpecialRates.pricereducedto) and
	                        	checkForSpecialRates.pricewas gt 0 and
	                        	checkForSpecialRates.pricereducedto gt 0>

	                        <span>
	                          Price was: <sup>$</sup>#checkForSpecialRates.pricewas# - Price reduced to: <sup>$</sup>#checkForSpecialRates.pricereducedto# <small>+Taxes and Fees</small>
	                        </span>
	                    <cfelse>
	                    	<!--- Search by dates, no special --->
	                    	<!---#dollarFormat(getUnitInfo.searchByDatePrice)# <small>+Taxes and Fees</small>--->
	                    	#application.bookingObject.getAjaxPriceBasedOnDates( propertyid, session.booking.strcheckin, session.booking.strcheckout )#
	                    </cfif>
  	                <cfelseif isdefined('unitsWithSpecialList') and listlen(unitsWithSpecialList) gt 0 and ListFind(unitsWithSpecialList,propertyid)>
          						<cfquery name="checkForSpecialRates" dbtype="query">
            						select PriceWas,PriceReducedTo
            						from getSpecialUnits
            						where unitcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#propertyid#">
          						</cfquery>

          						<cfif checkForSpecialRates.recordcount gt 0 and
        							  len(checkForSpecialRates.pricewas) and
        							  len(checkForSpecialRates.pricereducedto) and
        							  checkForSpecialRates.pricewas gt 0 and
        							  checkForSpecialRates.pricereducedto gt 0>
        							<span>
        							Price was: <sup>$</sup>#checkForSpecialRates.pricewas# - Price reduced to: <sup>$</sup>#checkForSpecialRates.pricereducedto# <small>+Taxes and Fees</small>
        							</span>
        						<cfelse>
                                	#application.bookingObject.getAjaxPriceBasedOnDates( propertyid, session.booking.strcheckin, session.booking.strcheckout )#
        						</cfif>
          					<cfelse>
          						<!---#dollarFormat(getUnitInfo.searchByDatePrice)# <small>+Taxes and Fees</small>--->
          						#application.bookingObject.getAjaxPriceBasedOnDates( propertyid, session.booking.strcheckin, session.booking.strcheckout )#
          					</cfif>
          				<cfelse>
          					<!--- Non-dated search, show price range --->
          					<cfset priceRange = application.bookingObject.getPropertyPriceRange(getUnitInfo.propertyid)>
	                  <!---#priceRange#--->
                  </cfif>
  	            </span>

  	            <!--- PROPERTY INFO --->
  	            <ul class="results-list-property-info">
  	               <cfif getUnitInfo.bedrooms gt 0>
                  	<li><i class="fa fa-bed site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Bedrooms"></i> #getUnitInfo.bedrooms# Beds</li>
                  <cfelseif getUnitInfo.bedrooms eq 0>
                  	<li><i class="fa fa-bed site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Bedrooms"></i> Studio</li>
                  </cfif>

                  <cfif getUnitInfo.bathrooms gt 0>
                  	<li><i class="fa fa-bath site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Bathrooms"></i>
                    	Full Baths: #getUnitInfo.bathrooms#<cfif getUnitInfo.threeQuarterBathrooms gt 0>, 3/4 Baths: #getUnitInfo.threeQuarterBathrooms#</cfif><cfif getUnitInfo.halfBathrooms gt 0>, Half Baths: #getUnitInfo.halfBathrooms# </cfif>
                    </li>
                  </cfif>

                  <cfif getUnitInfo.sleeps gt 0>
                  	<li><i class="fa fa-users site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Guests"></i> Sleeps #getUnitInfo.sleeps#</li>
                  </cfif>

                  <cfquery dbtype="query" NAME="GetPropertyViews">
                  	SELECT DISTINCT TrackingEmail,UserTrackerValue
                  	FROM GetPropertyViewsAll
                  	where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#propertyid#">
                  	GROUP BY TrackingEmail,UserTrackerValue
                  </cfquery>

                	<cfif GetPropertyViews.recordcount gte 10>
                		<li><i class="fa fa-binoculars site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="User Views"></i> #GetPropertyViews.recordcount#  Views</li>
                  	</cfif>
  	            </ul><!-- END results-list-property-info -->
              </div><!-- END results-list-property-info-wrap -->
	            <cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate and isdefined('session.booking.strcheckin') and session.booking.strcheckin neq '' and isdefined('session.booking.strcheckout') and session.booking.strcheckout neq ''>
                <div class="results-list-property-book-btn">
  	            	<cfif cgi.server_name eq settings.devURL>
  	            		<a target="_blank" href="/#settings.booking.dir#/book-now.cfm?propertyid=#propertyid#&strcheckin=#session.booking.strcheckin#&strcheckout=#session.booking.strcheckout#" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white results-list-property-booknow-btn">Book Now</a>
  	            	<cfelse>
  	            	  <a target="_blank" href="#settings.booking.bookingURL#/#settings.booking.dir#/book-now.cfm?propertyid=#propertyid#&strcheckin=#session.booking.strcheckin#&strcheckout=#session.booking.strcheckout#" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white results-list-property-booknow-btn">Book Now</a>
                  </cfif>
                </div><!-- END results-list-property-book-btn -->
	            </cfif>
  	        </div><!-- END results-list-property -->
  	        <cfif featured>
	  	        </div>
  	        </cfif>
  	      </li>
        </cfoutput>

        <cfset session.mapMarkerID = session.mapMarkerID + 1>
      </cfloop>
  <cfif featured>
      </div>
    </div>
  <cfelse>
    </ul>
  </cfif>
  </div><!-- END results-list-properties -->
</cfif>