<cfcache action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files">
  <cfset getAllProperties = application.bookingObject.getAllProperties()>
  <cfoutput>
		<cfif isdefined('noUnitMessage')>
			<div class="alert alert-warning">#noUnitMessage#</div>
		</cfif>
  </cfoutput>
  <cfoutput>
    <p class="h4">#getAllProperties.recordcount# properties listed.</p>
  </cfoutput>
  <cfset thelist = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z">
  <cfoutput>
    <h3>
      <a href="##">##</a>
      <cfloop index="letter" list="#thelist#">
        <a href="###letter#">#letter#</a>
      </cfloop>
    </h3>
  </cfoutput>
  <div class="mobile-scroller"><i class="fa fa-arrows-h" aria-hidden="true"></i> Swipe to see Table contents</div>
  <div class="table-wrap table-responsive">
    <table class="table" data-toggle="table">
      <thead>
        <tr style="font-weight:bold">
          <th data-field="property">Property</th>
          <th data-field="sleeps">Sleeps</th>
          <th data-field="bedrooms">Bedrooms</th>
          <th data-field="bedrooms">Bathrooms</th>
          <th data-field="rate">Price Range</th>
        </tr>
      </thead>
      <cfset latest="">
      <cfoutput query="getAllProperties">
        <cfset current = left(getAllProperties.name,1)>
        <tr>
          <td>
            <cfif Current is not Latest><cfset Latest=Current><a name="#latest#"></a></cfif>
            <a href="/#settings.booking.dir#/#seoPropertyName#">#name#</a>
          </td>
          <td>#trim(sleeps)#</td>
          <td>#bedrooms#</td>
          <td>#bathrooms#</td>
          <cfset weeklyPriceRange = application.bookingObject.getPropertyPriceRange(propertyid)>
          <td>#weeklyPriceRange#</td>
        </tr>
      </cfoutput>
    </table>
  </div>
</cfcache>