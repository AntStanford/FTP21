<cfquery name="getinfo" dataSource="#settings.dsn#">
	select * from cms_resorts order by name
</cfquery>

<div class="cms-resorts-option-1">
  <div class="row">
    <cfloop query="getinfo">
	    <cfoutput>
		    <div class="col-lg-4 col-md-6 col-sm-4 col-xs-6">
		      <div class="block">
		        <div class="thumbnail">
		        	 <cfif len(mainphoto)>
		          	<a href="/resort/#slug#"><img src="/images/resorts/#mainphoto#"></a>
		          <cfelse>
		          	<a href="/resort/#slug#"><img src="http://placehold.it/400x300&text=placeholder"></a>
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