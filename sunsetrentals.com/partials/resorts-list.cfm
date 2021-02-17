<cfquery name="getinfo" dataSource="#settings.dsn#">
	select * from cms_resorts order by name
</cfquery>

<div class="cms-resorts-option-2">
  <ul>
    <cfloop query="getinfo">
	    <cfoutput>
	    <li>
	      <div class="card">
	        <div class="row">
            <div class="col-sm-5 col-md-4 col-lg-4 col-xl-3">
	            <cfif len(mainphoto)>
		          	<a href="/resort/#slug#"><img class="card lazy" data-src="/images/resorts/#mainphoto#" src="/images/layout/1x1.png" alt="Resorts #mainphoto#"></a>
		          <cfelse>
		          	<a href="/resort/#slug#"><img class="card lazy" data-src="http://placehold.it/400x300&text=placeholder" src="/images/layout/1x1.png" alt="Resorts Placeholder"></a>
		          </cfif>
	          </div>
            <div class="col-sm-7 col-md-8 col-lg-8 col-xl-9">
	            <div class="block">
	              <p class="h3"><a href="/resort/#slug#" class="site-color-1 site-color-1-lighten-hover">#name#</a></p>
	              <p>#mid(stripHTML(description),1,200)#...</p>
	            </div>
	          </div>
	        </div>
	      </div>
	    </li>
	    </cfoutput>
    </cfloop>
  </ul>
</div>