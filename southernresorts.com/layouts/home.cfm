
<div class="i-content">
	<div class="i-welcome text-center">
	    <div class="container">
	    	<div class="row">
	    		<div class="col-lg-12">
		    		<h3>Southern Vacation Rentals</h3>
	          <cfcache key="cms_pages" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files">
	        		<cfif len(page.h1)>
	        		  <cfoutput><h1 class="site-color-3">#page.h1#</h1></cfoutput>
	        		<cfelse>
	        		  <cfoutput><h1 class="site-color-3">#page.name#</h1></cfoutput>
	        		</cfif>
	        		<div class="content-builder-wrap">
	          		<cfoutput>#parseShortCodes(page.body)#</cfoutput>
	        		</div>
	          </cfcache>
	    		</div>
	    	</div>
	    </div>
	</div>
	<cfinclude template="/components/destinations.cfm">
	<cfinclude template="/components/callouts-homepage.cfm">
	<!---
		<cfquery name="getCallouts" dataSource="#settings.dsn#">
		  select id,title,description,photo,link
		  from cms_callouts
		  order by sort
		</cfquery>
	--->
  <cfinclude template="/components/gulf-coast-guide.cfm">
  <cfinclude template="/partials/featured-blog-posts.cfm">
  
	<div class="join-wrapper">
		<div class="management-wrapper">
	    	<div class="row">
	    		<div class="join-left">
					<img src="/images/layout/join-management-bg-left.jpg" alt="Join Management">
	    		</div>
	    		<div class="join-text">
					<h3>Join the perfect <span>management team</span></h3>
					<p>If you're considering putting your beach accommodation on a rental program, please visit our vacation rental property management page for information about how to join Southern.</p>
					<a class="southern-btn" href="https://www.joinsouthern.com" target="_blank">Join Our Team<i class="fa fa-arrow-right"></i></a>
		    	</div>
	    		<div class="join-right">
					<img src="/images/layout/join-management-bg-right.jpg" alt="Join Management">
	    		</div>
	    	</div>
		</div>
	</div>
</div><!-- END i-content -->