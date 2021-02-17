<cfif !isdefined('url.id')>
  <p>You cannot access this page.</p>
  <cfabort>
</cfif>

<cfif isdefined('url.clearDraft')>
  <cfquery name="ClearDraft" datasource="#settings.dsn#">
    Update cms_pages
    set draftBody = NULL, draftDate = NULL
    where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>
  <cflocation url="edit-page.cfm?id=#url.id#" addtoken="false">
</cfif>

<cfheader name="X-XSS-Protection" value="0">

<cfif isdefined('form.hidcontentDraft') and form.hidcontentDraft neq ''>
  <!--- Grammarly puts all kinds of goofy stuff in here, so I'm getting rid of it --->
  <cfset newNewbody = form.hidcontentDraft>
  <cfset newNewbody = REReplaceNoCase(newNewbody, "<grammarly-btn>.*?</grammarly-btn>", '', 'all')>
  <cfset newNewbody = REReplaceNoCase(newNewbody, "<g.*?>", "", "ALL")>
  <cfset newNewbody = ReplaceNoCase(newNewbody, "</g>", "", "ALL")>
  <cfset newNewbody = REReplaceNoCase(newNewbody, 'data-gramm.*?".*?"', "", "ALL")>
  <!--- We need to update the page body --->
  <cfquery dataSource="#settings.dsn#">
    update cms_pages set draftbody = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#newNewbody#">, draftDate = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">
    where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.pageid#">
  </cfquery>
  <cfset url.viewDraft = true>
<cfelseif isdefined('form.hidcontent') and form.hidcontent neq ''>
  <!--- Grammarly puts all kinds of goofy stuff in here, so I'm getting rid of it --->
  <cfset newNewbody = form.hidcontent>
  <cfset newNewbody = REReplaceNoCase(newNewbody, "<grammarly-btn>.*?</grammarly-btn>", '', 'all')>
  <cfset newNewbody = REReplaceNoCase(newNewbody, "<g.*?>", "", "ALL")>
  <cfset newNewbody = ReplaceNoCase(newNewbody, "</g>", "", "ALL")>
  <cfset newNewbody = REReplaceNoCase(newNewbody, 'data-gramm.*?".*?"', "", "ALL")>
  <!--- We need to update the page body --->
  <cfquery dataSource="#settings.dsn#">
    update cms_pages set body = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#newNewbody#">,draftBody = NULL,draftDate = NULL
    where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.pageid#">
  </cfquery>
</cfif>

<cfquery name="getPageBody" dataSource="#settings.dsn#">
  select name, layout, slug, body, draftbody, draftdate from cms_pages where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
</cfquery>
<cfif getPageBody.draftbody neq ''>
  <cfset url.viewDraft = true>
</cfif>

<cfinclude template="/components/header.cfm">

<title>[Edit] - <cfoutput>#getPageBody.name#</cfoutput></title>

