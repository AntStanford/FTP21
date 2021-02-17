<!--- Get the popular searches --->
<cfquery name="getPopularSearches" dataSource="#settings.dsn#">
  SELECT slug,name,popularSearchPhoto
  FROM cms_pages
  WHERE popularSearch = 'Yes'
  AND id NOT IN (608,609,612,613,603)
</cfquery>

<cfquery name="getPopularLocationSearches" dataSource="#settings.dsn#">
  SELECT slug,name,popularSearchPhoto
  FROM cms_pages
  WHERE id IN (608,603,612,613)
</cfquery>

<cfif getPopularSearches.recordcount gt 0>
  <div class="i-popular-searches">
  	<div class="container popular-container">
  	  <h2 class="h1 site-color-3 text-center">Popular <span>amenity</span> Searches</h2>

      <div class="row">
        <cfloop query="getPopularSearches" endRow="4">
          <cfoutput>
          <div class="col-sm-12 col-md-6 col-lg-3">
            <div class="popular-rental">
              <div class="popular-rental-img-wrap">
                <a href="/#slug#" class="popular-rental-link">
                  <div class="popular-rental-overlay">
        	          <h3 class="popular-rental-title text-white">#name#</h3>
                  </div>
                  <span class="popular-rental-img lazy" data-src="/images/popular/#popularSearchPhoto#"></span>
                </a>
              </div><!-- END featured-property-img-wrap -->
    	      </div>
          </div>
          </cfoutput>
        </cfloop>
      </div>
    </div>

  	<div class="container popular-container">
  	  <h2 class="h1 site-color-3 text-center">Popular <span>location</span> Searches</h2>

      <div class="row">
        <cfloop query="getPopularLocationSearches">
          <cfoutput>
          <div class="col-sm-12 col-md-6 col-lg-3">
            <div class="popular-rental">
              <div class="popular-rental-img-wrap">
                <a href="/#slug#" class="popular-rental-link">
                  <div class="popular-rental-overlay">
        	          <h3 class="popular-rental-title text-white">#name#</h3>
                  </div>
                  <span class="popular-rental-img lazy" data-src="/images/popular/#popularSearchPhoto#"></span>
                </a>
              </div><!-- END featured-property-img-wrap -->
    	      </div>
          </div>
          </cfoutput>
        </cfloop>
      </div>
    </div>
  </div><!-- END i-popular-searches -->
</cfif>