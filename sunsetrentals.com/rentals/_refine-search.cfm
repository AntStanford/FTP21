<form class="refine-form mobile-hidden" id="refineForm" method="post" action="/<cfoutput>#settings.booking.dir#</cfoutput>/results.cfm">
  <!--- Page Count for Infinite Scroll --->
  <input type="hidden" name="page" value="0">
  <input type="hidden" name="camefromsearchform" >
  <input type="hidden" name="mapBounds" id="mapBounds" value="">
  <cfoutput>
  <cfif StructKeyExists(session.booking,'specialID')>
  	<input type="hidden" name="specialID" value="#session.booking.specialID#" />
  </cfif>
	</cfoutput>
  
  <!--- flex days - have we "flexed" (clicked a tab link)? this field will be either 'early', 'late', or blank --->
  <input type="hidden" name="flexed" id="flexed"
    <cfif isDefined('session.booking.flexed') and len(session.booking.flexed)>
      <cfoutput>value="#session.booking.flexed#"</cfoutput>
    </cfif>
  >
  <input type="hidden" name="complex" id="complex" value="<cfif isDefined('session.booking.complex') and len(session.booking.complex)><cfoutput>#session.booking.complex#</cfoutput></cfif>">

  <cfif
  	isdefined('session.booking.strcheckin') and
  	len(session.booking.strcheckin) and
  	isvalid('date',session.booking.strcheckin) and
  	isdefined('session.booking.strcheckout') and
  	len(session.booking.strcheckout) and
  	isvalid('date',session.booking.strcheckout)>
		<cfset numNights = DateDiff('d',session.booking.strcheckin,session.booking.strcheckout)>
		<cfif numNights lt 7>
			<input type="hidden" name="refineSearchType" value="nightly" id="refineSearchType">
		<cfelse>
		  <input type="hidden" name="refineSearchType" value="weekly" id="refineSearchType">
		</cfif>
  <cfelse>
		<input type="hidden" name="refineSearchType" value="weekly" id="refineSearchType">
  </cfif>

  <!--- SortBy Hidden Input --->
  <cfif isdefined('session.booking.strSortBy') and len(session.booking.strSortBy)>
    <cfoutput><input type="hidden" name="strSortBy" value="#session.booking.strSortBy#"></cfoutput>
  <cfelse>
    <input type="hidden" name="strSortBy" value="P">
  </cfif>

  <!--- Refine Dates --->
  <div class="refine-item refine-dates">
    <div class="refine-text">
      <span class="refine-arrival">
        <i class="fa fa-calendar site-color-1" aria-hidden="true"></i>
				<cfif isdefined('session.booking.strcheckin') and len(session.booking.strcheckin)>
				  <input type="text" name="strCheckin" id="startDateRefine" placeholder="Arrival" value="<cfoutput>#session.booking.strcheckin#</cfoutput>" readonly class="date-entered">
				<cfelse>
				  <input type="text" name="strCheckin" id="startDateRefine" placeholder="Arrival" value="" readonly>
				</cfif>
      </span>
      <i class="fa fa-long-arrow-right" aria-hidden="true"></i>
      <span class="refine-departure">
        <i class="fa fa-calendar site-color-1" aria-hidden="true"></i>
				<cfif isdefined('session.booking.strcheckout') and len(session.booking.strcheckout)>
          <input type="text" name="strCheckout" id="endDateRefine" placeholder="Departure" value="<cfoutput>#session.booking.strcheckout#</cfoutput>" readonly class="date-entered">
				<cfelse>
          <input type="text" name="strCheckout" id="endDateRefine" placeholder="Departure" value="" readonly>
				</cfif>
      </span>
      <i class="fa fa-chevron-down" aria-hidden="true"></i>
    </div>
    <div class="refine-dropdown datepicker-wrap hidden">
      <div id="refineDatepicker"></div>

      <cfif mobileDetect><!--- SHOW FLEX CHECKBOX FOR MOBILE ONLY --->
        <div class="flex-wrap">
          <!--- Flexible Dates --->
          <cfif isdefined('session.booking.flex_dates') and session.booking.flex_dates eq 'on'>
            <input type="checkbox" id="flexDates" name="flex_dates" checked="checked" value="on">
          <cfelse>
            <input type="checkbox" id="flexDates" name="flex_dates" value="on">
          </cfif>
          <label for="flexDates" data-toggle="tooltip" data-placement="bottom" title="Search for Flexible Check-in Days">Flexible Check-In</label>
        </div>
      </cfif>

      <a href="javascript:;" class="btn btn-sm btn-default text-center pull-left refine-close site-color-1-bg text-white">Close</a>
      <a href="javascript:;" class="btn btn-sm btn-default text-center pull-left refine-clear">Clear Dates</a>
      <a href="javascript:;" class="btn btn-sm btn-default text-center pull-right refine-apply site-color-2-bg text-white" id="refineDatesApply">Apply</a>
    </div>
  </div>

  <cfif !mobileDetect><!--- SHOW INLINE FLEX CHECKBOX FOR DESKTOP ONLY --->
    <!--- Flexible Dates --->
    <div class="refine-item refine-checkbox">
      <cfif isdefined('session.booking.flex_dates') and session.booking.flex_dates eq 'on'>
        <input type="checkbox" id="flexDates" name="flex_dates" checked="checked" value="on">
      <cfelse>
        <input type="checkbox" id="flexDates" name="flex_dates" value="on">
      </cfif>
      <label for="flexDates" data-toggle="tooltip" data-placement="bottom" title="Search for Flexible Check-in Days">Flexible<br>Check-In</label>
    </div>
  </cfif>

  <!--- Refine Guests --->
  <div class="refine-item refine-guests refine-guests-counter-wrap">
    <div class="refine-text">
      <i class="fa fa-users site-color-1" aria-hidden="true"></i>
      <span class="refine-count">
        <cfif isdefined('session.booking.sleeps') and len(session.booking.sleeps) and session.booking.sleeps gt 0>
          <cfoutput>#session.booking.sleeps#</cfoutput>
        <cfelse>
          <cfoutput>#settings.booking.minOccupancy#</cfoutput>
        </cfif>
      </span> Guests
      <i class="fa fa-chevron-down" aria-hidden="true"></i>
			<cfif isdefined('session.booking.sleeps') and len(session.booking.sleeps) and session.booking.sleeps gt 0>
				<cfoutput><input type="hidden" name="sleeps" value="#session.booking.sleeps#"></cfoutput>
			<cfelse>
			  <cfoutput><input type="hidden" name="sleeps" value="#settings.booking.minOccupancy#"></cfoutput>
			</cfif>
    </div>
    <div class="refine-dropdown refine-counter text-center hidden">
      <i class="fa fa-minus site-color-2-bg site-color-2-lighten-bg-hover text-white disabled" aria-hidden="true"></i>
      <span class="refine-drop-count" data-min="<cfoutput>#settings.booking.minOccupancy#</cfoutput>" data-max="<cfoutput>#settings.booking.maxOccupancy#</cfoutput>">
        <cfif isdefined('session.booking.sleeps') and len(session.booking.sleeps) and session.booking.sleeps gt 0>
          <cfoutput>#session.booking.sleeps#</cfoutput>
        <cfelse>
          <cfoutput>#settings.booking.minOccupancy#</cfoutput>
        </cfif>
      </span>
      <i class="fa fa-plus site-color-2-bg site-color-2-lighten-bg-hover text-white" aria-hidden="true"></i>
      <a href="javascript:;" class="btn btn-block btn-sm btn-default text-center refine-apply site-color-2-bg text-white" id="refineGuestsCountApply">Apply</a>
    </div>
  </div>

