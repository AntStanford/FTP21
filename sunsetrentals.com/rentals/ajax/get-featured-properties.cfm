<cfsetting enablecfoutputonly="true">

<cfprocessingdirective suppressWhiteSpace="true">
  <cfoutput>
    <cfsavecontent variable="featuredProperties">

		<cfset getFeaturedProperties = application.bookingObject.getFeaturedProperties()>

      <link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet" integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr" crossorigin="anonymous">
      <link href="/wp-content/themes/shazaam-child/css/jquery-ui.min.css" rel="stylesheet">
      <script src="/wp-content/themes/shazaam-child/js/jquery-ui.min.js"></script>

      	<div class="i-featured">
      	  <div class="owl-carousel owl-theme featured-props-carousel">

            <cfloop query="getFeaturedProperties">

              <div class="featured-property">
                <div class="featured-property-img-wrap">
                  <a href="/rentals/#seopropertyname#" class="featured-property-link" target="_blank">
                    <span class="featured-property-title-wrap">
                      <span class="featured-property-title">
                        <h3>#name#</h3>
                        <em>#address#</em>
                      </span>
                    </span>
                    <span class="featured-property-img" style="background:url('https://img.trackhs.com/355x231/#photo#');"></span>
                  </a>
                </div><!-- END featured-property-img-wrap -->
                <div class="featured-property-info-wrap site-color-1-bg text-white">
                  <ul class="featured-property-info">
                    <li><i class="fa fa-bed text-white" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Bedrooms"></i> #bedrooms#</li>
                    <li><i class="fa fa-bath text-white" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Bathrooms"></i>#bathrooms#</li>
                    <li><i class="fa fa-users text-white" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Guests"></i> #sleeps#</li>
                  </ul>
                </div><!-- END featured-property-info-wrap -->
              </div>

            </cfloop>

      	  </div>
          <div class="cssload-container">
            <div class="cssload-tube-tunnel"></div>
          </div>
      	</div>

        <script type="text/javascript">
          jQuery(function ($) {
            // FEATURED PROPERTIES SLIDER
            if ($('.owl-carousel.featured-props-carousel').length) {
              $('.owl-carousel.featured-props-carousel').hide().delay(1500).fadeIn();

              $('.owl-carousel.featured-props-carousel').owlCarousel({
                responsive: {0:{items: 1}, 768:{items: 2}, 993:{items: 3}}, margin: 15, autoplay: false, smartSpeed: 1000, lazyLoad: true, loop: false, nav: true, navText: ["<i class='fa fa-arrow-left text-white'></i>","<i class='fa fa-arrow-right text-white'></i>"], dots: false
              });

              // LOADER BEFORE CAROUSEL LOADS IN
              $('.cssload-container').delay(1200).fadeOut();
            }
          });
        </script>

    </cfsavecontent>
  </cfoutput>
  <cfoutput>#featuredProperties#</cfoutput>
</cfprocessingdirective>