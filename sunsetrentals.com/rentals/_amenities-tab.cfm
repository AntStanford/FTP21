<cfset getAmenities = application.bookingObject.getPropertyAmenities(property.propertyid)>

<div id="amenities" name="amenities" class="info-wrap amenities-wrap">
  <div class="info-wrap-heading"><i class="fa fa-list" aria-hidden="true"></i> Amenities</div>
  <div class="info-wrap-body">
    	
    	<cfset theCategory = getAmenities.amenityGroupName>
    	
    	<cfoutput><p><b>#theCategory#</b></p></cfoutput>
      
      <ul>	
      <cfloop query="getAmenities">
      	
      	<cfif getAmenities.amenityGroupName eq theCategory>
      		<!--- don't show the category, we've already seen it --->
      	<cfelse>
      		</ul>
      		<hr />
      		<cfset theCategory = getAmenities.amenityGroupName>
      		<cfoutput><p><b>#theCategory#</b></p></cfoutput>
      		<ul>
      	</cfif>
      	
      	<cfoutput><li>#getAmenities.amenityName#</li></cfoutput>
      	
      </cfloop>
      </ul>
    
  </div><!-- END info-wrap-body -->
</div><!-- END amenities-wrap -->
