
<!--- Get the popular searches --->
<cfquery name="getPopularSearches" dataSource="#settings.dsn#">
	select slug,name,popularSearchPhoto from cms_pages where popularSearch = 'Yes'
</cfquery>
<cfset settings.booking.typeList = application.bookingObject.getDistinctTypes()>
<cfset settings.booking.areaList = application.bookingObject.getDistinctAreas()> 
<!--- Set some defaults just in case --->
<cfif !isdefined('settings.booking.minOccupancy') or settings.booking.minOccupancy eq ''>
  <cfset settings.booking.minOccupancy = 1>
  <cfset settings.booking.maxOccupancy = 10>
  <cfset settings.booking.minbed = 1>
  <cfset settings.booking.maxbed = 10>
</cfif>

<div class="container i-quick-search" id="quickSearch">
<!---
  <ul class="nav nav-tabs" role="tablist">
    <li role="presentation" class="active"><a href="#bookingSearch" aria-controls="bookingSearch" role="tab" data-toggle="tab">Start Your Adventure Now!</a></li>
    <cfif getPopularSearches.recordcount gt 0>
    	<li role="presentation"><a href="#popularSearches" aria-controls="popularSearches" role="tab" data-toggle="tab">Popular Searches</a></li>
    </cfif>
  	<li role="presentation"><a href="#mlsSearch" aria-controls="mlsSearch" role="tab" data-toggle="tab">Find Your Home Now!</a></li>
  </ul>
--->
<!---   <div class="tab-content"> --->
<!---     <div role="tabpanel" class="tab-pane active" id="bookingSearch"> --->
      <cfoutput><form method="post" action="/vacation-rentals/results"></cfoutput>
       <input type="hidden" name="camefromsearchform">
        <div class="row">
          
          <div class="col-lg-4 col-md-4 search-dates-wrapper">
            <!--- Search Dates --->
            <div class="dates-arrival"><!---

			        <label for="start-date">Arrival</label>
--->
			        <div class="input-wrap">
							  <input type="text" name="strCheckin" id="start-date" placeholder="Arrival Date" value="" readonly="">
			        </div>
			      </div>
			      <div class="dates-departure"><!---

			        <label for="end-date">Departure</label>
--->
			        <div class="input-wrap">
			          <input type="text" name="strCheckout" id="end-date" placeholder="Departure Date" value="" readonly="">
			        </div>
			      </div>
<!---
            <div class="search-dates">
              <div class="search-text">
                <span class="search-arrival" id="searchArrival">
                  <label>Arrival</label>
        				  <input type="text" name="strCheckin" id="start-date" placeholder="Arrival" value="" readonly>
                </span>
                <span class="search-departure" id="searchDeparture">
                  <label>Departure</label>
                  <input type="text" name="strCheckout" id="end-date" placeholder="Departure" value="" readonly>
                </span>
              </div>
              <div class="datepicker-wrap hidden">
                <div id="searchDatepicker"></div>
                <a href="javascript:;" class="btn text-center pull-left search-clear">Clear Dates</a>
                <a href="javascript:;" class="btn text-center pull-right search-close">Close</a>
              </div>
            </div>
---><!-- END search-dates -->
          </div>
          <div class="col-lg-2 col-md-2 guests">
            <div class="select-wrap">
              <select class="selectpicker" data-size="6" name="sleeps" title="Guests">
                <option data-hidden="true" value="">Guests</option>               
                <cfloop from="#settings.booking.minOccupancy#" to="#settings.booking.maxOccupancy#" index="i">
                  <cfoutput><option value="#i#">#i#</option></cfoutput>
                </cfloop>               
              </select>
            </div>
          </div>
          <div class="col-lg-2 col-md-2 type">
            <div class="select-wrap">
              <select class="selectpicker" data-size="6" name="type" title="Type">
                <option data-hidden="true" value="">Type</option>               
                <cfloop list="#settings.booking.typeList#" index="i">
                  <cfoutput><option value="#i#">#i#</option></cfoutput>
                </cfloop>               
              </select>
            </div>
          </div>
		<cfquery name="getDestinations" dataSource="#settings.dsn#">
			select id,nodeid, title from cms_destinations
			where hideonsite = 'No'
			order by title
		</cfquery>
          <div class="col-lg-2 col-md-2 location">
            <div class="select-wrap">
              <select class="selectpicker" data-size="6" name="town" title="Location">
                <option data-hidden="true" value="">Location</option>               
                <cfloop query="getDestinations" >
                  <cfoutput><option value="#title#">#title#</option></cfoutput>
                </cfloop>               
              </select>
            </div>
          </div>
