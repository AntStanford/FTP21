<span class="header-dropbox-close"><i class="fa fa-close"></i></span>
<span class="header-dropbox-title">
  Favorites
  <cfif isdefined('cookie.favorites') and ListLen(cookie.favorites)>
    <cfoutput><a href="/#settings.booking.dir#/compare-favs.cfm" class="btn btn-mini site-color-1-bg site-color-1-lighten-bg-hover text-white text-white-hover pull-right compare-favs-btn">Compare Favs</a></cfoutput>
  </cfif>
</span>

<cfif isdefined('cookie.favorites') and ListLen(cookie.favorites)>

  <ul class="header-dropbox-list">
    <cfloop list="#cookie.favorites#" index="i">

  		<!--- Now I need to get some basic info about the properties in the favorites --->
  		<cfset getFavProperty = application.bookingObject.getProperty(i)>


  		<cfoutput query="getFavProperty">
        <li class="header-dropbox-list-item" data-unitcode="#i#" id="#i#">
          <a href="/#settings.booking.dir#/#seoPropertyName#" class="header-dropbox-list-link site-color-1" target="_blank">
            <div class="row">
              <div class="col-lg-5 col-md-4 col-sm-5 col-xs-12">
                <cfif len(defaultPhoto)>
                  <span class="header-dropbox-list-img" style="background:url('https://img.trackhs.com/134x87/#defaultPhoto#');"></span>
                <cfelse>
                  <span class="header-dropbox-list-img" style="background:url('/#settings.booking.dir#/images/no-img.jpg');"></span>
                </cfif>
              </div>
              <div class="col-lg-7 col-md-8 col-sm-7 col-xs-12">
                <span class="header-dropbox-list-title">
                  <strong>#name#</strong>
                  <em>#type#</em>
                </span>
              </div>
            </div>
          </a>
          <button type="button" class="btn btn-mini site-color-1-bg site-color-1-lighten-bg-hover text-white is-favorited remove-from-favs-list">Remove</button>
        </li>
  		</cfoutput>
    </cfloop>
  </ul>

<cfelse>

	<div class="alert alert-danger" style="margin:0;">
  	You do not have any favorites saved at this time.
	</div>

</cfif>