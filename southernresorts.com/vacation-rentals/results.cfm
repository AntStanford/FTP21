<cfinclude template="results-search-query.cfm">

<cfinclude template="/#settings.booking.dir#/components/header.cfm">
<style>.results-list-sort ul li.hidden-sort {display: none;}</style>
   

  <cfif StructKeyExists(request,'resortContent')>

	  <cfif session.booking.getresults.recordcount EQ 0 AND len(getcmsresort.notfoundurl)>

		  <cflocation url="http://#cgi.server_name#/#getcmsresort.notfoundurl#" addtoken="false">
	  </cfif>

	<cfelse>

	  <div class="refine-wrap refine-mobile">
	    <cfinclude template="_refine-search.cfm">
	    <div class="refine-panel-controls refine-mobile-controls">
	      <cfif NOT StructKeyExists(request,'resortContent')>
	      <a href="javascript:;" id="viewListAndMap" class="mobile-hidden" rel="tooltip" data-placement="bottom" title="Toggle Grid/Split View">
	        <i class="fa fa-th-large site-color-2" aria-hidden="true"></i>
	        <span class="site-color-3">Grid View</span>
	      </a>
	      <a href="javascript:;" id="viewMapOnly" rel="tooltip" data-placement="bottom" title="Map Full View">
	        <i class="fa fa-map-marker site-color-2" aria-hidden="true"></i>
	        <span class="site-color-3">Map View</span>
	      </a>
	      </cfif>
	      <a href="javascript:;" id="viewFiltersMobile"  rel="tooltip" data-placement="bottom" title="Refine Your Search">
	        <i class="fa fa-toggle-off site-color-2" aria-hidden="true"></i>
	        <span class="site-color-3">Refine Your Search</span>
	      </a>
	    </div>
	  </div>

  </cfif>

  <div class="header-actions-refine">
    <a href="javascript:;" class="header-actions-action site-color-1-lighten-bg-hover" id="recentlyViewedToggle">
      <div rel="tooltip" data-placement="bottom" title="Properties you have Recently Viewed">
        <small>Viewed</small>
        <i class="fa fa-eye text-white"></i>
        <span><em class="header-recently-viewed-count"><cfif StructKeyExists(cookie,'recent') and ListLen(cookie.recent)><cfoutput>#listlen(cookie.recent)#</cfoutput><cfelse>0</cfif></em></span>
      </div>
    </a>
    <cfinclude template="/#settings.booking.dir#/_recentlist.cfm">

    <a href="javascript:;" class="header-actions-action site-color-1-lighten-bg-hover" id="favoritesToggle">
      <div rel="tooltip" data-placement="bottom" title="Your Favorited Properties">
        <small>Favorites</small>
        <i class="fa fa-heart"></i>
        <span><em class="header-favorites-count"><cfif StructKeyExists(cookie,'favorites') and ListLen(cookie.favorites)><cfoutput>#listlen(cookie.favorites)#</cfoutput><cfelse>0</cfif></em></span>
      </div>
    </a>
    <cfinclude template="/#settings.booking.dir#/_favoriteslist.cfm">
  </div><!-- END header-actions -->

  <div class="results-wrap <cfif StructKeyExists(request,'resortContent')>resorts-wrap</cfif>">
    <div class="results-list-wrap <cfif StructKeyExists(request,'resortContent')>resorts-list-wrap</cfif>">

      <!--- Here on purpose - requested by client --->
      <div class="srp-page-announcements">
        <cfinclude template="/components/home-page-announcements.cfm">
      </div>

<!---
      <cfif cgi.script_name eq '/vacation-rentals/results.cfm' and isdefined('numvisitors') and numvisitors gt 0>
        <div id="userAlert" class="alert alert-info" >
          <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>

          <cfif numvisitors gt 1>
            <cfoutput>#numvisitors#</cfoutput> visitors are planning their vacation right now!

          <cfelseif numvisitors eq 1>
            1 other visitor is planning their vacation right now!
          </cfif>
        </div>
      </cfif>
