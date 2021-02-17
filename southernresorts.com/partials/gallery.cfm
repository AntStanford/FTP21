<cfcache key="cms_assets" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files">
  <cfquery name="getinfo" dataSource="#settings.dsn#">
  	select * from cms_assets
  	where section = 'Gallery'
  	order by `sort`
  </cfquery>
  <cfoutput>
    <div class="owl-gallery-wrap">
      <div class="owl-gallery-loader-container"><div class="owl-gallery-loader-tube-tunnel"></div></div>
      <div class="owl-carousel owl-theme owl-gallery">
        <cfloop query="getinfo">
          <div class="item">
            <a href="/images/gallery/#replace(thefile,' ','%20','all')#" class="fancybox" data-fancybox="owl-gallery-group">
              <div class="owl-lazy" data-src="/images/gallery/#replace(thefile,' ','%20','all')#" alt="#caption#"></div>
              <cfif len(caption)>
                <span class="owl-caption">#caption#</span>
              </cfif>
            </a>
          </div>
        </cfloop>
      </div>
      <div class="owl-carousel owl-theme owl-gallery-thumbs">
        <cfloop query="getinfo">
          <div class="item">
            <div class="owl-lazy" data-src="/images/gallery/#replace(thefile,' ','%20','all')#"></div>
          </div>
        </cfloop>
      </div>
    </div>
  </cfoutput>
</cfcache>