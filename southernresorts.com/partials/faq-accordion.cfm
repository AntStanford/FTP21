<cfcache key="cms_faqs" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files">

<cfquery name="getinfo" dataSource="#settings.dsn#">
  select * from cms_faqs order by sort
</cfquery>

<cfif getinfo.recordcount gt 0>
  <div class="cms-faqs-option-1">
    <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
      <cfset currentrow = 1>
      <cfoutput query="getinfo">
    	  <cfset numAsString = NumberAsString(currentrow)>
    	  <cfset numAsString = trim(numAsString)>
        <div class="panel panel-default">
          <div class="panel-heading" role="tab" id="heading#numAsString#">
            <div class="h4 panel-title">
              <a href="##collapse#numAsString#" aria-controls="collapse#numAsString#" role="button" data-toggle="collapse" data-parent="##accordion">
                <i class="fa fa-plus"></i> #question#
              </a>
            </div>
          </div>
          <div id="collapse#numAsString#" class="panel-collapse collapse" role="tabpanel">
            <div class="panel-body">
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