--->



    	<cfif StructKeyExists(request,'resortContent')>
				<cfoutput>#request.resortContent#</cfoutput>
				<cfinclude template="_resort-custom-content.cfm">
      </cfif>

      <cfif StructKeyExists(request,'resortContent')>
	    <cfelse>

	      <cfif isdefined('page') and len(page.h1)>
	      	<h1><cfoutput>#page.h1#</cfoutput></h1>
	      <cfelseif isdefined('page') and len(page.name)>
	      	<h1><cfoutput>#page.name#</cfoutput></h1>
	      <cfelse>
	        <h1>Southern Vacation Rentals</h1>
	      </cfif>
      </cfif>
      <div class="results-body">
        <cfif isdefined('page') and len(page.body)>
          <p><cfoutput>#page.body#</cfoutput></p>
        </cfif>
      </div>
      <cfif isdefined('request.specialContent')>
      	<cfoutput>#request.specialContent#</cfoutput>
      </cfif>

    	<cfif isdefined('displayThis')>
	      <div class="results-list-alert-popular alert alert-info" id="results-list-alert-popular-post">
	        <i class="fa fa-fire" aria-hidden="true"></i>
	        <span>Your dates are popular!</span>
	        <b><span class="percent-booked-ajax"><cfoutput>#NumberFormat(displayThis, "__")#</cfoutput></span>% of our inventory is booked.</b>
	        <span>Book Now!</span>
	      </div>
      </cfif>


     <!---  <cfif CGI.REMOTE_ADDR eq "173.93.73.19">

	      <div class="results-list-alert-popular alert alert-info" id="results-list-alert-popular-ajax">
	        <i class="fa fa-fire" aria-hidden="true"></i>
	        <span>Your dates are popular!</span>
	        <b><span class="percent-booked-ajax"><!--- data loaded via ajax in results.js ---></span>% of our inventory is booked.</b>
	        <span>Book Now!</span>
	      </div>

    	<cfelse>

	    	<div class="results-list-alert-popular alert alert-info" id="results-list-alert-popular-ajax">
	        <i class="fa fa-fire" aria-hidden="true"></i>
	        <span>Your dates are popular!</span>
	        <b><!--- <span class="percent-booked-ajax"> ---><!--- data loaded via ajax in results.js ---><!--- </span> --->50% of our inventory is booked.</b>
	        <span>Book Now!</span>
	      </div>

    	</cfif> --->

      <div class="results-list-alert-popular alert alert-info" id="results-list-alert-popular-ajax" style="display:none;">
        <i class="fa fa-fire" aria-hidden="true"></i>
        <span>Your dates are popular!</span>
        <b><span class="percent-booked-ajax"><!--- data loaded via ajax in results.js , if no ajax then include file will load---><cfinclude template="results-search-query-booked.cfm"></span></b>
        <!---<span>Book Now!</span>--->
      </div>



      <div class="results-list-legend">
        <ul class="results-list-key">
          <cfif isdefined('session.booking.unitCodeList')>
