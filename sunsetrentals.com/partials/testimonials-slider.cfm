<cfcache key="cms_testimonials" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files">

<cfquery name="getinfo" dataSource="#settings.dsn#">
  select * from cms_testimonials order by createdAt
</cfquery>

<cfif getinfo.recordcount gt 0>

<div class="testimonial-wrap">
  <div class="owl-carousel owl-theme testimonial-carousel">
    <cfset counter = 0>
    <cfoutput query="getinfo">
      <div class="item">
        <blockquote>
          <div class="row">
            <div class="col">
              #body#
              <small>#user#</small>
            </div>
          </div>
        </blockquote>
      </div>
  	  <cfset counter = counter + 1>
    </cfoutput>
  </div>
</div>

</cfif>

</cfcache>