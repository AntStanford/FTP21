<cfcache key="cms_faqs" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files">

<cfquery name="getinfo" dataSource="#settings.dsn#">
  select * from cms_faqs order by sort
</cfquery>

<div class="cms-faqs-option-2">
  <div class="row">
    <div class="col-md-4">
      <div class="list-group">
        <cfif getinfo.recordcount gt 0>
          <cfset currentrow = 1>
          <cfoutput query="getinfo">
            <a href="javascript:;" class="list-group-item" data-id="question-#currentrow#"><i class="fa fa-question-circle"></i> #question#</a>
        	  <cfset currentrow = currentrow + 1>
          </cfoutput>
        </cfif>
      </div>
    </div>
    <div class="col-md-8">
      <cfif getinfo.recordcount gt 0>
        <cfset currentrow = 1>
        <cfoutput query="getinfo">
          <div class="block" id="question-#currentrow#">
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
      </cfif>
    </div>
  </div>
</div>
</cfcache>

<cf_htmlfoot>
<script type="text/javascript">
$(document).ready(function(){
  //sets first question as active on page load
  $('.cms-faqs-option-2 .list-group a:first').addClass('site-color-1-bg').css({'color':'#fff'});
  //shows first answer on page load
  $('.cms-faqs-option-2 .block:first').show();
  //toggles answers per answer selected
  $('.cms-faqs-option-2 .list-group a').click(function(){
    var dataID = $(this).attr('data-id');
    $('.cms-faqs-option-2 .block').hide();
    $('#'+dataID+'').show();
    $('.cms-faqs-option-2 .list-group a').removeClass('site-color-1-bg').css({'color':'#333'});
    $(this).addClass('site-color-1-bg').css({'color':'#fff'});
    $(this).blur();
  });
});
</script>
</cf_htmlfoot>