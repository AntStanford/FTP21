<cfset page.title ="Galleries">

<cfquery name="getinfo" dataSource="#application.dsn#">
  select *, (select id from cms_shortcodes where externalID = cms_galleries.id) as shortCodeID 
  from cms_galleries
</cfquery>

<cfinclude template="/admin/components/header.cfm">

<cfif isdefined('url.success')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Gallery deleted!</strong>
  </div>
</cfif>

<p><a href="form.cfm" class="btn btn-success"><i class="icon-plus icon-white"></i> Add New</a></p>

<cfif getinfo.recordcount gt 0>
  <div class="widget-box">
    <div class="widget-content nopadding">
      <table class="table table-bordered table-striped">
        <tr>
          <th width="45">No.</th>
          <th>Title</th>
          <th>Shortcode</th>
          <th width="75"></th>
          <th width="50"></th>
          <th width="65"></th>
        </tr>
      <cfoutput query="getinfo">
        <tr>
          <td width="45">#currentrow#.</td>
          <td>#title#</td>
          <td><span class="click-to-copy" title="Click to Copy" data-clipboard-text="[shortcode id=#shortCodeID#/]"><xmp style="margin: 0;">[shortcode id=#shortCodeID#/]</xmp></span></td>         
          <td width="75"><a href="multi-upload-gallery/index.cfm?id=#id#" class="btn btn-mini btn-warning"><i class="icon-picture icon-white"></i> Photos</a></td>
          <td width="50"><a href="form.cfm?id=#id#" class="btn btn-mini btn-primary"><i class="icon-pencil icon-white"></i> Edit</a></td>
          <td width="65"><a href="submit.cfm?id=#id#&shortcode=#shortCodeID#&delete" class="btn btn-mini btn-danger" data-confirm="Are you sure you want to delete this gallery?"><i class="icon-remove icon-white"></i> Delete</a></td>         
        </tr>
      </cfoutput>
       </table>
    </div>
  </div>
</cfif>
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