<!---
          <div class="col-lg-2 col-md-2">
            <div class="select-wrap">
              <select class="selectpicker" data-size="6" name="bedrooms" title="Bedrooms">
                <option data-hidden="true" value="">Bedrooms</option>
                <cfloop from="#settings.booking.minbed#" to="#settings.booking.maxbed#" index="i">
                  <cfoutput><option value="#i#,6">#i#</option></cfoutput>
                </cfloop>
              </select>
            </div>
          </div>
          <div class="col-lg-2 col-md-2">
            <div class="select-wrap">
              <select class="selectpicker" multiple title="Must Haves" data-size="6" name="must_haves">
                <cfloop list="#mustHavesList#" index="i">
                	<cfoutput><option>#i#</option></cfoutput>
                </cfloop>                
              </select>
            </div>
          </div>
--->
          <div class="col-lg-2 col-md-2 quick-search-submit">
            <input type="submit" value="Check Availability" class="btn site-color-1-bg site-color-1-lighten-bg-hover">
            <i class="fa fa-arrow-right"></i>
          </div>
        </div>
      </form>
<!---     </div> --->
<!---
    <cfif getPopularSearches.recordcount gt 0>
	    <div role="tabpanel" class="tab-pane" id="popularSearches">
	      <div class="btn-group btn-group-justified" role="group">
	        <cfset colorcounter = 1>
	        <cfloop query="getPopularSearches">
	        	<cfoutput><a href="/#slug#" class="btn btn-sm site-color-#colorcounter#-bg site-color-#colorcounter#-lighten-bg-hover text-white text-white-hover">#name#</a></cfoutput>
	        	<cfif colorcounter eq 2>
	        		<cfset colorcounter = 1>
	        	<cfelse>
	        		<cfset colorcounter = 2>
	        	</cfif>
	        </cfloop>
	      </div>
	    </div>
    </cfif>
    <div role="tabpanel" class="tab-pane" id="mlsSearch">
      <form method="post" action="">
        <div class="row">
          <div class="col-md-2">
            <div class="select-wrap">
              <select class="selectpicker" multiple title="Any Price" data-size="6" name="anyprice">
                <option>Lorem</option>
              </select>
            </div>
          </div>
          <div class="col-md-2">
            <div class="select-wrap">
              <select class="selectpicker" multiple title="Bedrooms" data-size="6" name="bedrooms">
                <option>Lorem</option>
              </select>
            </div>
          </div>
          <div class="col-md-2">
            <div class="select-wrap">
              <select class="selectpicker" multiple title="Baths" data-size="6" name="baths">
                <option>Lorem</option>
              </select>
            </div>
          </div>
          <div class="col-md-2">
            <div class="select-wrap">
              <select class="selectpicker" multiple title="City" data-size="6" name="city">
                <option>Lorem</option>
              </select>
            </div>
          </div>
          <div class="col-md-2">
            <a href="" class="btn btn-block btn-advancedSearch site-color-2-bg site-color-2-lighten-bg-hover">Advanced Search</a>
          </div>
          <div class="col-md-2">
            <input type="submit" value="Search Now" class="btn site-color-1-bg site-color-1-lighten-bg-hover">
          </div>
        </div>
      </form>
    </div>
  </div>--->
</div><!--i-quick-search-->

<style>
input#start-date, input#end-date { z-index: 99999; color: #0a0a0a; text-transform: uppercase; width: 100%; /*opacity: 0;
    display: inline-block;*/
    vertical-align: top;
    /*width: 100%;
    margin-right: -4px;*/

    border: none;

    cursor: pointer;
    font-size: 17px;
    text-align: left;
    font-weight: 300;
    text-transform: uppercase;
    text-overflow: ellipsis;
    transition: all 0.5s;
    transition-delay: 0s; padding-left: 14px; }
span.dates-arrival {
    display: block;
    z-index: 999; }
.dates-arrival .input-wrap {
    width: 48.5%; margin-right: 2.5%;}
.dates-departure .input-wrap {
    width: 49%;}

.input-wrap {
    width: 50%;
    float: left;
}
</style>