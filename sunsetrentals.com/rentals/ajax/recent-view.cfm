<span class="header-dropbox-close"><i class="fa fa-close"></i></span>
<span class="header-dropbox-title">Recently Viewed</span>

<cfif isdefined('cookie.recent') and ListLen(cookie.recent)>

  <ul class="header-dropbox-list">
  	<cfloop list="#cookie.recent#" index="i">

    	<cfset getRecentProperty = application.bookingObject.getProperty(i)>

    	<cfoutput query="getRecentProperty">
        <li class="header-dropbox-list-item">
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
                  <em>#location#</em>
                </span>
              </div>
            </div>
          </a>
        </li>
    	</cfoutput>
  	</cfloop>
  </ul>

<cfelse>

	<div class="alert alert-danger" style="margin:0;">
  	You have not recently viewed any properties.
	</div>

</cfif>