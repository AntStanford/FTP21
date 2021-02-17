<!--- <cfset session.booking.strcheckin = dateformat(Now(),'mm/dd/yyyy')>
<cfset session.booking.strcheckout = dateformat(Now(),'mm/dd/yyyy')> --->


<cfset request.ajaxCall = 0>
<cfinclude template="results-search-query.cfm">
<cfinclude template="/#settings.booking.dir#/components/header.cfm">
<style>.results-list-sort ul li.hidden-sort {display: none;}</style>

  <div class="refine-wrap refine-mobile">
    <cfinclude template="_refine-search.cfm">

    <div class="refine-panel-controls refine-mobile-controls">
      <cfif NOT StructKeyExists(request,'resortContent')>
        <a href="javascript:;" id="viewListAndMap" class="mobile-hidden" rel="tooltip" data-placement="bottom" title="Toggle Grid/Split View">
          <i class="fa fa-th-large site-color-1" aria-hidden="true"></i>
          <span class="site-color-1">Grid View</span>
        </a>

        <a href="javascript:;" id="viewMapOnly" rel="tooltip" data-placement="bottom" title="Map Full View">
          <i class="fa fa-map-marker site-color-1" aria-hidden="true"></i>
          <span class="site-color-1">Map View</span>
        </a>
      </cfif>

      <a href="javascript:;" id="viewFiltersMobile"  rel="tooltip" data-placement="bottom" title="Refine Your Search">
        <i class="fa fa-toggle-off site-color-1" aria-hidden="true"></i>
        <span class="site-color-1">Refine</span>
      </a>
    </div>
  </div>

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
      <cfif isdefined('page') and len(page.h1)>
      	<h1><cfoutput>#page.h1#</cfoutput></h1>
      <cfelseif isdefined('page') and len(page.name)>
      	<h1><cfoutput>#page.name#</cfoutput></h1>
      </cfif>
      <cfif isdefined('page') and len(page.body)>
        <div class="content-builder-wrap">
          <div><cfoutput>#page.body#</cfoutput></div>
        </div>
      </cfif>

      <cfif isdefined('request.specialContent')>
      	<cfoutput>#request.specialContent#</cfoutput>
      </cfif>
    	<cfif StructKeyExists(request,'resortContent')>
				<cfoutput>#request.resortContent#</cfoutput>
      </cfif>
      <cfinclude template="/#settings.booking.dir#/results-search-query-booked.cfm">
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

      <div id="scrollReturn"></div>

      <cfif isdefined('session.booking.strCheckin') and session.booking.strCheckin neq '' and isdefined('session.booking.camefromsearchform') and isdefined('session.booking.flex_dates') and session.booking.flex_dates eq 'on'>
				<!--- Set Flex Date variables based on the current "tab" selection --->
        <cfif isDefined('session.booking.flexed') AND session.booking.flexed is 'early2'>
        	<!--- Two days early "tab" --->
					<cfset variables.early2StrCheckin = session.booking.strcheckin>
          <cfset variables.early2StrCheckout = session.booking.strcheckout>
          <cfset variables.earlyStrCheckin = DateFormat(DateAdd('d',1,session.booking.strcheckin),'mm/dd/yyyy')>
          <cfset variables.earlyStrCheckout = DateFormat(DateAdd('d',1,session.booking.strcheckout),'mm/dd/yyyy')>
          <cfset variables.midStrCheckin = DateFormat(DateAdd('d',2,session.booking.strcheckin),'mm/dd/yyyy')>
          <cfset variables.midStrCheckout = DateFormat(DateAdd('d',2,session.booking.strcheckout),'mm/dd/yyyy')>
          <cfset variables.lateStrCheckin = DateFormat(DateAdd('d',3,session.booking.strcheckin),'mm/dd/yyyy')>
          <cfset variables.lateStrCheckout = DateFormat(DateAdd('d',3,session.booking.strcheckout),'mm/dd/yyyy')>
          <cfset variables.late2StrCheckin = DateFormat(DateAdd('d',4,session.booking.strcheckin),'mm/dd/yyyy')>
          <cfset variables.late2StrCheckout = DateFormat(DateAdd('d',4,session.booking.strcheckout),'mm/dd/yyyy')>
        <cfelseif isDefined('session.booking.flexed') AND session.booking.flexed is 'early'>
        	<!--- One day early "tab" --->
          <cfset variables.early2StrCheckin = DateFormat(DateAdd('d',-1,session.booking.strcheckin),'mm/dd/yyyy')>
          <cfset variables.early2StrCheckout = DateFormat(DateAdd('d',-1,session.booking.strcheckout),'mm/dd/yyyy')>
					<cfset variables.earlyStrCheckin = session.booking.strcheckin>
          <cfset variables.earlyStrCheckout = session.booking.strcheckout>
          <cfset variables.midStrCheckin = DateFormat(DateAdd('d',1,session.booking.strcheckin),'mm/dd/yyyy')>
          <cfset variables.midStrCheckout = DateFormat(DateAdd('d',1,session.booking.strcheckout),'mm/dd/yyyy')>
          <cfset variables.lateStrCheckin = DateFormat(DateAdd('d',2,session.booking.strcheckin),'mm/dd/yyyy')>
          <cfset variables.lateStrCheckout = DateFormat(DateAdd('d',2,session.booking.strcheckout),'mm/dd/yyyy')>
          <cfset variables.late2StrCheckin = DateFormat(DateAdd('d',3,session.booking.strcheckin),'mm/dd/yyyy')>
          <cfset variables.late2StrCheckout = DateFormat(DateAdd('d',3,session.booking.strcheckout),'mm/dd/yyyy')>
        <cfelseif isDefined('session.booking.flexed') AND session.booking.flexed is 'late'>
        	<!--- One day late "tab" --->
					<cfset variables.early2StrCheckin = DateFormat(DateAdd('d',-3,session.booking.strcheckin),'mm/dd/yyyy')>
          <cfset variables.early2StrCheckout = DateFormat(DateAdd('d',-3,session.booking.strcheckout),'mm/dd/yyyy')>
					<cfset variables.earlyStrCheckin = DateFormat(DateAdd('d',-2,session.booking.strcheckin),'mm/dd/yyyy')>
          <cfset variables.earlyStrCheckout = DateFormat(DateAdd('d',-2,session.booking.strcheckout),'mm/dd/yyyy')>
          <cfset variables.midStrCheckin = DateFormat(DateAdd('d',-1,session.booking.strcheckin),'mm/dd/yyyy')>
          <cfset variables.midStrCheckout = DateFormat(DateAdd('d',-1,session.booking.strcheckout),'mm/dd/yyyy')>
          <cfset variables.lateStrCheckin = session.booking.strcheckin>
          <cfset variables.lateStrCheckout = session.booking.strcheckout>
          <cfset variables.late2StrCheckin = DateFormat(DateAdd('d',1,session.booking.strcheckin),'mm/dd/yyyy')>
          <cfset variables.late2StrCheckout = DateFormat(DateAdd('d',1,session.booking.strcheckout),'mm/dd/yyyy')>
        <cfelseif isDefined('session.booking.flexed') AND session.booking.flexed is 'late2'>
        	<!--- Two days late "tab" --->
					<cfset variables.early2StrCheckin = DateFormat(DateAdd('d',-4,session.booking.strcheckin),'mm/dd/yyyy')>
          <cfset variables.early2StrCheckout = DateFormat(DateAdd('d',-4,session.booking.strcheckout),'mm/dd/yyyy')>
					<cfset variables.earlyStrCheckin = DateFormat(DateAdd('d',-3,session.booking.strcheckin),'mm/dd/yyyy')>
          <cfset variables.earlyStrCheckout = DateFormat(DateAdd('d',-3,session.booking.strcheckout),'mm/dd/yyyy')>
          <cfset variables.midStrCheckin = DateFormat(DateAdd('d',-2,session.booking.strcheckin),'mm/dd/yyyy')>
          <cfset variables.midStrCheckout = DateFormat(DateAdd('d',-2,session.booking.strcheckout),'mm/dd/yyyy')>
          <cfset variables.lateStrCheckin = DateFormat(DateAdd('d',-1,session.booking.strcheckin),'mm/dd/yyyy')>
          <cfset variables.lateStrCheckout = DateFormat(DateAdd('d',-1,session.booking.strcheckout),'mm/dd/yyyy')>
          <cfset variables.late2StrCheckin = session.booking.strcheckin>
          <cfset variables.late2StrCheckout = session.booking.strcheckout>
				<cfelse>
					<!--- Center "tab" or no flex dates selected --->
          <cfset variables.early2StrCheckin = DateFormat(DateAdd('d',-2,session.booking.strcheckin),'mm/dd/yyyy')>
          <cfset variables.early2StrCheckout = DateFormat(DateAdd('d',-2,session.booking.strcheckout),'mm/dd/yyyy')>
          <cfset variables.earlyStrCheckin = DateFormat(DateAdd('d',-1,session.booking.strcheckin),'mm/dd/yyyy')>
          <cfset variables.earlyStrCheckout = DateFormat(DateAdd('d',-1,session.booking.strcheckout),'mm/dd/yyyy')>
          <cfset variables.midStrCheckin = session.booking.strcheckin>
          <cfset variables.midStrCheckout = session.booking.strcheckout>
          <cfset variables.lateStrCheckin = DateFormat(DateAdd('d',1,session.booking.strcheckin),'mm/dd/yyyy')>
          <cfset variables.lateStrCheckout = DateFormat(DateAdd('d',1,session.booking.strcheckout),'mm/dd/yyyy')>
          <cfset variables.late2StrCheckin = DateFormat(DateAdd('d',2,session.booking.strcheckin),'mm/dd/yyyy')>
          <cfset variables.late2StrCheckout = DateFormat(DateAdd('d',2,session.booking.strcheckout),'mm/dd/yyyy')>
        </cfif>

        <!--- Formats the Check-in Days for each "tab" --->
				<cfset variables.early2CheckinDay = dateFormat(variables.early2StrCheckin, 'dddd')>
				<cfset variables.earlyCheckinDay = dateFormat(variables.earlyStrCheckin, 'dddd')>
        <cfset variables.midStrCheckinDay = dateFormat(variables.midStrCheckin, 'dddd')>
        <cfset variables.lateCheckinDay = dateFormat(variables.lateStrCheckin,'dddd')>
        <cfset variables.late2CheckinDay = dateFormat(variables.late2StrCheckin,'dddd')>

        <div class="results-tab-bar">
          <ul class="nav nav-tabs">
            <cfoutput>
              <li id="early2Tab" <cfif isDefined('session.booking.flexed') and session.booking.flexed is 'early2'>class="active"</cfif>>
                <a data-newcheckin="#variables.early2StrCheckin#" data-newcheckout="#variables.early2StrCheckout#" data-flextab="early2" href="javascript:;" id="early2SelectDay"><small class="tab-day-early2">#dateFormat(variables.early2StrCheckin, 'dddd')#</small><span class="tab-date tab-date-early2"></span></a>
              </li>
              <li id="earlyTab" <cfif isDefined('session.booking.flexed') and session.booking.flexed is 'early'>class="active"</cfif>>
                <a data-newcheckin="#variables.earlyStrCheckin#" data-newcheckout="#variables.earlyStrCheckout#" data-flextab="early" href="javascript:;" id="earlySelectDay"><small class="tab-day-early">#dateFormat(variables.earlyStrCheckin, 'dddd')#</small><span class="tab-date tab-date-early"></span></a>
              </li>
              <li id="midTab" <cfif !isDefined('session.booking.flexed') or (isDefined('session.booking.flexed') and trim(session.booking.flexed) is '')>class="active"</cfif>>
                <a data-newcheckin="#variables.midStrCheckin#" data-newcheckout="#variables.midStrCheckout#" data-flextab="" href="javascript:;" id="midSelectDay"><small class="tab-day-mid">#dateFormat(variables.midStrCheckin, 'dddd')#</small><span class="tab-date tab-date-mid"></span></a>
              </li>
              <li id="lateTab" <cfif isDefined('session.booking.flexed') and session.booking.flexed is 'late'>class="active"</cfif>>
                <a data-newcheckin="#variables.lateStrCheckin#" data-newcheckout="#variables.lateStrCheckout#" data-flextab="late" href="javascript:;" id="lateSelectDay"><small class="tab-day-late">#dateFormat(variables.lateStrCheckin, 'dddd')#</small><span class="tab-date tab-date-late"></span></a>
              </li>
              <li id="late2Tab" <cfif isDefined('session.booking.flexed') and session.booking.flexed is 'late2'>class="active"</cfif>>
                <a data-newcheckin="#variables.late2StrCheckin#" data-newcheckout="#variables.late2StrCheckout#" data-flextab="late2" href="javascript:;" id="late2SelectDay"><small class="tab-day-late2">#dateFormat(variables.late2StrCheckin, 'dddd')#</small><span class="tab-date tab-date-late2"></span></a>
              </li>
            </cfoutput>
          </ul>
        </div><br>

      <cfelse><!--- flex days if --->

        <!---
        This version is hidden/shown via the results page refine search filter
        User came to the page on a non-dated search initially, then used the filter at the top
        --->

        <div class="results-tab-bar hidden">
          <ul class="nav nav-tabs">
            <li id="early2Tab"><a data-newcheckin="" data-newcheckout="" data-flextab="early2" href="javascript:;" id="early2SelectDay"><small class="tab-day-early2"></small><span class="tab-date tab-date-early2"></span></a></li>
            <li id="earlyTab"><a data-newcheckin="" data-newcheckout="" data-flextab="early" href="javascript:;" id="earlySelectDay"><small class="tab-day-early"></small><span class="tab-date tab-date-early"></span></a></li>
            <li id="midTab"><a data-newcheckin="" data-newcheckout="" data-flextab="" href="javascript:;" id="midSelectDay"><small class="tab-day-mid"></small><span class="tab-date tab-date-mid"></span></a></li>
            <li id="lateTab"><a data-newcheckin="" data-newcheckout="" data-flextab="late" href="javascript:;" id="lateSelectDay"><small class="tab-day-late"></small><span class="tab-date tab-date-late"></span></a></li>
            <li id="late2Tab"><a data-newcheckin="" data-newcheckout="" data-flextab="late2" href="javascript:;" id="late2SelectDay"><small class="tab-day-late2"></small><span class="tab-date tab-date-late2"></span></a></li>
          </ul>
        </div><br>

      </cfif><!--- flex days else --->

      <div class="results-list-legend">
        <ul class="results-list-key">
          <cfif isdefined('session.booking.unitCodeList')>
          	<li><i class="fa fa-map-marker" aria-hidden="true"></i> <span class="props-return"><cfoutput>#cookie.numResults#</cfoutput></span> properties returned</li>
          </cfif>
        </ul>
        <ul class="results-list-sort" id="sortForm">
          <li data-resultsList="placeholder">
            <span>
              <em id="resultsListSortTitle">
                <b>Sort by:</b>
                <cfif isdefined('session.booking.strSortBy') and len(session.booking.strSortBy)>
                  <cfif session.booking.strSortBy eq 'name'>
                    <i>Name <i class="fa fa-long-arrow-up" aria-hidden="true"></i></i>
                  <cfelseif session.booking.strSortBy eq 'bedrooms asc'>
                    <i>Beds <i class="fa fa-long-arrow-up" aria-hidden="true"></i></i>
                  <cfelseif session.booking.strSortBy eq 'bedrooms desc'>
                    <i>Beds <i class="fa fa-long-arrow-down" aria-hidden="true"></i></i>
                  <cfelseif session.booking.strSortBy eq 'fullBathrooms asc'>
                    <i>Baths <i class="fa fa-long-arrow-up" aria-hidden="true"></i></i>
                  <cfelseif session.booking.strSortBy eq 'fullBathrooms desc'>
                    <i>Baths <i class="fa fa-long-arrow-down" aria-hidden="true"></i></i>
                  <cfelseif session.booking.strSortBy eq 'sleeps asc'>
                    <i>Sleeps <i class="fa fa-long-arrow-up" aria-hidden="true"></i></i>
                  <cfelseif session.booking.strSortBy eq 'sleeps desc'>
                    <i>Sleeps <i class="fa fa-long-arrow-down" aria-hidden="true"></i></i>
                  <cfelse>
                  	<i>Beds <i class="fa fa-long-arrow-down" aria-hidden="true"></i></i>
                  </cfif>
                <cfelse>
                  <i></i>
                </cfif>
              </em>
              <i class="fa fa-chevron-down" aria-hidden="true"></i>
            </span>
            <ul class="hidden results-sort-by">
    					<li data-resultsList="name"><span>Name <i class="fa fa-long-arrow-up" aria-hidden="true"></i></span></li>
    					<li data-resultsList="bedrooms asc"><span>Beds <i class="fa fa-long-arrow-up" aria-hidden="true"></i></span></li>
    					<li data-resultsList="bedrooms desc"><span>Beds <i class="fa fa-long-arrow-down" aria-hidden="true"></i></span></li>
    					<li data-resultsList="fullBathrooms asc"><span>Baths <i class="fa fa-long-arrow-up" aria-hidden="true"></i></span></li>
    					<li data-resultsList="fullBathrooms desc"><span>Baths <i class="fa fa-long-arrow-down" aria-hidden="true"></i></span></li>
    					<li data-resultsList="sleeps asc"><span>Sleeps <i class="fa fa-long-arrow-up" aria-hidden="true"></i></span></li>
    					<li data-resultsList="sleeps desc"><span>Sleeps <i class="fa fa-long-arrow-down" aria-hidden="true"></i></span></li>

              <cfif cgi.remote_host eq '172.110.82.184'>
                <li data-resultsList="price asc"><span>Price <i class="fa fa-long-arrow-up" aria-hidden="true"></i></span></li>
                <li data-resultsList="price desc"><span>Price <i class="fa fa-long-arrow-down" aria-hidden="true"></i></span></li>
              </cfif>
            </ul>
          </li>
        </ul>
      </div>
      <div id="list-all-results" <cfif StructKeyExists(request,'resortContent')>class="resorts-list-all-results"</cfif>>