<!---
  <!--- Refine Bedrooms --->
  <div class="refine-item refine-bedrooms refine-bedrooms-counter-wrap">
    <div class="refine-text">
      <i class="fa fa-bed site-color-1" aria-hidden="true"></i>
      <span class="refine-count">
        <cfif isdefined('session.booking.bedrooms') and len(session.booking.bedrooms) and session.booking.bedrooms gt 0>
          <cfoutput>#session.booking.bedrooms#</cfoutput>
        <cfelse>
          <cfoutput>#settings.booking.minBed#</cfoutput>
        </cfif>
      </span> Bedrooms
      <i class="fa fa-chevron-down" aria-hidden="true"></i>
			<cfif isdefined('session.booking.bedrooms') and len(session.booking.bedrooms) and session.booking.bedrooms gt 0>
				<cfoutput><input type="hidden" name="bedrooms" value="#session.booking.bedrooms#"></cfoutput>
			<cfelse>
			  <cfoutput><input type="hidden" name="bedrooms" value="#settings.booking.minBed#"></cfoutput>
			</cfif>
    </div>
    <div class="refine-dropdown refine-counter text-center hidden">
      <i class="fa fa-minus site-color-2-bg site-color-2-lighten-bg-hover text-white disabled" aria-hidden="true"></i>
      <span class="refine-drop-count refine-beds" data-min="<cfoutput>#settings.booking.minBed#</cfoutput>" data-max="<cfoutput>#settings.booking.maxBed#</cfoutput>">
        <cfif isdefined('session.booking.bedrooms') and len(session.booking.bedrooms) and session.booking.bedrooms gt 0>
          <cfoutput>#session.booking.bedrooms#</cfoutput>
        <cfelse>
          <cfoutput>#settings.booking.minBed#</cfoutput>
        </cfif>
      </span>
      <i class="fa fa-plus site-color-2-bg site-color-2-lighten-bg-hover text-white" aria-hidden="true"></i>
      <a href="javascript:;" class="btn btn-block btn-sm btn-default text-center refine-apply site-color-2-bg text-white" id="refineBedsCountApply">Apply</a>
    </div>
  </div>
