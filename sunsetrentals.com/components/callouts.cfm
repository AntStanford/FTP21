<cfquery name="getCallouts" dataSource="#settings.dsn#">
  select id,title,description,photo,link
  from cms_callouts
  order by sort
</cfquery>

<div class="i-callouts site-color-1-bg">
  <div class="container-fluid">
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
    		<div class="col">
          <div class="callout-wrap">
            <h4 class="callout-title text-white">#title#</h4>
            <div class="callout-img">
              <img class="lazy" data-src="/images/callouts/#photo#" src="/images/layout/1x1.png" alt="#title#" width="100%">
            </div>
            <div class="callout-rollover-wrap">
              <div class="callout-rollover">
                <h4 class="callout-title text-white">#title#</h4>
                <div class="callout-desc text-white">
                  #description#
                  <!---
                  <cfif len(description) gt 100>
                    #left(description,100)#...
                  <cfelse>
                    #description#
                  </cfif>
                  --->
                </div>
                <a href="#newLink#" class="btn site-color-2-bg-hover text-white">More Details</a>
              </div>
            </div><!-- END callout-rollover-wrap -->
          </div>
    		</div>
    	</cfoutput>
    </div>
  </div>
</div>