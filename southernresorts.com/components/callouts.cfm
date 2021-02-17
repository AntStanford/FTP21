<cfquery name="getCallouts" dataSource="#settings.dsn#">
  select id,title,description,photo,link
  from cms_callouts
  order by sort
</cfquery>

<div class="i-callouts">
  <div class="row">
  	<cfoutput query="getCallouts">
      <!--- Handle slugs vs external links - pages in subfolders need absolute URL's for links --->
      <cfif findnocase('http',link)>
        <cfset newLink = link />
      <cfelse>
        <cfif cgi.server_name eq settings.devURL>
          <cfset newLink = "http://#settings.devURL#/#link#" />
        <cfelse>
          <cfset newLink = "http://#settings.website#/#link#" />
        </cfif>
      </cfif>
  		<div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
        <div class="thumbnail site-color-3-bg site-color-1-bg-hover">
          <a href="#newLink#"><img src="/images/callouts/#photo#" alt="#title#" width="100%"></a>
          <div class="caption">
            <p class="h4 text-white">#title#</p>
            <p>
              <cfif len(description) gt 100>
                #left(description,100)#...
              <cfelse>
                #description#
              </cfif>
            </p>
            <p><a href="#newLink#" class="btn btn-block site-color-3 site-color-4-bg site-color-4-lighten-bg-hover"><i class="fa fa-file-text-o"></i> Click for Details</a></p>
          </div>
        </div>
  		</div>
  	</cfoutput>
  </div>
</div>