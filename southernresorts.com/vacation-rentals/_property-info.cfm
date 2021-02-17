<cfoutput>
  <div class="property-overview">
    <h1 class="property-name">#property.name#</h1>
    <!--- <div class="price-range">#priceRange#</div> --->
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
    <!--- <hr> --->
  	<cfquery name="getDest" datasource="#settings.dsn#">
  	select id,title from cms_destinations where nodeid = <cfif property.typeid3 EQ 3 ><cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#property.nodeid3#"><cfelseif property.typeid EQ 3 ><cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#property.nodeid#"><cfelse><cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#property.nodeid2#"></cfif>
  	</cfquery>
    <div class="property-info">
      <!--- <cfif len(property.address)><span class="property-info-item"><strong>Address:</strong> #property.address#</span></cfif> --->
      <cfif len(property.location)><span class="property-info-item"><!--- <span><!--- #locality# --->Locality:</span> ---><!--- #property.location# ---><!--- #property.region# ---><cfif getDest.title EQ "30A">#property.location#<cfelse>#getdest.title#</cfif>, #property.state#</span></cfif>
    <!---
      <cfif len(property.type)><span class="property-info-item"><strong>Type:</strong> #property.type#</span></cfif>
      <cfif len(property.view)><span class="property-info-item"><strong>View:</strong> #property.view#</span></cfif>
    --->
    </div><!-- END property-info -->
    <div class="property-info property-info-icons">
      <span class="property-info-item info-icon"><i class="fa fa-users" aria-hidden="true"></i> <!--- Sleeps --->#property.sleeps# Guests</span>
      <!---<span class="property-info-item info-icon"><i class="fa fa-paw" aria-hidden="true"></i> #property.petsallowed#</span> --->
      <span class="property-info-item info-icon">
        <i class="fa fa-bed" aria-hidden="true"></i>
        #property.bedrooms# Bedrooms <!--- (2K, 3Q, 4T) --->
      </span>
      <span class="property-info-item info-icon">
        <i class="fa fa-bath" aria-hidden="true"></i>
        #property.bathrooms# Full<cfif property.halfBathrooms AND property.halfBathrooms GT 0>, #property.halfBathrooms# Half Baths<cfelse> Bath<cfif property.bathrooms neq 1>s</cfif></cfif>
      </span>
      <cfif isdefined('property.distanceToBeach') and LEN(property.distanceToBeach)>
        <span class="property-info-item info-icon">
        
          <i class="fa fa-map-marker" aria-hidden="true"></i>
          <a href="##map" class="dtb">
          Distance To Beach: #property.distanceToBeach#
          </a>
        </span>
      </cfif>
      <cfquery name="GetHousesThatWork" datasource="#settings.dsn#">
      Select slug from cms_reunions_retreats_locations where id =
        (Select areaid from cms_reunions_retreats where propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#property.propertyid#">)
      </cfquery>
      <cfif GetHousesThatWork.recordcount gt 0>
        <span class="property-info-item homes-wt"><a href="/partials/area-results.cfm?area=#GetHousesThatWork.slug#" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white">Homes That Work Together</a></span>
      </cfif>
    </div><!-- END property-info -->
  </div><!-- END property-overview -->
</cfoutput>