<!---           	<li><i class="fa fa-map-marker" aria-hidden="true"></i> <span class="props-return"><cfoutput>#cookie.numResults#</cfoutput></span> properties returned</li> --->
          </cfif>
		  </ul>
	    <cfif script_name NEQ "/layouts/resort.cfm">
        <ul class="results-list-sort" id="sortForm">
          <li data-resultsList="placeholder">
            <span>
              <em id="resultsListSortTitle">
                <b>Sort by:</b>
                <cfif isdefined('session.booking.strSortBy') and len(session.booking.strSortBy)>
                  <cfif session.booking.strSortBy eq 'rand()'>
                    <i>Random</i>
                  <cfelseif session.booking.strSortBy eq 'name'>
                    <i>Name (ASC)</i>
                  <cfelseif session.booking.strSortBy eq 'bedrooms asc'>
                    <i>Beds (ASC)</i>
                  <cfelseif session.booking.strSortBy eq 'bedrooms desc'>
                    <i>Beds (DESC)</i>
                  <cfelseif session.booking.strSortBy eq 'fullBathrooms asc'>
                    <i>Baths (ASC)</i>
                  <cfelseif session.booking.strSortBy eq 'fullBathrooms desc'>
                    <i>Baths (DESC)</i>
                  <cfelseif session.booking.strSortBy eq 'sleeps asc'>
                    <i>Sleeps (ASC)</i>
                  <cfelseif session.booking.strSortBy eq 'sleeps desc'>
                    <i>Sleeps (DESC)</i>
                  <cfelse>
                  	<i>Random</i>
                  </cfif>
                <cfelse>
                  <i></i>
                </cfif>
              </em>
              <i class="fa fa-chevron-down" aria-hidden="true"></i>
            </span>
            <ul class="hidden results-sort-by">
            	<li data-resultsList="rand()"><span>Random</span></li>
    					<li data-resultsList="name"><span>Name (ASC)</span></li>
    					<li data-resultsList="bedrooms asc"><span>Beds (ASC)</span></li>
    					<li data-resultsList="bedrooms desc"><span>Beds (DESC)</span></li>
    					<li data-resultsList="fullBathrooms asc"><span>Baths (ASC)</span></li>
    					<li data-resultsList="fullBathrooms desc"><span>Baths (DESC)</span></li>
    					<li data-resultsList="sleeps asc"><span>Sleeps (ASC)</span></li>
              <li data-resultsList="sleeps desc"><span>Sleeps (DESC)</span></li>
              <!---
	  					<cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate>
	  						<li data-resultsList="price asc" class="priceasc"><span>Price (ASC)</span></li>
	  						<li data-resultsList="price desc"><span>Price (DESC)</span></li>
              <cfelse>
	  						<li data-resultsList="price asc" class="priceasc hidden-sort"><span>Price (ASC)</span></li>
	  						<li data-resultsList="price desc" class="hidden-sort"><span>Price (DESC)</span></li>
              </cfif>
            --->
            </ul>
          </li>
        </ul>
					  </cfif>
      </div>
      <div id="list-all-results" <cfif StructKeyExists(request,'resortContent')>class="resorts-list-all-results"</cfif>>
        <cfinclude template="results-loop.cfm">
      </div>

  		<cfif isdefined('cookie.numResults')>
        <!--- Loading Animation for Infinite Scroll --->
        <div id="bottom-result" data-count="<cfoutput>#cookie.numResults#</cfoutput>">
          <div class="cssload-container">
            <div class="cssload-tube-tunnel"></div>
          </div>
        </div>
      </cfif>

    <cfif StructKeyExists(request,'resortContent')></div><!--END resort-bottom--></cfif>
    </div><!--END results-list-wrap-->
    <cfinclude template="results-map.cfm">
  </div><!-- END results-wrap -->

  <cf_htmlfoot>
    <div class="results-loader-overlay">
      <div class="cssload-container">
        <div class="cssload-tube-tunnel"></div>
      </div>
    </div>

		<cfif StructKeyExists(request,'resortContent')>
			<script>
        $(document).ready(function(){
          //Resorts Slider
          if ($('.owl-carousel.resorts-carousel').length) {
            $('.owl-carousel.resorts-carousel').owlCarousel({
              lazyLoad: true, lazyLoadEager: 2, loop: true, nav: true, navText: ["<i class='fa fa-chevron-left'></i>","<i class='fa fa-chevron-right'></i>"], dots: false, items: 1, margin: 10, stagepadding: 100, responsiveRefreshRate: 100, responsive:{
                0:{
                stagePadding: 0
                },
                480:{
                stagePadding: 0
                },
                667:{
                stagePadding: 200
                },
                768:{
                stagePadding: 200
                },
                1100:{
                stagePadding: 250
                },
                1400:{
                stagePadding: 280
                },
                1700:{
                stagePadding: 340
                }    }

			});
            $('.cssload-container').delay(1500).fadeOut(200);
          }
        });
      </script>
    </cfif>
  </cf_htmlfoot>



<cfinclude template="/#settings.booking.dir#/components/results-modals.cfm">

  <!--- log the search with Google Analytics (in results.cfm & ajax/results.cfm) --->
  <cftry>
      <cfset variables.gaString = application.bookingObject.getGoogleSearchLog('initial')>
      <cfif len(variables.gaString)>
        <script>
          <cfoutput>#variables.gaString#</cfoutput>
        </script>
      </cfif>
    <cfcatch></cfcatch>
  </cftry>


<cfinclude template="/#settings.booking.dir#/components/footer.cfm">