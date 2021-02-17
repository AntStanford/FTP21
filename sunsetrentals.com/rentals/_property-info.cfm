<cfquery name="dQuery" dataSource="#variables.settings.booking.dsn#">
	select * from track_properties_custom_data where customDataId="72" and propertyid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#property.propertyid#">
</cfquery>

<cfoutput>
<div class="property-overview">
  <h1 class="property-name">#property.name#</h1>
  <cfif len(trim(property.shortDescription)) GT 0>
    <cfset variables.cleanShortDesc = reReplace( property.shortDescription, '[\n\r]', '<br/>', 'all' ) />
    <div class="property-quick-desc">#variables.cleanShortDesc#</div>
  </cfif>

  <div class="header-actions-refine pull-right">
    <a href="javascript:;" class="header-actions-action site-color-1-bg-hover" id="recentlyViewedToggle">
      <div rel="tooltip" data-placement="bottom" title="Properties you have Recently Viewed">
        <small>Viewed</small>
        <i class="fa fa-eye text-white"></i>
        <span><em class="header-recently-viewed-count"><cfif StructKeyExists(cookie,'recent') and ListLen(cookie.recent)><cfoutput>#listlen(cookie.recent)#</cfoutput><cfelse>0</cfif></em></span>
      </div>
    </a>
    <cfinclude template="/#settings.booking.dir#/_recentlist.cfm">

    <a href="javascript:;" class="header-actions-action site-color-1-bg-hover" id="favoritesToggle">
      <div rel="tooltip" data-placement="bottom" title="Your Favorited Properties">
        <small>Favorites</small>
        <i class="fa fa-heart"></i>
        <span><em class="header-favorites-count"><cfif StructKeyExists(cookie,'favorites') and ListLen(cookie.favorites)><cfoutput>#listlen(cookie.favorites)#</cfoutput><cfelse>0</cfif></em></span>
      </div>
    </a>
    <cfinclude template="/#settings.booking.dir#/_favoriteslist.cfm">
  </div><!-- END header-actions -->


  <!---<div class="price-range">#priceRange#</div>--->
  <cfif getAvgRating.recordcount gt 0 and getAvgRating.average neq ''>
	  <div class="star-rating">
	    <cfif ceiling(getAvgRating.average) eq 1>
	    	<i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star-o" aria-hidden="true"></i><i class="fa fa-star-o" aria-hidden="true"></i><i class="fa fa-star-o" aria-hidden="true"></i><i class="fa fa-star-o" aria-hidden="true"></i>
	    <cfelseif ceiling(getAvgRating.average) eq 2>
	    	<i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star-o" aria-hidden="true"></i><i class="fa fa-star-o" aria-hidden="true"></i><i class="fa fa-star-o" aria-hidden="true"></i>
	    <cfelseif ceiling(getAvgRating.average) eq 3>
	    	<i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star-o" aria-hidden="true"></i><i class="fa fa-star-o" aria-hidden="true"></i>
	    <cfelseif ceiling(getAvgRating.average) eq 4>
	    	<i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star-o" aria-hidden="true"></i>
	    <cfelseif ceiling(getAvgRating.average) eq 5>
	    	<i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star" aria-hidden="true"></i>
	    </cfif>
	    Average Rating
	  </div>
  </cfif>
  <hr>
  <div class="property-info">
    <cfif len(property.address)><span class="property-info-item"><strong>Address:</strong> #property.address#</span></cfif>
    <cfif len(property.location)><span class="property-info-item"><strong>Location:</strong> #property.location#</span></cfif>
    <cfif len(property.type)><span class="property-info-item"><strong>Type:</strong> #property.type#</span></cfif>
    <cfif len(property.view)><span class="property-info-item"><strong>View:</strong> #property.view#</span></cfif>
  </div><!-- END property-info -->
  <div class="property-info property-info-icons">
    <span class="property-info-item info-icon"><i class="fa fa-bed" aria-hidden="true"></i> #property.bedrooms# Beds <!--- (2K, 3Q, 4T) ---></span>
    <cfif dQuery.data gt 0 >
    <span class="property-info-item info-icon"><i class="fa fa-building" aria-hidden="true"></i>Floor in Building: #dQuery.data#  <!--- (2K, 3Q, 4T) ---></span>
    </cfif>
    <span class="property-info-item info-icon"><i class="fa fa-bath" aria-hidden="true"></i>
     Full Baths: #property.bathrooms#<cfif property.threeQuarterBathrooms GT 0>, 3/4 Baths: #property.threeQuarterBathrooms#</cfif><cfif property.halfBathrooms GT 0>, Half Baths: #property.halfBathrooms#</cfif>
    </span>
    <span class="property-info-item info-icon"><i class="fa fa-users" aria-hidden="true"></i> Sleeps #property.sleeps#</span>
    <span class="property-info-item info-icon"><i class="fa fa-paw" aria-hidden="true"></i> #property.petsallowed#</span>
  </div><!-- END property-info -->
</div><!-- END property-overview -->
</cfoutput>
