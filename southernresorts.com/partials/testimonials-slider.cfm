<cfcache key="cms_testimonials" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files">

<cfquery name="getinfo" dataSource="#settings.dsn#">
  select * from cms_testimonials order by createdAt
</cfquery>

<cfif getinfo.recordcount gt 0>

<div class="testimonial-wrap">
  <div class="carousel slide" data-ride="carousel" id="testimonial-carousel" data-interval="false">
    <ol class="carousel-indicators">
      <cfset counter = 0>
      <cfoutput query="getinfo">
        <li data-target="##testimonial-carousel" data-slide-to="#counter#"<cfif counter eq 0> class="active"</cfif>></li>
    	  <cfset counter = counter + 1>
      </cfoutput>
    </ol>
    <div class="carousel-inner">
      <cfset counter = 0>
      <cfoutput query="getinfo">
        <div class="item<cfif counter eq 0> active</cfif>">
          <blockquote>
            <div class="row">
              <div class="col-sm-12">
                #body#
                <small>#user#</small>
              </div>
            </div>
          </blockquote>
        </div>
    	  <cfset counter = counter + 1>
      </cfoutput>
    </div>
    <a data-slide="prev" href="#testimonial-carousel" class="left carousel-control"><i class="fa fa-chevron-left"></i></a>
    <a data-slide="next" href="#testimonial-carousel" class="right carousel-control"><i class="fa fa-chevron-right"></i></a>
  </div>
</div>

</cfif>

</cfcache>