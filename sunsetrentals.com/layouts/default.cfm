<!--- standard 2 column layout --->
<div class="i-content int">
  <div class="container">
  	<div class="row">
  		<div class="col-md-12 col-lg-8 col-xl-8">
        <cfcache key="cms_pages" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files">
          <cfif len(page.h1)>
            <cfoutput><h1 class="site-color-3">#page.h1#</h1></cfoutput>
          <cfelse>
            <cfoutput><h1 class="site-color-3">#page.name#</h1></cfoutput>
          </cfif>
      		<div class="content-builder-wrap">
        		<cfset tempBody = replace(page.body,'assets/minimalist-basic','https://www.sunsetrentals.com/assets/minimalist-basic','all')>
        		<cfoutput>#tempBody#</cfoutput>
      		</div>
  			</cfcache>
  			<cfif len(page.partial)><cfinclude template="/partials/#page.partial#"></cfif>
  		</div>
  		<div class="col-md-12 col-lg-4 col-xl-4">
    		<div class="i-sidebar">
    			<cfinclude template="/components/callouts.cfm">
    		</div>
  		</div>
  	</div>
  </div>
</div><!-- END i-content -->