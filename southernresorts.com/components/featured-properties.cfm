<cfset getFeaturedProperties = application.bookingObject.getFeaturedProperties()>

<cfif getFeaturedProperties.recordcount gt 0>
	<div class="i-featured">
	  <p class="h2 text-center">Featured Properties</p><br>
	  <div class="owl-carousel owl-theme featured-props-carousel">
		  <cfoutput query="getFeaturedProperties">
        <div class="featured-property">
          <div class="featured-property-img-wrap">
            <a href="/#settings.booking.dir#/#seopropertyname#" class="featured-property-link" target="_blank">
              <span class="featured-property-title-wrap">
                <span class="featured-property-title">
                  <h3>#name#</h3>
                  <em>#address#</em>
                </span>
              </span>
              <cfif len(photo)>
                <span class="featured-property-img" style="background:url(https://img.trackhs.com/355x231/#replace(photo,' ','%20','all')#);"></span>
              <cfelse>
                <span class="featured-property-img" style="background:url('https://placeholdit.imgix.net/~text?txtsize=14&txt=placeholder&w=200&h=150');"></span>
              </cfif>
            </a>
          </div><!-- END featured-property-img-wrap -->

          <div class="featured-property-info-wrap site-color-3-bg text-white">
            <ul class="featured-property-info">
              <li><i class="fa fa-bed text-white" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Bedrooms"></i> #bedrooms#</li>
              <li><i class="fa fa-bath text-white" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Bathrooms"></i> #bathrooms#</li>
              <li><i class="fa fa-users text-white" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Guests"></i> #sleeps#</li>
            </ul>
          </div><!-- END featured-property-info-wrap -->
        </div>
		  </cfoutput>
	  </div><!-- END featured-props-carousel -->

    <div class="cssload-container">
      <div class="cssload-tube-tunnel"></div>
    </div>

	</div>
</cfif>