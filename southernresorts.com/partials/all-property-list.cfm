<div class="i-content">
  <div class="container">
    <div class="row">
      <div class="col-lg-12">
        <cfcache action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="false" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files">
          <cfset getAllProperties = application.bookingObject.getAllProperties()>
          <cfoutput>
          	
    				<cfif isdefined('noUnitMessage')>
    					<div class="alert alert-warning">#noUnitMessage#</div>
    				</cfif>
          
          </cfoutput>
         <!---  <cfoutput><p class="h4">#getAllProperties.recordcount# properties listed.</p></cfoutput> --->
          <h3> #  <a href="#A">A</a>  <a href="#B">B</a>  <a href="#C">C</a>  <a href="#D">D</a>  <a href="#E">E</a>  <a href="#F">F</a>  <a href="#G">G</a>  <a href="#H">H</a>  <a href="#I">I</a>  <a href="#J">J</a>  <a href="#K">K</a>  <a href="#L">L</a>  <a href="#M">M</a>  <a href="#N">N</a>  <a href="#O">O</a>  <a href="#P">P</a>  Q  <a href="#R">R</a>  <a href="#S">S</a>  <a href="#T">T</a>  <a href="#U">U</a>  <a href="#V">V</a>  <a href="#W">W</a>  X <a href="#Y">Y</a> Z </h3>
          <cfset thelist="A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z">
          <div class="mobile-scroller"><i class="fa fa-arrows-h" aria-hidden="true"></i> Swipe to see Table contents</div>
          <div class="table-wrap table-responsive">
            <table class="table" data-toggle="table">
              <thead>
                <tr style="font-weight:bold">
                  <th data-field="property">Property</th>
                  <th data-field="locality">Location</th>
                  <!--- <th data-field="sleeps">Sleeps</th> --->
                  <th data-field="bedrooms">Bedrooms</th>
                  <th data-field="bedrooms">Bathrooms</th>
                  <!--- <th data-field="rate">Price Range</th> --->
                </tr>
              </thead>
              <cfset latest="">
              <cfoutput query="getAllProperties">
                <cfset current = left(getAllProperties.name,1)>
                <tr>
                  <td>
                    <cfif Current is not Latest><cfset Latest=Current><a name="#latest#"></a></cfif>
                    <a href="/#settings.booking.dir#/#seodestinationname#/#seoPropertyName#">#name#</a></td>
					<!---
					#detailPage#
					--->
					<!---                     /#settings.booking.dir#/#getUnitInfo.seoDestinationName#/#getUnitInfo.seoPropertyName# ---> 
					<!---  <td>#trim(sleeps)#</td> --->
                  <td>#locality#</td>
                  <td>#bedrooms#</td>
                  <td>#bathrooms#</td>
                  <!--- <cfset weeklyPriceRange = application.bookingObject.getPropertyPriceRange(propertyid)>
                  <td>#weeklyPriceRange#</td> --->
                </tr>
              </cfoutput>
            </table>
          </div>
        </cfcache>
      </div>
    </div>
  </div>
</div>

