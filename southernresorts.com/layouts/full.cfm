<div class="i-content">
  <div class="container">
  	<div class="row">
  		<div class="col-lg-12">
        <cfcache key="cms_pages" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files">
          <cfif len(page.h1)>
            <cfoutput><h1 class="site-color-1">#page.h1#</h1></cfoutput>
          <cfelse>
            <cfoutput><h1 class="site-color-1">#page.name#</h1></cfoutput>
          </cfif>
      		<div class="content-builder-wrap">
        		<cfoutput>#parseShortCodes(page.body)#</cfoutput>
      		</div>
        </cfcache>
        <cfif len(page.partial)><cfinclude template="/partials/#page.partial#"></cfif>
  		</div>
  	</div>
  </div>
</div><!-- END i-content -->