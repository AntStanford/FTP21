<cfcache key="cms_faqs" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files">

<cfquery name="getinfo" dataSource="#settings.dsn#">
  select * from cms_faqs order by sort
</cfquery>

<cfif getinfo.recordcount gt 0>
  <div class="cms-faqs-option-1">
    <div class="accordion" id="accordion">
      <cfset currentrow = 1>
      <cfoutput query="getinfo">
    	  <cfset numAsString = NumberAsString(currentrow)>
    	  <cfset numAsString = trim(numAsString)>

        <div class="card">
          <div class="card-header" id="heading#numAsString#">
            <div class="h4 card-title m-0">
              <button class="" type="button" data-toggle="collapse" data-target="##collapse#numAsString#" aria-expanded="true" aria-controls="collapse#numAsString#">
                <i class="fa fa-question-circle"></i> #question#
              </button>
            </div>
          </div>
          <div id="collapse#numAsString#" class="collapse" aria-labelledby="heading#numAsString#" data-parent="##accordion">
            <div class="card-body">
              #answer#
            </div>
          </div>
        </div>
    	  <cfset currentrow = currentrow + 1>
      </cfoutput>
    </div>
  </div>
</cfif>

</cfcache>