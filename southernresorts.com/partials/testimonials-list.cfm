<cfcache key="cms_testimonials" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files">

<cfquery name="getinfo" dataSource="#settings.dsn#">
  select * from cms_testimonials order by createdAt
</cfquery>

<cfif getinfo.recordcount gt 0>
<div class="testimonial-wrap">
  <cfoutput query="getinfo">
    <blockquote class="testimonial-item">
      <span class="testimonial-text">#body#</span>
      <span class="testimonial-user">#user#</span>
    </blockquote>
  </cfoutput>
</div>
</cfif>

</cfcache>