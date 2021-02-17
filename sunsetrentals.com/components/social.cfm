<cfoutput>
  <cfset social="facebookURL,twitterURL,pinterestURL,youtubeURL,linkedinURL,instagramURL,yelpURL,blogURL,flickrURL">
  <ul class="i-social">
    <cfloop list="#social#" index="i">
      <cfif len(settings[i])>
        <li class="i-social-item">
          <a rel="noopener" class="i-social-link-#i#" href="#settings[i]#" target="_blank">
            <i class="fa fa-<cfif i eq "blogURL">rss<cfelse>#replace(i,'URL','')#</cfif>"></i>
            <span class="i-social-link-text">#replace(i,'URL','')#</span>
          </a>
        </li>
      </cfif>
    </cfloop>
  </ul>
</cfoutput>