<!---
        <cfif ICNDeyesOnly>
          <cfinclude template="results-loop-new.cfm">
        <cfelse>
--->
          <cfinclude template="results-loop.cfm">
<!---         </cfif> --->
      </div>

  		<cfif isdefined('cookie.numResults')>
        <!--- Loading Animation for Infinite Scroll --->
        <div id="bottom-result" data-count="<cfoutput>#cookie.numResults#</cfoutput>">
          <div class="cssload-container">
            <div class="cssload-tube-tunnel"></div>
          </div>
        </div>
      </cfif>


    </div>
    <cfinclude template="results-map.cfm">
  </div><!--- END results-wrap --->

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
              lazyLoad: true, loop: true, nav: true, navText: ["<i class='fa fa-chevron-left'></i>","<i class='fa fa-chevron-right'></i>"], dots: false, margin: 15,
              responsive: { 0: { items: 1 }, 481: { items: 2 }, 993: { items: 3 } }
            });

            $('.cssload-container').delay(1500).fadeOut(200);
          }
        });
      </script>
    </cfif>
  </cf_htmlfoot>

<cfinclude template="/#settings.booking.dir#/components/results-modals.cfm">

<cf_htmlfoot>
  <!--- log the search with Google Analytics (in results.cfm & ajax/results.cfm) --->
  <cfset variables.gaString = application.bookingObject.getGoogleSearchLog('initial')>

  <cfif len(variables.gaString)>
    <script>
      <cfoutput>#variables.gaString#</cfoutput>
    </script>
  </cfif>
</cf_htmlfoot>

<cfinclude template="/#settings.booking.dir#/components/footer.cfm">