<link href="contentbuilder/contentbuilder.css" rel="stylesheet" type="text/css">
<!--- Specific Styling for this page only --->
<style>
/* Fixes for edit page */
.alert { margin: 0; border-radius: 0; }
.i-content { padding-bottom: 200px; }
.i-header,
.i-hero-wrap,
.i-footer,
.i-callouts { opacity: 0.5 !important; pointer-events: none; }
.i-content .container .row h1,
.content-builder-wrap { width: 100%; }
.i-wrapper { margin: 0 !important; }
#cartAbandonment { display: none !important; }
input[type=checkbox] { display: inline-block; }
#panelCms { background: #fff; border-top: 1px #ccc solid; position: fixed; bottom: 0; left: 0; right: 0; z-index: 2; padding: 15px; text-align: center; }
/* CSS Loading Wrapper */
.cssload-wrap { position: absolute; top: 50%; left: 50%; transform: translate(-50%,-50%); width: 60px; height: 60px; margin: 0 auto; padding: 20px; box-sizing: content-box; }
.cssload-wrap-tube-tunnel { width: 100%; height: 100%; margin: 0 auto; border: 3px solid #444; border-radius: 50%; -o-animation: cssload-wrap-scale 1.1s infinite linear; -ms-animation: cssload-wrap-scale 1.1s infinite linear; -webkit-animation: cssload-wrap-scale 1.1s infinite linear; -moz-animation: cssload-wrap-scale 1.1s infinite linear; animation: cssload-wrap-scale 1.1s infinite linear; }
@-o-keyframes cssload-wrap-scale{ 0% { -o-transform:scale(0); transform:scale(0) } 90%{ -o-transform:scale(0.7); transform:scale(0.7) } 100%{ -o-transform:scale(1); transform:scale(1) } }
@-ms-keyframes cssload-wrap-scale{ 0%{ -ms-transform:scale(0); transform:scale(0) }90%{ -ms-transform:scale(0.7); transform:scale(0.7) }100%{ -ms-transform:scale(1); transform:scale(1) } }
@-webkit-keyframes cssload-wrap-scale{ 0%{ -webkit-transform:scale(0); transform:scale(0) }90%{ -webkit-transform:scale(0.7); transform:scale(0.7) }100%{ -webkit-transform:scale(1); transform:scale(1) } }
@-moz-keyframes cssload-wrap-scale{ 0%{ -moz-transform:scale(0); transform:scale(0) }90%{ -moz-transform:scale(0.7); transform:scale(0.7) }100%{ -moz-transform:scale(1); transform:scale(1) } }
@keyframes cssload-wrap-scale { 0%{ transform:scale(0) }90%{ transform:scale(0.7) }100%{ transform:scale(1) } }
#loading { opacity: 0.75; position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 9999999; background: #fff; width: 100%; height: 100%; }
/* Exclude Font Choices from Editor */
#rte-toolbar button[data-rte-cmd=font] { display: none; }
/* Add Note to Link Modal */
#md-createlink .md-body .md-modal-handle + .md-label { height: auto; }
#md-createlink .md-body .md-modal-handle + .md-label:after { content: "*copy and paste the entire URL including http or https"; display: block; color: red; line-height: normal; text-transform: none; margin: -18px 0 0; font-style: italic; }
</style>

<cfif isdefined('url.clearDraft')>
  <div class="alert alert-success text-center" id="ClearDraftAlert">
    <button type="button" class="close pull-left" data-dismiss="alert" aria-label="Close">
      <span aria-hidden="true">&times;</span>
    </button>
    <p><b>Draft has been cleared</b> You are now viewing the live content.</p>
  </div>
  <cf_htmlfoot>
  <script type="text/javascript">
  $(document).ready(function(){
    setTimeout(function(){
      $('#ClearDraftAlert').slideUp(400);
    }, 6000);
  });
  </script>
  </cf_htmlfoot>
</cfif>

<cfif isdefined('url.viewDraft')>
  <div class="alert alert-info text-center" id="DraftAlert">
    <button type="button" class="close pull-left" data-dismiss="alert" aria-label="Close">
      <span aria-hidden="true">&times;</span>
    </button>
    <p><b>You are editing a draft</b> This draft was last updated on <cfoutput>#dateformat(getPageBody.draftdate,'m/d/yyyy')#</cfoutput>.</p>
  </div>
  <cf_htmlfoot>
  <script type="text/javascript">
  $(document).ready(function(){
    setTimeout(function(){
      $('#DraftAlert').slideUp(400);
    }, 6000);
  });
  </script>
  </cf_htmlfoot>
</cfif>

<cfif isdefined('form.hidcontent')>
  <div class="alert alert-success text-center" id="SuccessAlert">
    <button type="button" class="close pull-left" data-dismiss="alert" aria-label="Close">
      <span aria-hidden="true">&times;</span>
    </button>
    <p>
      <b>Success! The page content has been updated.</b><br>
      Continue editing the page content or close this window.
    </p>
  </div>
  <cf_htmlfoot>
  <script type="text/javascript">
  $(document).ready(function(){
    setTimeout(function(){
      $('#SuccessAlert').slideUp(400);
    }, 6000);
  });
  </script>
  </cf_htmlfoot>
</cfif>

<div class="i-content">
  <div class="container">
  	<div class="row">
    	<cfif getPageBody.layout eq 'Default.cfm'>
    		<div class="col-lg-9 col-md-8 col-sm-12">
    	<cfelseif getPageBody.layout eq 'Full.cfm'>
    		<div class="col-lg-12 col-md-12 col-sm-12">
    	<cfelseif getPageBody.layout eq 'Left-sidebar.cfm'>
    		<div class="col-lg-3 col-md-4 col-sm-12">
      		<div class="i-sidebar">
      			<cfinclude template="/components/callouts.cfm">
      		</div>
    		</div>
    		<div class="col-lg-9 col-md-8 col-sm-12">
    	</cfif>
        <h1 class="site-color-1"><cfoutput>#getPageBody.name#</cfoutput></h1>
        <div class="content-builder-wrap">
          <div id="contentarea" class="is-container" data-gramm="false">
            <cfif isdefined('url.viewDraft')>
              <cfoutput>#getPageBody.draftbody#</cfoutput>
            <cfelse>
              <cfoutput>#getPageBody.body#</cfoutput>
            </cfif>
          </div>
        </div>
    	<cfif getPageBody.layout eq 'Default.cfm'>
    		</div>
    		<div class="col-lg-3 col-md-4 col-sm-12">
      		<div class="i-sidebar">
      			<cfinclude template="/components/callouts.cfm">
      		</div>
    		</div>
    	<cfelseif getPageBody.layout eq 'Full.cfm'>
    		</div>
    	<cfelseif getPageBody.layout eq 'Left-sidebar.cfm'>
    		</div>
    	</cfif>
  	</div>
  </div>
</div>

<!-- Hidden Form Fields to post content -->
<form id="form1" method="post" class="hidden">
  <input type="hidden" id="hidContent" name="hidContent" />
  <input type="hidden" id="hidContentDraft" name="hidContentDraft" />
  <input type="submit" id="btnPost" value="submit" />
  <cfoutput><input type="hidden" name="pageID" value="#url.id#"></cfoutput>
</form>

<!-- CUSTOM PANEL (can be used for "save" button or your own custom buttons) -->
<div id="panelCms">
  <button onclick="save()" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white" style="margin-right:5px;"><i class="fa fa-floppy-o" aria-hidden="true"></i> Publish Live</button>
  <button onclick="saveDraft()" class="btn site-color-2-bg site-color-2-lighten-bg-hover text-white" style="margin-right:5px;"><i class="fa fa-floppy-o" aria-hidden="true"></i> Save Draft</button>
  <cfoutput><a href="/#getPageBody.slug#" target="_blank" class="btn btn-default" style="margin-right:5px;"><i class="fa fa-eye" aria-hidden="true"></i> View Live</a></cfoutput>
  <cfif getpagebody.draftBody neq ''>
    <cfoutput><a href="edit-page.cfm?id=#url.id#&clearDraft" class="btn btn-danger"><i class="icon-remove icon-white"></i> Clear Draft</a></cfoutput>
  </cfif>
</div>

<div id="loading" class="hidden">
  <div class="cssload-wrap">
    <div class="cssload-wrap-tube-tunnel"></div>
  </div>
</div>

<cf_htmlfoot>
<script src="contentbuilder/contentbuilder.js" type="text/javascript"></script>
<script src="contentbuilder/saveimages.js" type="text/javascript"></script>
<script type="text/javascript">
function removeGrammarly() {
  //Remove Grammarly Elements
  $('grammarly-extension').remove();
  $('.u_fNK').remove();
}
$(document).ready(function() {
  // Check if there's empty HTML elements and remove them
  var contentAreaEmptyHTML = $.trim($('#contentarea').text()).length == 0;
  if ( contentAreaEmptyHTML == true ) {
    $('#contentarea').empty();
    console.log('*** Removed Empty Content Builder HTML ***');
  }
  removeGrammarly();
  $('#contentarea').contentbuilder({
    snippetFile: 'assets/minimalist-basic/snippets-bootstrap-icnd.html',
    snippetOpen: true,
    iconselect: 'assets/ionicons/selecticon.html'
  });
});
function save() {
  //Save all images first
  $('#contentarea').saveimages({
    handler: 'saveimage.cfm',
    onComplete: function () {
      removeGrammarly();
      //Then save the content
      var sContent = $('#contentarea').data('contentbuilder').html(); //Get content
      //Check if content is blank, if so give a space value to save in DB
      if ( $.trim($('#contentarea').text()).length == 0 ) {
        $('#hidContent').val(' ');
      } else {
        $('#hidContent').val(sContent);
      }
      $('#btnPost').click();
    }
  });
  $('#contentarea').data('saveimages').save();
  $('#loading').removeClass('hidden');
}
function saveDraft() {
  //Save all images first
  $('#contentarea').saveimages({
    handler: 'saveimage.cfm',
    onComplete: function () {
      removeGrammarly();
      //Then save the content
      var sContentDraft = $('#contentarea').data('contentbuilder').html(); //Get content
      //Check if content is blank, if so give a space value to save in DB
      if ( $.trim($('#contentarea').text()).length == 0 ) {
        $('#hidContentDraft').val(' ');
      } else {
        $('#hidContentDraft').val(sContentDraft);
      }
      $('#btnPost').click();
    }
  });
  $('#contentarea').data('saveimages').save();
  $('#loading').removeClass('hidden');
}
</script>
</cf_htmlfoot>

<cfinclude template="/components/footer.cfm">