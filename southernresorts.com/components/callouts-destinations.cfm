<div class="experience-listings">
  <cfif isdefined('getDestinationCallOuts')>
    <cfloop query="getDestinationCallOuts">
      <cfif Len(getDestinationCallOuts.Title)>
        <cfif findnocase('http',link)>
          <cfset newLink = link />
        <cfelse>
          <cfif cgi.server_name eq settings.devURL>
            <cfset newLink = "https://#settings.devURL#/#link#" />
          <cfelse>
            <cfset newLink = "https://#settings.website#/#link#" />
          </cfif>
        </cfif>
        <a href="<cfoutput>#newlink#</cfoutput>" target="_blank">
          <div class="col-xs-12 col-sm-3 experience-listing">
            <img src="<cfif Len('getdestinationcallouts.photo')>/images/callouts/<cfoutput>#getDestinationCallOuts.Photo#</cfoutput><cfelse>//via.placeholder.com/728x90.png?text=</cfif>">
            <div class="pdp-callout-text">
              <div class="h4 callout-category"><cfoutput>#getDestinationCallOuts.Title#</cfoutput></div>
              <div class="h5 callout-subtext"><cfoutput>#getDestinationCallOuts.Description#</cfoutput></div>
            </div>
          </div>
        </a>
      </cfif>
    </cfloop>
  </cfif>
</div><!--- END experience-listings --->