--->

  <!--- Refine Bedrooms --->
  <div class="refine-item refine-bedrooms refine-slider refine-slider-bedrooms-wrap">
    <div class="refine-text">
      <i class="fa fa-bed site-color-1" aria-hidden="true"></i>
      <span class="refine-text-title">Bedrooms</span>

      <span class="refine-min-max hidden">
          <cfif isdefined('session.booking.bedrooms') and session.booking.bedrooms gt 0  and settings.booking.minBed eq 0>
           <span id="refineBedroomsMin" value="<cfoutput>#session.booking.bedrooms#</cfoutput>"></span> to <span value="<cfoutput>#session.booking.bedrooms#</cfoutput>" id="refineBedroomsMax"><cfoutput>#session.booking.bedrooms#</cfoutput></span> Bedrooms
        <cfelse>
            <span id="refineBedroomsMin"></span> to <span id="refineBedroomsMax"></span> Bedrooms
        </cfif>

      </span>

      <i class="fa fa-chevron-down" aria-hidden="true"></i>
    </div>

    <div class="refine-dropdown hidden">
      <span class="refine-dropdown-title">Bedrooms</span>

      <div class="refine-slider-wrap">
        <div id="refineBedroomsSlider"></div>

        <cfif isdefined('session.booking.bedrooms') and len(session.booking.bedrooms) and session.booking.bedrooms gt 0>
					<cfoutput><input type="hidden" name="bedrooms" value="#session.booking.bedrooms#"></cfoutput>
				<cfelse>
				  <input type="hidden" name="bedrooms">
				</cfif>
      </div>

      <a href="javascript:;" class="btn btn-sm btn-default text-center pull-left refine-close site-color-1-bg text-white" id="refineBedroomsClose">Close / Clear</a>
      <a href="javascript:;" class="btn btn-sm btn-default text-center pull-right refine-apply site-color-2-bg text-white" id="refineBedroomsApply">Apply</a>
    </div>
  </div>

  <!--- Refine Price --->
  <div class="refine-item refine-price refine-slider refine-slider-price-wrap">
    <div class="refine-text">
      <i class="fa fa-tag site-color-1" aria-hidden="true"></i>
      <span class="refine-text-title">Price Range</span>
      <span class="refine-min-max hidden">
        $<span id="refinePriceMin"></span> to $<span id="refinePriceMax"></span>
      </span>
      <i class="fa fa-chevron-down" aria-hidden="true"></i>
    </div>
    <div class="refine-dropdown hidden">
      <span class="refine-dropdown-title">Price Range</span>
      <div class="refine-slider-wrap">
        <div id="refinePriceSlider"></div>
				<cfif isdefined('session.booking.rentalRate') and len(session.booking.rentalRate)>
			    <cfoutput><input type="hidden" name="rentalRate" value="#session.booking.rentalRate#"></cfoutput>
				<cfelse>
			    <input type="hidden" name="rentalRate">
				</cfif>
      </div>
      <a href="javascript:;" class="btn btn-sm btn-default text-center pull-left refine-close site-color-1-bg text-white" id="refinePriceClose">Close / Clear</a>
      <a href="javascript:;" class="btn btn-sm btn-default text-center pull-right refine-apply site-color-2-bg text-white" id="refinePriceApply">Apply</a>
    </div>
  </div>

  <!--- Refine More Filters --->
  <div class="refine-item refine-filters">
    <div class="refine-text site-color-2-bg text-white">
      <div rel="tooltip" data-placement="bottom" title="Refine with Advanced Search Filters">
        <i class="fa toggle text-white" aria-hidden="true"></i> Filters <span id="filtersCount"></span> <i class="fa fa-chevron-down" aria-hidden="true"></i>
      </div>
    </div>
    <div class="refine-filter-box hidden">
      <div class="refine-filter-box-auto">
        <span class="refine-filter-heading site-color-1">Filters</span>
