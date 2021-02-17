<cfset getFeaturedProperties = application.bookingObject.getFeaturedProperties()>

<cfif getFeaturedProperties.recordcount gt 0>
	<div class="i-featured">
    <div class="container">
  	  <p class="h2 text-center">Featured Properties</p><br>
  	  <div class="owl-carousel owl-theme i-featured-slider">
  		  <cfoutput query="getFeaturedProperties">
  			  <div class="item site-color-3-bg">
  	  			<cfif len(photo)>
  	  				<cfset cleanPhoto = replace(photo,' ','%20','all') />
  	  				<cfset cleanPhoto = replace(cleanPhoto,'(','%28','all') />
  	  				<cfset cleanPhoto = replace(cleanPhoto,')','%29','all') />
  	    			<span class="i-featured-img owl-lazy" data-src="#cleanPhoto#"></span>
  	    	  <cfelse>
  	    	    <span class="i-featured-img owl-lazy" data-src="https://placeholdit.imgix.net/~text?txtsize=14&txt=placeholder&w=200&h=150"></span>
  	  			</cfif>
      			<ul class="i-featured-info text-center site-color-2-bg text-white">
      			  <li><i class="fa fa-bed"></i> Beds: #bedrooms#</li>
      				<li><i class="fa fa-shower"></i> Baths: #bathrooms#</li>
      			</ul>
  	  			<span class="i-featured-box">
  	  			  <span class="i-featured-name h4 site-color-2">#name#</span>
  	  			  <span class="i-featured-address h6 text-white">#address#</span>
  	  			  <a href="/booking/#seopropertyname#/#propertyid#" class="btn btn-block site-color-1-bg site-color-1-lighten-bg-hover text-white text-white-hover"><i class="fa fa-search"></i> View Details</a>
  	  			</span>
  			  </div>
  		  </cfoutput>
  	  </div>
    </div>
	</div><!-- END i-featured -->
</cfif>