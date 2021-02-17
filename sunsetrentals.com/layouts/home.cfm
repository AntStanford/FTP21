<cfinclude template="/components/popular-searches.cfm">

<cfinclude template="/components/featured-properties.cfm">

<cfinclude template="/components/callouts.cfm">

<div class="i-content">
	<div class="i-welcome">
    <div class="container">
    	<div class="row">
    		<div class="col-sm-12">
          <cfcache key="cms_pages" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files">
            <div class="welcome-content-wrap lazy" data-src="/images/layout/welcome-img.jpg">
          		<div class="welcome-content text-center">
            		<img class="lazy" src="/images/layout/1x1.png" data-src="/images/layout/palms-img.png" style="height:100px!important;" alt="Sunset Rentals">
            		<cfoutput>
            		<cfif len(page.h1)>
            		  <h1 class="h3 site-color-3">#page.h1#</h1>
            		<cfelse>
            		  <h1 class="h3 site-color-3">#page.name#</h1>
            		</cfif>
            		</cfoutput>
                <br>
            		<div class="content-builder-wrap">
              		<cfset tempBody = replace(page.body,'assets/minimalist-basic','https://www.sunsetrentals.com/assets/minimalist-basic','all')>
              		<cfoutput>#tempBody#</cfoutput>
              		<a href="/property-management-services/about-us" class="btn btn-block site-color-1-bg site-color-2-bg-hover text-white">Learn More</a>
                </div>
          		</div><!-- END welcome-content -->
        		</div>
          </cfcache>
    		</div>
    	</div>
    	<cfif len(page.partial)>
      	<div class="row">
      		<div class="col">
            <cfinclude template="/partials/#page.partial#">
      		</div>
      	</div>
    	</cfif>
    </div>
	</div>
</div><!-- END i-content -->

<div class="seo-content">
  <div class="container pt-4 pb-4">
  	<div class="row">
  		<div class="col-sm-12">
        <h2>It's just better here.</h2>
        <p>We Offer Hilton Head vacation rentals with a wide variety of vacation homes, villas and condos for a vacation you will always remember.</p>
        <p>We want to assist you in choosing your Hilton Head rental home, by matching you with the type of vacation you are looking for. We have many Hilton Head pet friendly rentals. If you are looking for sports then look no further. Hilton Head has world class golf and tennis, and we offer golf packages or tennis packages that will suit you perfectly.</p>
        <p>Hilton Head Island also offers great dining and shopping that exceeds even the highest expectations. And don't worry kids, there are awesome activities that you will think are pretty cool, just for kids or for the whole family.</p>
        <p>Whether you want fireworks on the marina outside your window, an oceanfront balcony, or a fairway view poolside, Sunset Rentals can provide you with the best from which to choose, with over 200 homes & villas for weekly Hilton Head vacation rentals. Browse our selection of luxury Hilton Head rentals and start planning your next South Carolina beach getaway today!</p>
        <h2>Why wait?</h2>
        <p>Search for your perfect vacation spot now!</p>
  		</div>
  	</div>
  </div>
</div><!-- END seo-content -->