<!---
        <cfif listlen(otherFilters)>
          <!--- Other Filters --->
          <div class="refine-filter-section refine-filter-area">
            <span class="refine-filter-heading-sub">Other Filters</span>
            <div class="row">
              <cfloop list="#otherFilters#" index="i">
                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                  <cfoutput>
                    <div class="form-group" <cfif i eq 'Long Term Rentals'>hidden</cfif>><!--- 2018-11-08 - hiding filtercount per A.Doute & J.Norman --->
                      <!--- <cfset filterCount = application.bookingObject.getSearchFilterCount(i,'other')> --->
                      <input class="refine-filter-checkbox" type="checkbox" id="#i#" name="must_haves" value="#i#"
                        <cfif isdefined('session.booking.must_haves') and ListFind(session.booking.must_haves,'#i#')> checked="checked"</cfif>>
                      <label for="#i#">#i# <!--- (#filterCount#) ---></label>
                    </div>
                  </cfoutput>
                </div>
              </cfloop>
            </div>
          </div>
        </cfif>
--->

        <!--- Property Type --->
        <cfif listlen(settings.booking.typeList)>
          <!--- Refine Filter Unit Type --->
          <div class="refine-filter-section refine-filter-unit-type">
            <span class="refine-filter-heading-sub">
              Property Type
              <span class="refine-select-all-wrap">
                <input type="checkbox" class="refine-filter-select-all" id="selectAllUnitType">
                <label for="selectAllUnitType" class="select-all">Select All</label>
              </span>
            </span>
            <div class="row">
              <cfloop list="#settings.booking.typeList#" index="i">
                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                  <cfoutput>
                    <div class="form-group"><!--- 2018-11-08 - hiding filtercount per A.Doute & J.Norman --->
                      <!--- <cfset filterCount = application.bookingObject.getSearchFilterCount(i,'type')> --->
                      <input class="refine-filter-checkbox" type="checkbox" id="#i#" name="type" value="#i#"
                        <cfif isdefined('session.booking.type') and ListFind(session.booking.type,'#i#')>
                          checked="checked"
                        </cfif>
                      >
                      <label for="#i#">#i# <!--- (#filterCount#) ---></label>
                    </div>
                  </cfoutput>
                </div>
              </cfloop>
            </div>
          </div>
        </cfif>

        <!--- Locations --->
        <cfif isdefined('getTowns') and getTowns.recordcount gt 0>
          <div class="refine-filter-section refine-filter-area">
            <span class="refine-filter-heading-sub">
              Locations
              <span class="refine-select-all-wrap">
                <input type="checkbox" class="refine-filter-select-all" id="selectAllTowns">
                <label for="selectAllTowns" class="select-all">Select All</label>
              </span>
            </span>
            <div class="row">
              <cfloop query="settings.booking.locations">
                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                  <cfoutput>
                    <div class="form-group">
                      <input class="refine-filter-checkbox" type="checkbox" id="#id#" name="town" value="#id#"
                        <cfif (isdefined('session.booking.must_haves') and ListFind(session.booking.must_haves,'#id#'))
												      OR (isdefined('session.booking.town') and ListFind(session.booking.town,'#id#'))> checked="checked"</cfif>>
                      <label for="#id#">#name#</label>
                    </div>
                  </cfoutput>
                </div>
              </cfloop>
            </div>
          </div>
        </cfif>


        <!---  Amenities --->
        <cfif isdefined('getAmenities')>
          <!--- Define the first category --->
          <cfset theCategory = getAmenities.category>

  	      <!--- Refine Filter Amenities --->
  	      <div class="refine-filter-section refine-filter-amenities">
  	        <span class="refine-filter-heading-sub">
  	          Amenities
    	        <span class="refine-select-all-wrap">
      	        <input type="checkbox" class="refine-filter-select-all" id="selectAllAmenities">
                <label for="selectAllAmenities" class="select-all">Select All</label>
    	        </span>
  	        </span>
  	        <div class="row">
		          <cfif getAmenities.recordcount gt 0>
  		          <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
  		            <cfoutput>
  		            <div class="form-group">
                    <div class="row">
        		          <!--- <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
      		            	<p><b>#theCategory#</b></p>
        		          </div> --->
    		            	<cfloop query="getAmenities">

    		            		<cfif getAmenities.category eq theCategory or 1 eq 1>
    											<!--- don't show the category, we've already seen it --->
      									<cfelse>
      										<cfset theCategory = getAmenities.category>
            		          <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
        										<p><b>#theCategory#</b></p>
            		          </div>
      									</cfif>

          		          <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
          		            <div class="form-group">
      	  		            	<input class="refine-filter-checkbox" type="checkbox" id="#title#" name="amenities" value="#title#"
      	  		            		<cfif
      	  		            			(isdefined('session.booking.amenities') and ListFind(session.booking.amenities,'#title#'))
      	  		            			OR
      	  		            			(isdefined('session.booking.must_haves') and ListFind(session.booking.must_haves,'#title#'))
      	  		            			> checked="checked"</cfif>>
      	    		            <label for="#title#">#title#</label>
                          </div>
                        </div>
                      </cfloop>
                    </div>
			            </div>
                  </cfoutput>
  		          </div>
		          </cfif>
  	        </div>
  	      </div>
        </cfif>

  		  <!--- <cfif listlen(settings.booking.typeList)>
  	      <!--- Refine Filter Unit Type --->
  	      <div class="refine-filter-section refine-filter-unit-type">
  	        <span class="refine-filter-heading-sub">
  	          Unit Type
    	        <span class="refine-select-all-wrap">
      	        <input type="checkbox" class="refine-filter-select-all" id="selectAllUnitType">
                <label for="selectAllUnitType" class="select-all">Select All</label>
    	        </span>
    	      </span>
  	        <div class="row">
  	          <cfloop list="#settings.booking.typeList#" index="i">
  		          <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
  		            <cfoutput>
                    <div class="form-group"><!--- 2018-11-08 - hiding filtercount per A.Doute & J.Norman --->
    		            	<!--- <cfset filterCount = application.bookingObject.getSearchFilterCount(i,'type')> --->
      		            <input class="refine-filter-checkbox" type="checkbox" id="#i#" name="type" value="#i#"
	      		            <cfif isdefined('session.booking.must_haves') and ListFind(session.booking.must_haves,'#i#')>
	      		            	checked="checked"
	      		            </cfif>
      		            >
      		            <label for="#i#">#i# <!--- (#filterCount#) ---></label>
  		            	</div>
  		            </cfoutput>
  		          </div>
  	          </cfloop>
  	        </div>
  	      </div>
        </cfif> --->







	      <cfif isdefined('getNeighborhoods') and getNeighborhoods.recordcount gt 0>
  	      <div class="refine-filter-section refine-filter-area">
  	        <span class="refine-filter-heading-sub">
  	          Neighborhoods
    	        <span class="refine-select-all-wrap">
      	        <input type="checkbox" class="refine-filter-select-all" id="selectAllNeighborhoods">
                <label for="selectAllNeighborhoods" class="select-all">Select All</label>
    	        </span>
    	      </span>
  	        <div class="row">
  	          <cfloop query="getNeighborhoods">
  		          <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
  		            <cfoutput>
    		            <div class="form-group">
      		            <input class="refine-filter-checkbox" type="checkbox" id="#id#" name="neighborhoods" value="#id#"
      		            	<cfif (isdefined('session.booking.must_haves') and ListFind(session.booking.must_haves,'#id#')) OR (isdefined('session.booking.neighborhoods') and ListFind(session.booking.neighborhoods,'#id#'))> checked="checked"</cfif>>
      		            <label for="#id#">#name#</label>
        		        </div>
      		        </cfoutput>
  		          </div>
  	          </cfloop>
  	        </div>
  	      </div>
	      </cfif>

	      <cfif isdefined('getBuildingComplexes') and getBuildingComplexes.recordcount gt 0>
  	      <div class="refine-filter-section refine-filter-area">
  	        <span class="refine-filter-heading-sub">
  	          Building / Complex
    	        <span class="refine-select-all-wrap">
      	        <input type="checkbox" class="refine-filter-select-all" id="selectAllBuildingComplexes">
                <label for="selectAllBuildingComplexes" class="select-all">Select All</label>
    	        </span>
    	      </span>
  	        <div class="row">
  	          <cfloop query="getBuildingComplexes">
  		          <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
  		            <cfoutput>
    		            <div class="form-group">
      		            <input class="refine-filter-checkbox" type="checkbox" id="#id#" name="buildingComplex" value="#id#"
      		            	<cfif (isdefined('session.booking.must_haves') and ListFind(session.booking.must_haves,'#id#')) OR (isdefined('session.booking.buildingComplex') and ListFind(session.booking.buildingComplex,'#id#'))> checked="checked"</cfif>>
      		            <label for="#id#">#name#</label>
        		        </div>
      		        </cfoutput>
  		          </div>
  	          </cfloop>
  	        </div>
  	      </div>
	      </cfif>

        <!--- Refine Filter Specific Property
        <div class="refine-filter-section refine-filter-specific-property">
          <span class="refine-filter-heading-sub">Looking for a specific property?<br><small>Search by unit name or number.</small></span>
          <div class="row">
            <div class="col-lg-2 col-md-2 col-sm-3 col-xs-12">
              <label>Name:</label>
            </div>
            <div class="col-lg-10 col-md-10 col-sm-9 col-xs-12">
              <select class="refine-filter-specific-property-select selectpicker" name="unitname">
                <option value="">- Choose One -</option>
                <cfloop query="settings.booking.properties">
                  <cfoutput><option value="/#settings.booking.dir#/#settings.booking.properties.seoPropertyName#">#settings.booking.properties.name#</option></cfoutput>
                </cfloop>
              </select>
            </div>
          </div>
          <div class="row">
            <div class="col-lg-2 col-md-2 col-sm-3 col-xs-12">
              <label>Number:</label>
            </div>
            <div class="col-lg-10 col-md-10 col-sm-9 col-xs-12">
              <select class="refine-filter-specific-property-select selectpicker" name="propertyid">
                <option value="">- Choose One -</option>
                <cfloop query="settings.booking.propertiesByID">
                  <cfoutput><option value="/#settings.booking.dir#/#settings.booking.propertiesByID.seoPropertyName#">#settings.booking.propertiesById.propertyid#</option></cfoutput>
                </cfloop>
              </select>
            </div>
          </div>
        </div>--->

      </div>

      <!--- Refine Filter Actions --->
      <div class="refine-filter-action">
        <a href="javascript:;" class="btn site-color-3-bg site-color-3-lighten-bg-hover text-white refine-close pull-left">Close</a>
        <a href="javascript:;" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white refine-apply pull-right site-color-2-bg text-white" id="refineMoreFiltersApply">Apply</a>
      </div>

    </div>
  </div>
  <!--- Clear Refine --->
  <div class="refine-item refine-clear refine-clear-filters-wrap">
    <a href="/rentals/results.cfm?all_properties=true" class="refine-text site-color-1-bg text-white">
      <i class="fa fa-recycle text-white" aria-hidden="true"></i>
      <span class="refine-text-title">Clear</span>
    </a>
  </div>
</form>