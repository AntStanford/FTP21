<cfif cgi.script_name eq "/destination-page.cfm">

<cfquery name="getDestination" datasource="#settings.dsn#">
  SELECT cd.id,Title, bannerImage, canonicalLink, h1, metaTitle, metaDescription, description, nodeid, t.name as locality
  FROM cms_destinations cd left JOIN track_nodes t on t.id = cd.nodeid
  WHERE Slug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.slug#"> and cd.hideonsite = <cfqueryparam cfsqltype="varchar" value="No">
</cfquery>

<cfif getDestination.recordcount eq 0>
  <cflocation url="/gulf-coast-guide" addtoken="false">
</cfif>

<cfif (isdefined('getDestination.nodeid') and LEN(getDestination.nodeid)) or( isdefined('getDestination.id') and LEN(getDestination.id))>
<cfquery name="getDestinationCallOuts" datasource="#settings.dsn#">
  SELECT Title, Description, Photo,link
  FROM cms_destinations_callouts
  WHERE destination_id = <cfif getDestination.nodeid EQ 0 and isdefined('getDestination.id') and LEN(getDestination.id)><cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getDestination.id#"><cfelse><cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getDestination.nodeid#"></cfif>
</cfquery>
</cfif>
<div class="<cfif isdefined('page.slug') and page.slug eq 'index'>i-hero-wrap<cfelse>i-hero-wrap int</cfif>">
  <cfif mobileDetect>
    <div class="i-hero-img-wrap"><div class="i-hero-img" style="background:url('/images/layout/hero-mobile.jpg') no-repeat;"></div></div>
  <cfelse>
<!---
	  <cfif isdefined('page.slug') and page.slug eq 'index'>
  	  <!--- Home Page Slide Show --->
      <cfquery name="getHomeSlides" dataSource="#settings.dsn#">
        select * from cms_assets where section = 'Homepage Slideshow' order by sort
      </cfquery>
      <cfinclude template="/components/alert-banners.cfm">
      <div class="owl-carousel owl-theme hp">
        <cfoutput query="getHomeSlides">
          <div class="i-hero-img-wrap">
<!--- 	          <div class="banner-title"><div class="carousel-intro"><!--- Welcome to the Gulf Coast --->#name#</div><h1><!--- Sweet Southern Moments --->#caption#</h1><!--- <a class="southern-btn" href="">Learn About Us<i class="fa fa-arrow-right"></i></a> ---></div> --->
	          <div class="i-hero-img owl-lazy" data-src="/images/homeslideshow/#replace(thefile,' ','%20','all')#"></div></div>
        </cfoutput>
      </div>
    <cfelseif isdefined('page.headerImage') and len(trim(page.headerImage)) GT 0>
--->
      <div class="i-hero-img-wrap"><div class="i-hero-img" style="background:url('/images/header/<cfoutput>#getDestination.bannerImage#</cfoutput>') no-repeat;"></div></div>
<!---
    <cfelseif isdefined('page.videoLinkURL') and len(trim(page.videoLinkURL)) GT 0>
    
    
      <div class="i-hero-img-wrap"><!--- <div class="i-hero-img" style="background:url('/images/header/<cfoutput>#page.headerImage#</cfoutput>') no-repeat;"></div> --->
      <iframe width="100%" height="100%" src="<cfoutput>#page.videoLinkURL#</cfoutput>" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
      </div>
      
      
    <cfelse>
      <div class="i-hero-img-wrap"><div class="i-hero-img" style="background:url('/images/layout/hero-int.jpg') no-repeat;"></div></div>
	  </cfif>
--->
  </cfif>
</div><!-- END i-hero-wrap -->



<cfelse>




<div class="<cfif isdefined('page.slug') and page.slug eq 'index'>i-hero-wrap<cfelse>i-hero-wrap int</cfif>">
  <cfif mobileDetect>
    <div class="i-hero-img-wrap"><div class="i-hero-img" style="background:url('/images/layout/hero-mobile.jpg') no-repeat;"></div></div>
  <cfelse>
	  <cfif isdefined('page.slug') and page.slug eq 'index'>
  	  <!--- Home Page Slide Show --->
      <cfquery name="getHomeSlides" dataSource="#settings.dsn#">
        select * from cms_assets where section = 'Homepage Slideshow' order by sort
      </cfquery>
      <cfinclude template="/components/alert-banners.cfm">
      <div class="owl-carousel owl-theme hp">
        <cfoutput query="getHomeSlides">
          <div class="i-hero-img-wrap">
<!--- 	          <div class="banner-title"><div class="carousel-intro"><!--- Welcome to the Gulf Coast --->#name#</div><h1><!--- Sweet Southern Moments --->#caption#</h1><!--- <a class="southern-btn" href="">Learn About Us<i class="fa fa-arrow-right"></i></a> ---></div> --->
	          <div class="i-hero-img owl-lazy" data-src="/images/homeslideshow/#replace(thefile,' ','%20','all')#"></div></div>
        </cfoutput>
      </div>
    
    <cfelseif isdefined('page.videoLinkURL') and len(trim(page.videoLinkURL)) GT 0>
      <div class="i-hero-img-wrap"><!--- <div class="i-hero-img" style="background:url('/images/header/<cfoutput>#page.headerImage#</cfoutput>') no-repeat;"></div> --->
      <iframe width="100%" height="100%" src="https://www.youtube.com/embed/brqObHQ7k7U" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
      </div>
    <cfelseif isdefined('page.headerImage') and len(trim(page.headerImage)) GT 0>
      <div class="i-hero-img-wrap"><div class="i-hero-img" style="background:url('/images/header/<cfoutput>#page.headerImage#</cfoutput>') no-repeat;"></div></div>
    <cfelseif isdefined('getCategory.photo') and len(trim(getCategory.photo)) GT 0>
      <div class="i-hero-img-wrap gcg-cat-hero-wrap"><div class="i-hero-img" style="background:url('/images/thingstodo/<cfoutput>#getCategory.photo#</cfoutput>') no-repeat;"></div></div>
    <cfelse>
    
      <cfif cgi.query_string contains 'weddings-test'>
	      <div class="i-hero-img-wrap wedding-hero-wrap"><div class="i-hero-img" style="background:url('/images/layout/hero-int.jpg') no-repeat;"></div></div>
	    <cfelse>
	      <div class="i-hero-img-wrap"><div class="i-hero-img" style="background:url('/images/layout/hero-int.jpg') no-repeat;"></div></div>
      </cfif>
 	  </cfif>
  </cfif>
  <cfif cgi.script_name contains 'booking' or (isdefined('page.partial') and page.partial eq 'results.cfm') or cgi.script_name eq '/layouts/special.cfm' or cgi.script_name eq '/layouts/resort.cfm'>
    <!--- No quicksearch on these pages --->
  <cfelse>
    <cfinclude template="/components/quick-search.cfm">
  </cfif>
</div><!-- END i-hero-wrap -->




</cfif>
