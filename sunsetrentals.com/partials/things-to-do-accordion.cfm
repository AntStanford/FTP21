<cfcache key="cms_thingstodo" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files">

<cfquery name="getinfo" dataSource="#settings.dsn#">
  select
    cms_thingstodo_categories.title as category,
    cms_thingstodo.*
  from cms_thingstodo
  join cms_thingstodo_categories on cms_thingstodo.catId = cms_thingstodo_categories.id
  order by category, createdAt
</cfquery>

<cfif getinfo.recordcount gt 0>
  <div class="cms-thingstodo-option-1">
    <cfset currentrow = 1>
    <cfoutput query="getinfo" group="category">
      <div class="category">
        <p class="h2 site-color-1">#category#</p>
        <div class="accordion" id="accordion-#catID#">

          <cfoutput>
        	  <cfset numAsString = NumberAsString(currentrow)>
        	  <cfset numAsString = trim(numAsString)>
            <div class="card">
              <div class="card-header" id="heading-#catID#-#numAsString#">
                <h4 class="card-title m-0">
                  <button class="" type="button" data-toggle="collapse" data-target="##collapse-#catID#-#numAsString#" aria-expanded="true" aria-controls="collapse-#catID#-#numAsString#">
                    #title#
                  </button>
                </h4>
              </div>
              <div id="collapse-#catID#-#numAsString#" class="collapse" aria-labelledby="heading-#catID#-#numAsString#" data-parent="##accordion-#catID#">
                <div class="card-body">
                  #description#
                </div>
              </div>
            </div>
        	  <cfset currentrow = currentrow + 1>
          </cfoutput>
        </div>
      </div>
    </cfoutput>
  </div>
</cfif>
</cfcache>
