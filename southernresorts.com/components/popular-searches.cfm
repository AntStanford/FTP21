<cfif getPopularSearches.recordcount gt 0>
<div class="i-popular-searches site-color-3-bg">
  <div class="container">
    <p class="h2 text-center text-white">Popular Vacation Rental Searches</p><br>
    <div class="row">
      <cfloop query="getPopularSearches">
	      <cfoutput>
	      <div class="col-lg-4 col-md-4 col-sm-6">
	        <a href="/#slug#" class="i-popular-searches-item">
	          <span class="i-popular-searches-img" style="background:url('../images/popular/#popularSearchPhoto#');"></span>
	          <span class="i-popular-searches-overlay site-color-1-bg"></span>
	          <span class="i-popular-searches-title h5 text-white">#name#</span>
	        </a>
	      </div>
	      </cfoutput>
      </cfloop>
    </div>
  </div>
</div>
</cfif>