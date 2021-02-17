<cfcache key="cms_faqs" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files">

<cfquery name="getinfo" dataSource="#settings.dsn#">
  select * from cms_faqs order by sort
</cfquery>

<div class="cms-faqs-option-2">
  <div class="row">
    <div class="col-sm-12 col-md-4">
      <div class="list-group" id="faq-list" role="tablist">
        <cfif getinfo.recordcount gt 0>
          <cfset currentrow = 1>
          <cfoutput query="getinfo">
            <cfif currentrow eq 1>
              <a class="list-group-item list-group-item-action active" id="item-#currentrow#" data-toggle="list" href="##question-#currentrow#" role="tab" aria-controls="question-#currentrow#"><i class="fa fa-question-circle"></i> #question#</a>
            <cfelse>
              <a class="list-group-item list-group-item-action" id="item-#currentrow#" data-toggle="list" href="##question-#currentrow#" role="tab" aria-controls="question-#currentrow#"><i class="fa fa-question-circle"></i> #question#</a>
            </cfif>
        	  <cfset currentrow = currentrow + 1>
          </cfoutput>
        </cfif>
      </div>
    </div>
    <div class="col-sm-12 col-md-8">
      <cfif getinfo.recordcount gt 0>
        <div class="tab-content" id="nav-tabContent">
          <cfset currentrow = 1>
          <cfoutput query="getinfo">
            <cfif currentrow eq 1>
              <div class="tab-pane show active" id="question-#currentrow#" role="tabpanel" aria-labelledby="item-#currentrow#">
            <cfelse>
              <div class="tab-pane" id="question-#currentrow#" role="tabpanel" aria-labelledby="item-#currentrow#">
            </cfif>
              <p class="h2 site-color-2">#question#</p>
              <table class="table">
                <tr>
                  <td><i class="fa fa-check-circle"></i></td>
                  <td>#answer#</td>
                </tr>
              </table>
            </div>
            <cfset currentrow = currentrow + 1>
          </cfoutput>
        </div><!-- END tab-content -->
      </cfif>
    </div>
  </div>
</div>
</cfcache>