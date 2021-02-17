<div class="i-header-info">
	<div class="container">
		<div class="row">
			<div class="col-xs-12">
			<div class="i-header-explore">
			    <cfoutput><a href="/gulf-coast-guide" class="text-white text-white-hover"><i class="fa fa-map"></i> Explore Our Destinations</a></cfoutput>
			</div>
			<div class="i-header-phone hide-tablet">
			  <cfif len(settings.tollFree)>
			    <cfoutput><a href="tel:<!--- #settings.tollFree# --->888-579-8540" class="text-white text-white-hover"><i class="fa fa-mobile"></i> <span class="trackphone">#settings.tollFree#</span></a></cfoutput>
			  </cfif>
			  <cfif len(settings.phone)>
			    <cfoutput><a href="tel:#settings.phone#" class="text-white text-white-hover"><i class="fa fa-mobile"></i> <span class="trackphone">#settings.phone#</span></a></cfoutput>
			  </cfif>
			</div>
			<div class="i-header-payment">
			    <cfoutput><a href="https://svr.trackhs.com/irm/payment/search/" class="text-white text-white-hover" target="_blank"><i class="fa fa-money"></i> Make a Payment</a></cfoutput>
			</div>
			
			<div class="i-header-guestportal">
			    <cfoutput><a href="https://svr.trackhs.com/guest/##!/login/" class="text-white text-white-hover" target="_blank"><i class="fa fa-map"></i> Guest Portal</a></cfoutput>
			</div>
			<!-- LOGIN/ACCOUNT -->
<!---
        <div class="i-header-login text-white">
            <cfif isdefined('cookie.GuestFocusLoggedInID')>
             <a target="_blank" href="/guest-focus/dashboard.cfm" class="text-white">
            	<cfquery name="getGuestLoyaltyUser" dataSource="#settings.dsn#">
    						select * from guest_focus_users where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#cookie.GuestFocusLoggedInID#">
    					</cfquery>
            	<cfoutput>#getGuestLoyaltyUser.firstname#</cfoutput>
            <cfelse>
             <a target="_blank" href="/guest-focus/" class="text-white">
            	Login
            </cfif>
              <i class="fa fa-user text-white" data-toggle="tooltip" data-placement="bottom" title="Create An Account"></i>
            </a>
        </div>
--->
        <div class="i-header-ownerportal">
			    <cfoutput><a href="https://svr.trackhs.com/owner/" class="text-white text-white-hover" target="_blank"><i class="fa fa-map"></i> Owner Portal</a></cfoutput>
			</div>
			
          <!---
  			<span class="i-header-location text-white">
    	    <i class="fa fa-map-marker"></i> <cfoutput>#settings.city#, #settings.state#</cfoutput>
  			</span>
        --->
        <!-- RECENTLY VIEWED -->
<!---
        <div class="i-header-viewed i-header-actions text-white">
            <span class="header-action" id="recentlyViewedToggle">Recently Viewed <i class="fa fa-eye site-color-3" data-toggle="tooltip" data-placement="bottom" title="Recently Viewed"></i> <em class="header-recently-viewed-count"><cfif StructKeyExists(cookie,'recent') and ListLen(cookie.recent)><cfoutput>#listlen(cookie.recent)#</cfoutput><cfelse>0</cfif></em></span>
            <cfinclude template="/#settings.booking.dir#/_recentlist.cfm">
        </div>
--->
        <!-- FAVORITES -->
<!---
        <div class="i-header-favorites i-header-actions text-white">
            <span class="header-action" id="favoritesToggle">Favorites <i class="fa fa-heart" data-toggle="tooltip" data-placement="bottom" title="Favorites"></i> <em class="header-favorites-count"><cfif StructKeyExists(cookie,'favorites') and ListLen(cookie.favorites)><cfoutput>#listlen(cookie.favorites)#</cfoutput><cfelse>0</cfif></em></span>
            <cfinclude template="/#settings.booking.dir#/_favoriteslist.cfm">
        </div>
--->
      </div>
    </div>
  </div>
</div><!-- END i-header-info -->
