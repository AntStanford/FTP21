<div class="container explore-wrapper destinations-wrapper">
	<div class="row">
		<div class="col-lg-12">
		<h3 class="header-subtext">Southern Vacation Rentals</h3>
		<p class="h1 h1-header site-color-3"><cfif isdefined('page.slug') and page.slug eq 'index'>Experience<cfelse>Explore</cfif> Our Destinations</p>
		</div>			
		<cfquery name="getDestinations" dataSource="#settings.dsn#">
		  select bannerImage,title,slug,homepageSlug
		  from cms_destinations
		  where hideOnSite = 'No'
		  order by title
		  limit 10
		</cfquery>
		<cfloop query="getDestinations">
			<cfif isdefined('page.slug') and page.slug eq 'index' and LEN(homepageSlug)>
				<cfset thisSlug = homepageSlug>
			<cfelse>
				<cfset thisSlug = '/gulf-coast-guide/' & slug>
			</cfif>
			<div class="col-xs-12 destination-callout" style="background: url('<cfif len(bannerImage) gt 0><cfoutput>/images/header/#bannerImage#</cfoutput><cfelse>//via.placeholder.com/728x90.png?text=</cfif>')">
			  <span><cfoutput>#title#</cfoutput></span><a href="<cfoutput>#thisSlug#</cfoutput>" target="_blank"><div class="destination-btn">Explore <cfoutput>#title#</cfoutput></div></a>
			</div>
		</cfloop>
		<!---<div class="col-lg-12"><img src="/images/layout/destination-banner.jpg" alt=""></div>--->
	</div>
</div><!--END destinations-wrapper-->
