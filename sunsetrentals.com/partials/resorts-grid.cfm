<cfquery name="getinfo" dataSource="#settings.dsn#">
	select * from cms_resorts order by name
</cfquery>

<div class="cms-resorts-option-1">
  <div class="row">
    <cfloop query="getinfo">
	    <cfoutput>
		    <div class="col-sm-12 col-md-6 col-lg-4">
		      <div class="block">
		        <div class="card">
		        	 <cfif len(mainphoto)>
		          	<a href="/resort/#slug#"><img class="lazy" data-src="/images/resorts/#mainphoto#" src="/images/layout/1x1.png" alt="Resorts #mainphoto#"></a>
		          <cfelse>
		          	<a href="/resort/#slug#"><img class="lazy" data-src="http://placehold.it/400x300&text=placeholder" src="/images/layout/1x1.png" alt="Resorts Placeholder"></a>
		          </cfif>
		        </div>
		        <p class="h3 site-color-2">#name#</p>
		        <p>#mid(description,1,200)#...</p>
		        <a href="/resort/#slug#" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white text-white-hover">More Information</a>
		      </div>
		    </div>
	    </cfoutput>
    </cfloop>
  </div>
</div>