<cfcache key="cms_thingstodo" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files">
  <cfquery name="getinfo" dataSource="#settings.dsn#">
    select
      cms_thingstodo_categories.title as category,
      cms_thingstodo_categories.photo as categoryPhoto,
      cms_thingstodo_categories.slug as categorySlug,
      cms_thingstodo.*
    from cms_thingstodo
    join cms_thingstodo_categories on cms_thingstodo.catId = cms_thingstodo_categories.id
    order by category, createdAt
  </cfquery>
  <cfif getinfo.recordcount gt 0>
    <div class="cms-thingstodo-option-2">
      <div class="row">
        <cfset currentrow = 1>
        <cfoutput query="getinfo" group="category">
          <div class="col-md-6">
            <div class="hover-border">
              <cfif len(categoryPhoto)>
              	<img src="/images/thingstodo/#getinfo.categoryPhoto#">
              <cfelse>
              	<img src="http://placehold.it/400x300&text=placeholder">
              </cfif>
              <span>
                <em class="h2">#category#</em>
                <p class="view">View <i class="glyphicon glyphicon-chevron-right"></i></p>
                <a href="/thingstodo/#categorySlug#">#category#</a>
              </span>
            </div>
          </div>
      	  <cfset currentrow = currentrow + 1>
        </cfoutput>
      </div>
    </div>
  </cfif>
</cfcache>