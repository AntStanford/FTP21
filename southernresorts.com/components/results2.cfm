<link href="/<cfoutput>#settings.booking.dir#</cfoutput>/stylesheets/styles.css?v=2" rel="stylesheet" type="text/css">

<cfinclude template="results-search-query.cfm">

<style>.results-list-sort ul li.hidden-sort {display: none;}</style>

<!---
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
        <span class="site-color-3">Refine</span>
      </a>
    </div>
  </div>
--->

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
    	<cfif StructKeyExists(request,'resortContent')>
				<cfoutput>#request.resortContent#</cfoutput>
				<cfinclude template="_resort-custom-content.cfm">
      </cfif>

      <cfif isdefined('page') and len(page.h1)>
      	<h1><cfoutput>#page.h1#</cfoutput></h1>
      <cfelseif isdefined('page') and len(page.name)>
      	<h1><cfoutput>#page.name#</cfoutput></h1>
      <cfelse>
        <h1>Southern Vacation Rentals</h1>
      </cfif>
      <cfif isdefined('page') and len(page.body)>
      	<p><cfoutput>#page.body#</cfoutput></p>
      </cfif>

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

      <div class="results-list-alert-popular alert alert-info" style="display:none" id="results-list-alert-popular-ajax">
        <i class="fa fa-fire" aria-hidden="true"></i>
        <span>Your dates are popular!</span>
        <b><span class="percent-booked-ajax"><!--- data loaded via ajax in results.js ---></span>% of our inventory is booked.</b>
        <span>Book Now!</span>
      </div>

      <div class="results-list-legend">
        <ul class="results-list-key">
          <cfif isdefined('session.booking.unitCodeList')>
<!---           	<li><i class="fa fa-map-marker" aria-hidden="true"></i> <span class="props-return"><cfoutput>#cookie.numResults#</cfoutput></span> properties returned</li> --->
          </cfif>
        </ul>
        <ul class="results-list-sort" id="sortForm">
          <li data-resultsList="placeholder">
			<!---
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
                  <cfelseif session.booking.strSortBy eq 'price asc'>
                    <i>Price (ASC)</i>
                  <cfelseif session.booking.strSortBy eq 'price desc'>
                    <i>Price (DESC)</i>
                  <cfelse>
                  	<i>Random</i>
                  </cfif>
                <cfelse>
                  <i></i>
                </cfif>
              </em>
              <i class="fa fa-chevron-down" aria-hidden="true"></i>
            </span>
--->
            <ul class="hidden results-sort-by">
            	<li data-resultsList="rand()"><span>Random</span></li>
    					<li data-resultsList="name"><span>Name (ASC)</span></li>
    					<li data-resultsList="bedrooms asc"><span>Beds (ASC)</span></li>
    					<li data-resultsList="bedrooms desc"><span>Beds (DESC)</span></li>
    					<li data-resultsList="fullBathrooms asc"><span>Baths (ASC)</span></li>
    					<li data-resultsList="fullBathrooms desc"><span>Baths (DESC)</span></li>
    					<li data-resultsList="sleeps asc"><span>Sleeps (ASC)</span></li>
    					<li data-resultsList="sleeps desc"><span>Sleeps (DESC)</span></li>
	  					<cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate>
	  						<li data-resultsList="price asc" class="priceasc"><span>Price (ASC)</span></li>
	  						<li data-resultsList="price desc"><span>Price (DESC)</span></li>
              <cfelse>
	  						<li data-resultsList="price asc" class="priceasc hidden-sort"><span>Price (ASC)</span></li>
	  						<li data-resultsList="price desc" class="hidden-sort"><span>Price (DESC)</span></li>
	  					</cfif>
            </ul>
          </li>
        </ul>
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
      
      
      
      
      
      
    
      
      
<cfif StructKeyExists(request,'resortContent')>
      <div class="row pdp-experience">
	    		<div class="col-lg-12">

					<p class="h1 h1-header site-color-3">Experience Miramar Beach</p>
	    		</div>
	    		<div class="experience-listings">
	    		
		    		<div class="col-xs-12 col-sm-4 experience-listing">
			    		
							<img src="/images/gc-guide-callouts/callout-1.jpg" alt="">
							<div class="pdp-callout-text">
								<div class="h4 callout-category">DINING</div>
				    		<div class="h5 callout-subtext">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. </div>
				    	</div>
		    		</div>
		    		
		    		<div class="col-xs-12 col-sm-4 experience-listing">
						<img src="/images/gc-guide-callouts/callout-3.jpg" alt="">
						<div class="pdp-callout-text">
				    		<div class="h4 callout-category">ACTIVITIES</div>
				    		<div class="h5 callout-subtext">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</div>
				    	</div>
		    		</div>
		    		
		    		<div class="col-xs-12 col-sm-4 experience-listing">
			    		<img src="/images/gc-guide-callouts/callout-familyfriendly.jpg" alt="">
			    		<div class="pdp-callout-text">
				    		<div class="h4 callout-category">EVENTS</div>
				    		<div class="h5 callout-subtext">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</div>
				    	</div>
		    		</div>
		    		
	
	    		</div>
<!--END experience-listings-->
	    		

	    	</div><!--END pdp-experience-->
      </cfif>
      
      
      
      
      
      
      
      
      

    </div>
    <cfinclude template="results-map.cfm">
  </div><!--- END results-wrap --->

  <cf_htmlfoot>
  <script type="text/javascript" src="//maps.googleapis.com/maps/api/js?v=3&key=AIzaSyAIZZlsp_lQSuYWcdhw5RShr7Pd5zdK_60"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/OverlappingMarkerSpiderfier/1.0.3/oms.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/js-marker-clusterer/1.0.0/markerclusterer_compiled.js"></script>
  <script src="/vacation-rentals/javascripts/results.js" defer></script>
    <script src="/<cfoutput>#settings.booking.dir#</cfoutput>/javascripts/global.js" defer></script>
    
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
              lazyLoad: true, loop: true, nav: true, navText: ["<i class='fa fa-chevron-left'></i>","<i class='fa fa-chevron-right'></i>"], dots: false, margin: 15,
              responsive: { 0: { items: 1 }, 481: { items: 1 }, 993: { items: 1 } }
            });

            $('.cssload-container').delay(1500).fadeOut(200);
          }
        });
      </script>
    </cfif>
  </cf_htmlfoot>
  
  <cfif StructKeyExists(request,'resortContent')></div><!---END resort-bottom---></cfif>

<cfinclude template="/#settings.booking.dir#/components/results-modals.cfm">
