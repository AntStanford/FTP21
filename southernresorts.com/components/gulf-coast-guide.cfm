<cfquery name="getGulfCoastGuide" dataSource="#settings.dsn#">
	  select *
	  from cms_gulfcoast_guide_callouts
	  order by sort
</cfquery>
<div class="<cfif isdefined('slug') and slug eq "index">container-fluid gcg-callouts-home<cfelse>container </cfif>callouts-wrapper gcg-callouts-wrapper">
	<div class="row">
		<div class="col-lg-12">
		  <cfif isdefined('page.slug') and page.slug eq "index">
			  <h3 class="header-subtext">Come &amp; Explore</h3>
			  <p class="h1 h1-header site-color-3">The Gulf Coast Guide</p>
	    <cfelse>
	    <p class="h1 h1-header site-color-3"><cfif isdefined('page.slug') and page.slug eq "gulf-coast-guide">Explore the Gulf Coast<cfelse>Explore <cfoutput>#getdestinations.title#</cfoutput></cfif></p>
      </cfif>
			</div>
			<cfoutput query="getGulfCoastGuide">
				<div class="col-xs-12 col-sm-3 nopadding gcg-callout">
  				<cfif lcase(left(link,4)) is 'http'>
    				<a href="#link#" target="_blank">
      		<cfelse>
  		  		<a href="/#link#">
      		</cfif>
				  	<div class="callout-text">
			    		<div class="h5 callout-subtext">#title#</div>
			    		<div class="h4 callout-category">#heading2#</div>
			    	</div>
			    	<cfif isdefined('slug') and slug eq "index">
					    <img class="lazy" data-src="/images/gc-guide-callouts/#photo#" src="/images/layout/1x1.png" alt="gcg-callout">
					  <cfelse>
					    <img class="lazy" data-src="/images/gc-guide-callouts/#photo#" src="/images/layout/1x1.png" alt="gcg-callout">
					  </cfif>
				  </a>
				</div>
			</cfoutput>
	</div>
</div>