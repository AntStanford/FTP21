<cfset page.title ="Gallery">
<cfset page.module = 'gallery'>
<cfinclude template="/admin/components/header.cfm">

<cfif isdefined('url.id') and LEN(url.id)>
  <cfquery name="getGallery" dataSource="#application.dsn#">
    select *, (select id from cms_shortcodes where externalID = cms_galleries.id) as shortCodeID from cms_galleries where id = <cfqueryparam value="#url.id#" cfsqltype="integer">
  </cfquery>

</cfif>

<cfoutput>
  
<cfif isdefined('url.success') and isdefined('url.id')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">x</button>
    <strong>Update successful!</strong> Continue editing this #page.module# or <a href="index.cfm">go back.</a>
  </div>
<cfelseif isdefined('url.success')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">x</button>
    <strong>Success!</strong> Add another #page.module# or <a href="index.cfm">go back.</a>
  </div>
</cfif>

  <p><a href="index.cfm" class="btn btn-primary"><i class="icon-list icon-white"></i> Back to Gallery List</a> <cfif isdefined('url.id') and LEN(url.id)><a href="multi-upload-gallery/index.cfm?id=#url.id#" class="btn btn-warning"><i class="icon-picture icon-white"></i> Edit Photos</a></cfif></p>

  <div class="widget-box">
    <div class="widget-title">
      <span class="icon">
        <i class="icon-th"></i>
      </span>
      <h5>Edit Gallery</h5>
    </div>
    <div class="widget-content nopadding">
  
      <form method="post" action="submit.cfm" class="form-horizontal" enctype="multipart/form-data">   
        <cfif parameterExists(id)>
            <input type="hidden" name="id" value="#url.id#">
            
            <cfif isdefined('getGallery.shortCodeID') and LEN(getGallery.shortCodeID)>
              <div class="control-group">
                <label class="control-label">Shortcode</label>
                <div class="controls">
                  <span class="click-to-copy" title="Click to Copy" data-clipboard-text="[shortcode id=#getGallery.shortCodeID#/]"><xmp style="margin: 0;">[shortcode id=#getGallery.shortCodeID#/]</xmp></span>
                </div>
              </div>
            </cfif>
        </cfif>

        <div class="control-group">
          <label class="control-label">Title</label>
          <div class="controls">
            <input type="text" name="title" <cfif parameterExists(id)>value="#getGallery.title#"</cfif> maxlength="255"/>
          </div>
        </div>

			  <div class="form-actions">
				 <input type="submit" value="Submit" class="btn btn-primary" name="btnSubmit">
		   </div> 

		</form>
				
				
    </div>
  </div>
  
</cfoutput>

<!--- Click to copy --->
<script type="text/javascript">
  new Clipboard('.click-to-copy');
</script>
<style>
.click-to-copy { cursor: pointer; }
.center-text { text-align: center !important; }
.center-all { text-align: center !important; vertical-align: middle !important; }
.filter-heading { margin: 0 0 5px !important; }
.filter-heading .lead { font-size: 15px; }
.filter-input { width: 100%; padding: 10px !important; }
</style>
<script type="text/javascript">
$(document).ready(function(){
  //Tooltips
  $('.click-to-copy').tooltip();
  $('.click-to-copy').click(function(){
    $('.click-to-copy').tooltip('destroy').attr('data-original-title','Click to Copy').tooltip();
    $(this).tooltip('destroy').attr('data-original-title','Copied!').tooltip('show');
  });
});
</script>

<cfinclude template="/admin/components/footer.cfm">