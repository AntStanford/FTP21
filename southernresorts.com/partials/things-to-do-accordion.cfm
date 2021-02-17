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
        <div class="panel-group" id="accordion-#catID#" role="tablist" aria-multiselectable="true">
          <cfoutput>
        	  <cfset numAsString = NumberAsString(currentrow)>
        	  <cfset numAsString = trim(numAsString)>
            <div class="panel panel-default">
              <div class="panel-heading" role="tab" id="heading-#catID#-#numAsString#">
                <h4 class="panel-title">
                  <a href="##collapse-#catID#-#numAsString#" aria-controls="collapse-#catID#-#numAsString#" aria-expanded="true" role="button" data-toggle="collapse" data-parent="##accordion-#catID#">
                    #title#
                  </a>
                </h4>
              </div>
              <div id="collapse-#catID#-#numAsString#" class="panel-collapse collapse" role="tabpanel">
                <div class="panel-body">
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
